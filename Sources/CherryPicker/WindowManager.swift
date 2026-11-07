import Cocoa
import ApplicationServices

public enum WindowAction: String, CaseIterable, Identifiable {
    case leftHalf = "Left Half"
    case rightHalf = "Right Half"
    case topHalf = "Top Half"
    case bottomHalf = "Bottom Half"
    case maximize = "Maximize"
    case center = "Center"
    case topLeftQuarter = "Top-Left Quarter"
    case topRightQuarter = "Top-Right Quarter"
    case bottomLeftQuarter = "Bottom-Left Quarter"
    case bottomRightQuarter = "Bottom-Right Quarter"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .leftHalf: return "arrow.left.to.line"
        case .rightHalf: return "arrow.right.to.line"
        case .topHalf: return "arrow.up.to.line"
        case .bottomHalf: return "arrow.down.to.line"
        case .maximize: return "arrow.up.left.and.arrow.down.right"
        case .center: return "dot.viewfinder"
        case .topLeftQuarter: return "square.topthird.inset.filled"
        case .topRightQuarter: return "square.topthird.inset.filled"
        case .bottomLeftQuarter: return "square.bottomthird.inset.filled"
        case .bottomRightQuarter: return "square.bottomthird.inset.filled"
        }
    }
}

public final class WindowManager {
    public static let shared = WindowManager()
    private init() {}

    /// Sprawdza czy aplikacja posiada uprawnienia Accessibility
    public func isAccessibilityGranted(prompt: Bool = false) -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: prompt]
        return AXIsProcessTrustedWithOptions(options as CFDictionary)
    }

    /// Pobiera docelową aplikację do manipulacji oknem
    public func getTargetApplication() -> NSRunningApplication? {
        if let frontApp = NSWorkspace.shared.frontmostApplication,
           frontApp.processIdentifier != NSRunningApplication.current.processIdentifier {
            return frontApp
        }
        return FrontmostAppTracker.shared.targetApplication
    }

    /// Pobiera okno docelowej aplikacji
    public func getFrontmostWindow() -> (element: AXUIElement, pid: pid_t)? {
        guard let targetApp = getTargetApplication() else {
            return nil
        }
        let pid = targetApp.processIdentifier
        let appElement = AXUIElementCreateApplication(pid)

        // 1. Sprawdź okno skupione (Focused Window)
        var focusedWindow: CFTypeRef?
        let status = AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &focusedWindow)

        if status == .success, let window = focusedWindow, CFGetTypeID(window) == AXUIElementGetTypeID() {
            let winElement = window as! AXUIElement
            if isWindowResizable(winElement) {
                return (winElement, pid)
            }
        }

        // 2. Fallback: przeszukaj listę okien aplikacji (kAXWindowsAttribute)
        var windowsRef: CFTypeRef?
        if AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef) == .success,
           let windowList = windowsRef as? [AXUIElement] {
            for win in windowList {
                if isWindowResizable(win) {
                    return (win, pid)
                }
            }
        }

        // 3. Fallback do skupionego elementu potomnego w drzewie UI
        let systemWide = AXUIElementCreateSystemWide()
        var focusedUIElement: CFTypeRef?
        if AXUIElementCopyAttributeValue(systemWide, kAXFocusedUIElementAttribute as CFString, &focusedUIElement) == .success,
           let uiElement = focusedUIElement {
            var parentWindow: CFTypeRef?
            if AXUIElementCopyAttributeValue(uiElement as! AXUIElement, kAXWindowAttribute as CFString, &parentWindow) == .success,
               let win = parentWindow {
                return (win as! AXUIElement, pid)
            }
        }

        return nil
    }

    private func isWindowResizable(_ window: AXUIElement) -> Bool {
        var subrole: CFTypeRef?
        if AXUIElementCopyAttributeValue(window, kAXSubroleAttribute as CFString, &subrole) == .success,
           let subroleStr = subrole as? String {
            if subroleStr == "AXSystemDialog" || subroleStr == "AXSheet" {
                return false
            }
        }
        return true
    }

    public func getWindowRect(_ window: AXUIElement) -> CGRect? {
        var posRef: CFTypeRef?
        var sizeRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(window, kAXPositionAttribute as CFString, &posRef) == .success,
              AXUIElementCopyAttributeValue(window, kAXSizeAttribute as CFString, &sizeRef) == .success else {
            return nil
        }
        var point = CGPoint.zero
        var size = CGSize.zero
        AXValueGetValue(posRef as! AXValue, .cgPoint, &point)
        AXValueGetValue(sizeRef as! AXValue, .cgSize, &size)
        return CGRect(origin: point, size: size)
    }

    public func applyAction(_ action: WindowAction) {
        guard isAccessibilityGranted(prompt: true) else {
            print("[WindowManager] Brak uprawnień Dostępności (Accessibility).")
            return
        }

        // Upewnij się, że docelowa aplikacja powraca na pierwszy plan
        FrontmostAppTracker.shared.bringTargetAppToFront()

        guard let (window, pid) = getFrontmostWindow(),
              let currentWinRect = getWindowRect(window) else {
            print("[WindowManager] Nie odnaleziono aktywnego okna.")
            return
        }

        guard let screen = findScreen(for: currentWinRect) else { return }

        let axScreenRect = convertToAXCoordinates(screen: screen)
        let targetRect = calculateTargetRect(action: action, screenRect: axScreenRect, currentWindowRect: currentWinRect)

        setWindowRectWithElectronWorkaround(window: window, pid: pid, targetRect: targetRect)
    }

    private func findScreen(for windowRect: CGRect) -> NSScreen? {
        let screens = NSScreen.screens
        return screens.max(by: { s1, s2 in
            let r1 = convertToAXCoordinates(screen: s1).intersection(windowRect)
            let r2 = convertToAXCoordinates(screen: s2).intersection(windowRect)
            return (r1.width * r1.height) < (r2.width * r2.height)
        }) ?? NSScreen.main
    }

    /// Konwersja ramki roboczej Cocoa (visibleFrame) do układu Accessibility (odwrócenie osi Y)
    private func convertToAXCoordinates(screen: NSScreen) -> CGRect {
        let primaryScreenHeight = NSScreen.screens.first?.frame.height ?? 0
        let visible = screen.visibleFrame
        let axX = visible.origin.x
        let axY = primaryScreenHeight - (visible.origin.y + visible.height)
        return CGRect(x: axX, y: axY, width: visible.width, height: visible.height)
    }

    private func calculateTargetRect(action: WindowAction, screenRect: CGRect, currentWindowRect: CGRect) -> CGRect {
        let (x, y, w, h) = (screenRect.origin.x, screenRect.origin.y, screenRect.width, screenRect.height)

        switch action {
        case .leftHalf:
            return CGRect(x: x, y: y, width: w / 2, height: h)
        case .rightHalf:
            return CGRect(x: x + w / 2, y: y, width: w / 2, height: h)
        case .topHalf:
            return CGRect(x: x, y: y, width: w, height: h / 2)
        case .bottomHalf:
            return CGRect(x: x, y: y + h / 2, width: w, height: h / 2)
        case .maximize:
            return CGRect(x: x, y: y, width: w, height: h)
        case .center:
            let targetW = min(currentWindowRect.width, w)
            let targetH = min(currentWindowRect.height, h)
            return CGRect(x: x + (w - targetW) / 2, y: y + (h - targetH) / 2, width: targetW, height: targetH)
        case .topLeftQuarter:
            return CGRect(x: x, y: y, width: w / 2, height: h / 2)
        case .topRightQuarter:
            return CGRect(x: x + w / 2, y: y, width: w / 2, height: h / 2)
        case .bottomLeftQuarter:
            return CGRect(x: x, y: y + h / 2, width: w / 2, height: h / 2)
        case .bottomRightQuarter:
            return CGRect(x: x + w / 2, y: y + h / 2, width: w / 2, height: h / 2)
        }
    }

    /// Implementacja obejścia błędu Electron/Chromium (AXEnhancedUserInterface) oraz sekwencji Pozycja-Rozmiar-Pozycja
    private func setWindowRectWithElectronWorkaround(window: AXUIElement, pid: pid_t, targetRect: CGRect) {
        let appElement = AXUIElementCreateApplication(pid)
        var enhancedUIRef: CFTypeRef?
        var hadEnhancedUI = false

        if AXUIElementCopyAttributeValue(appElement, "AXEnhancedUserInterface" as CFString, &enhancedUIRef) == .success,
           let isEnhanced = enhancedUIRef as? Bool, isEnhanced {
            hadEnhancedUI = true
            AXUIElementSetAttributeValue(appElement, "AXEnhancedUserInterface" as CFString, kCFBooleanFalse)
        }

        var pos = targetRect.origin
        var size = targetRect.size
        if let posVal = AXValueCreate(.cgPoint, &pos),
           let sizeVal = AXValueCreate(.cgSize, &size) {
            // Sekwencja trójkroku: Pozycja -> Rozmiar -> Pozycja
            AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, posVal)
            AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeVal)
            AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, posVal)
        }

        if hadEnhancedUI {
            AXUIElementSetAttributeValue(appElement, "AXEnhancedUserInterface" as CFString, kCFBooleanTrue)
        }
    }
}
