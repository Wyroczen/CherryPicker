import Cocoa
import ApplicationServices

public enum WindowAction: String, CaseIterable, Identifiable, Sendable {
    // Połowy (Halves)
    case leftHalf = "Left Half"
    case rightHalf = "Right Half"
    case topHalf = "Top Half"
    case bottomHalf = "Bottom Half"
    case centerHalf = "Center Half"

    // Jedna trzecia (Thirds - 1/3)
    case firstThird = "First Third"
    case centerThird = "Center Third"
    case lastThird = "Last Third"
    case topThird = "Top Third"
    case middleThird = "Middle Third"
    case bottomThird = "Bottom Third"

    // Dwie trzecie (Two Thirds - 2/3)
    case firstTwoThirds = "First Two Thirds"
    case centerTwoThirds = "Center Two Thirds"
    case lastTwoThirds = "Last Two Thirds"
    case topTwoThirds = "Top Two Thirds"
    case bottomTwoThirds = "Bottom Two Thirds"
    case topCenterTwoThirds = "Top Center Two Thirds"
    case bottomCenterTwoThirds = "Bottom Center Two Thirds"

    // Ćwiartki (Quarters)
    case topLeftQuarter = "Top-Left Quarter"
    case topRightQuarter = "Top-Right Quarter"
    case bottomLeftQuarter = "Bottom-Left Quarter"
    case bottomRightQuarter = "Bottom-Right Quarter"

    // Jedna czwarta (Fourths - 1/4)
    case firstFourth = "First Fourth"
    case secondFourth = "Second Fourth"
    case thirdFourth = "Third Fourth"
    case lastFourth = "Last Fourth"
    case topFirstFourth = "Top First Fourth"
    case topSecondFourth = "Top Second Fourth"
    case topThirdFourth = "Top Third Fourth"
    case topLastFourth = "Top Last Fourth"

    // Trzy czwarte (Three Fourths - 3/4)
    case firstThreeFourths = "First Three Fourths"
    case centerThreeFourths = "Center Three Fourths"
    case lastThreeFourths = "Last Three Fourths"
    case topThreeFourths = "Top Three Fourths"
    case bottomThreeFourths = "Bottom Three Fourths"

    // Szóstki (Sixths - 1/6)
    case topLeftSixth = "Top-Left Sixth"
    case topCenterSixth = "Top-Center Sixth"
    case topRightSixth = "Top-Right Sixth"
    case bottomLeftSixth = "Bottom-Left Sixth"
    case bottomCenterSixth = "Bottom-Center Sixth"
    case bottomRightSixth = "Bottom-Right Sixth"

    // Maksymalizacja i skalowanie
    case maximize = "Maximize"
    case almostMaximize = "Almost Maximize"
    case maximizeHeight = "Maximize Height"
    case maximizeWidth = "Maximize Width"
    case reasonableSize = "Reasonable Size"
    case center = "Center"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .leftHalf: return "arrow.left.to.line"
        case .rightHalf: return "arrow.right.to.line"
        case .topHalf: return "arrow.up.to.line"
        case .bottomHalf: return "arrow.down.to.line"
        case .centerHalf: return "rectangle.center.inset.filled"

        case .firstThird, .centerThird, .lastThird: return "rectangle.split.3x1"
        case .topThird, .middleThird, .bottomThird: return "rectangle.split.1x2"

        case .firstTwoThirds: return "rectangle.leadinghalf.inset.filled"
        case .centerTwoThirds: return "rectangle.center.inset.filled"
        case .lastTwoThirds: return "rectangle.trailinghalf.inset.filled"
        case .topTwoThirds: return "rectangle.tophalf.inset.filled"
        case .bottomTwoThirds: return "rectangle.bottomhalf.inset.filled"
        case .topCenterTwoThirds, .bottomCenterTwoThirds: return "square.inset.filled"

        case .topLeftQuarter, .topRightQuarter: return "square.topthird.inset.filled"
        case .bottomLeftQuarter, .bottomRightQuarter: return "square.bottomthird.inset.filled"

        case .firstFourth, .secondFourth, .thirdFourth, .lastFourth: return "rectangle.split.3x1"
        case .topFirstFourth, .topSecondFourth, .topThirdFourth, .topLastFourth: return "rectangle.split.1x2"

        case .firstThreeFourths: return "rectangle.leadinghalf.inset.filled"
        case .centerThreeFourths: return "rectangle.center.inset.filled"
        case .lastThreeFourths: return "rectangle.trailinghalf.inset.filled"
        case .topThreeFourths: return "rectangle.tophalf.inset.filled"
        case .bottomThreeFourths: return "rectangle.bottomhalf.inset.filled"

        case .topLeftSixth, .topCenterSixth, .topRightSixth,
             .bottomLeftSixth, .bottomCenterSixth, .bottomRightSixth:
            return "square.grid.3x2"

        case .maximize: return "arrow.up.left.and.arrow.down.right"
        case .almostMaximize: return "arrow.up.left.and.arrow.down.right.circle"
        case .maximizeHeight: return "arrow.up.and.down"
        case .maximizeWidth: return "arrow.left.and.right"
        case .reasonableSize: return "aspectratio"
        case .center: return "dot.viewfinder"
        }
    }

    public var descriptionText: String {
        switch self {
        case .leftHalf: return "Left half of screen (50% width)"
        case .rightHalf: return "Right half of screen (50% width)"
        case .topHalf: return "Top half of screen (50% height)"
        case .bottomHalf: return "Bottom half of screen (50% height)"
        case .centerHalf: return "Centered 50% screen width"

        case .firstThird: return "Left third of screen (33% width)"
        case .centerThird: return "Center third of screen (33% width)"
        case .lastThird: return "Right third of screen (33% width)"
        case .topThird: return "Top third of screen (33% height)"
        case .middleThird: return "Middle horizontal third (33% height)"
        case .bottomThird: return "Bottom third of screen (33% height)"

        case .firstTwoThirds: return "Left two thirds of screen (67% width)"
        case .centerTwoThirds: return "Center two thirds of screen (67% width)"
        case .lastTwoThirds: return "Right two thirds of screen (67% width)"
        case .topTwoThirds: return "Top two thirds of screen (67% height)"
        case .bottomTwoThirds: return "Bottom two thirds of screen (67% height)"
        case .topCenterTwoThirds: return "Top centered 2/3 width and height"
        case .bottomCenterTwoThirds: return "Bottom centered 2/3 width and height"

        case .topLeftQuarter: return "Top-left quarter of screen"
        case .topRightQuarter: return "Top-right quarter of screen"
        case .bottomLeftQuarter: return "Bottom-left quarter of screen"
        case .bottomRightQuarter: return "Bottom-right quarter of screen"

        case .firstFourth: return "First vertical column (25% width)"
        case .secondFourth: return "Second vertical column (25% width)"
        case .thirdFourth: return "Third vertical column (25% width)"
        case .lastFourth: return "Fourth vertical column (25% width)"
        case .topFirstFourth: return "Top first horizontal band (25% height)"
        case .topSecondFourth: return "Top second horizontal band (25% height)"
        case .topThirdFourth: return "Top third horizontal band (25% height)"
        case .topLastFourth: return "Top last horizontal band (25% height)"

        case .firstThreeFourths: return "Left three fourths of screen (75% width)"
        case .centerThreeFourths: return "Center three fourths of screen (75% width)"
        case .lastThreeFourths: return "Right three fourths of screen (75% width)"
        case .topThreeFourths: return "Top three fourths of screen (75% height)"
        case .bottomThreeFourths: return "Bottom three fourths of screen (75% height)"

        case .topLeftSixth: return "Top-left one sixth (33% x 50%)"
        case .topCenterSixth: return "Top-center one sixth (33% x 50%)"
        case .topRightSixth: return "Top-right one sixth (33% x 50%)"
        case .bottomLeftSixth: return "Bottom-left one sixth (33% x 50%)"
        case .bottomCenterSixth: return "Bottom-center one sixth (33% x 50%)"
        case .bottomRightSixth: return "Bottom-right one sixth (33% x 50%)"

        case .maximize: return "Maximize window to full screen (100%)"
        case .almostMaximize: return "Almost maximize (90% of screen)"
        case .maximizeHeight: return "Maximize height (100% height)"
        case .maximizeWidth: return "Maximize width (100% width)"
        case .reasonableSize: return "Optimal size (60% of screen, max 1024x900)"
        case .center: return "Center window on screen"
        }
    }

    public var searchKeywords: [String] {
        var keys = [rawValue.lowercased()]
        switch self {
        case .leftHalf: keys += ["left", "half", "side", "50%"]
        case .rightHalf: keys += ["right", "half", "side", "50%"]
        case .topHalf: keys += ["top", "half", "upper", "50%"]
        case .bottomHalf: keys += ["bottom", "half", "lower", "50%"]
        case .centerHalf: keys += ["center", "half", "middle", "50%"]

        case .firstThird: keys += ["third", "1/3", "left", "first"]
        case .centerThird: keys += ["third", "1/3", "center", "middle"]
        case .lastThird: keys += ["third", "1/3", "right", "last"]
        case .topThird: keys += ["third", "1/3", "top", "upper"]
        case .middleThird: keys += ["third", "1/3", "middle", "center"]
        case .bottomThird: keys += ["third", "1/3", "bottom", "lower"]

        case .firstTwoThirds: keys += ["two thirds", "2/3", "left"]
        case .centerTwoThirds: keys += ["two thirds", "2/3", "center"]
        case .lastTwoThirds: keys += ["two thirds", "2/3", "right"]
        case .topTwoThirds: keys += ["two thirds", "2/3", "top"]
        case .bottomTwoThirds: keys += ["two thirds", "2/3", "bottom"]
        case .topCenterTwoThirds, .bottomCenterTwoThirds: keys += ["two thirds", "2/3", "square", "center"]

        case .topLeftQuarter: keys += ["quarter", "1/4", "top left", "corner"]
        case .topRightQuarter: keys += ["quarter", "1/4", "top right", "corner"]
        case .bottomLeftQuarter: keys += ["quarter", "1/4", "bottom left", "corner"]
        case .bottomRightQuarter: keys += ["quarter", "1/4", "bottom right", "corner"]

        case .firstFourth, .secondFourth, .thirdFourth, .lastFourth:
            keys += ["fourth", "1/4", "column", "quarter"]
        case .topFirstFourth, .topSecondFourth, .topThirdFourth, .topLastFourth:
            keys += ["fourth", "1/4", "band", "row", "horizontal"]

        case .firstThreeFourths, .centerThreeFourths, .lastThreeFourths,
             .topThreeFourths, .bottomThreeFourths:
            keys += ["three fourths", "3/4", "75%"]

        case .topLeftSixth, .topCenterSixth, .topRightSixth,
             .bottomLeftSixth, .bottomCenterSixth, .bottomRightSixth:
            keys += ["sixth", "1/6", "grid"]

        case .maximize: keys += ["max", "maximize", "full", "fullscreen", "100%"]
        case .almostMaximize: keys += ["almost", "almost maximize", "90%"]
        case .maximizeHeight: keys += ["height", "maximize height", "tall"]
        case .maximizeWidth: keys += ["width", "maximize width", "wide"]
        case .reasonableSize: keys += ["reasonable", "optimal", "size", "60%"]
        case .center: keys += ["center", "middle", "centre"]
        }
        return keys
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
            print("[WindowManager] Accessibility permission not granted.")
            return
        }

        // Upewnij się, że docelowa aplikacja powraca na pierwszy plan
        FrontmostAppTracker.shared.bringTargetAppToFront()

        guard let (window, pid) = getFrontmostWindow(),
              let currentWinRect = getWindowRect(window) else {
            print("[WindowManager] Active window not found.")
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
        // Połowy (Halves)
        case .leftHalf:
            return CGRect(x: x, y: y, width: w / 2, height: h)
        case .rightHalf:
            return CGRect(x: x + w / 2, y: y, width: w / 2, height: h)
        case .topHalf:
            return CGRect(x: x, y: y, width: w, height: h / 2)
        case .bottomHalf:
            return CGRect(x: x, y: y + h / 2, width: w, height: h / 2)
        case .centerHalf:
            return CGRect(x: x + w / 4, y: y, width: w / 2, height: h)

        // Jedna trzecia (Thirds - 1/3)
        case .firstThird:
            return CGRect(x: x, y: y, width: w / 3, height: h)
        case .centerThird:
            return CGRect(x: x + w / 3, y: y, width: w / 3, height: h)
        case .lastThird:
            return CGRect(x: x + 2 * w / 3, y: y, width: w / 3, height: h)
        case .topThird:
            return CGRect(x: x, y: y, width: w, height: h / 3)
        case .middleThird:
            return CGRect(x: x, y: y + h / 3, width: w, height: h / 3)
        case .bottomThird:
            return CGRect(x: x, y: y + 2 * h / 3, width: w, height: h / 3)

        // Dwie trzecie (Two Thirds - 2/3)
        case .firstTwoThirds:
            return CGRect(x: x, y: y, width: 2 * w / 3, height: h)
        case .centerTwoThirds:
            return CGRect(x: x + w / 6, y: y, width: 2 * w / 3, height: h)
        case .lastTwoThirds:
            return CGRect(x: x + w / 3, y: y, width: 2 * w / 3, height: h)
        case .topTwoThirds:
            return CGRect(x: x, y: y, width: w, height: 2 * h / 3)
        case .bottomTwoThirds:
            return CGRect(x: x, y: y + h / 3, width: w, height: 2 * h / 3)
        case .topCenterTwoThirds:
            return CGRect(x: x + w / 6, y: y, width: 2 * w / 3, height: 2 * h / 3)
        case .bottomCenterTwoThirds:
            return CGRect(x: x + w / 6, y: y + h / 3, width: 2 * w / 3, height: 2 * h / 3)

        // Ćwiartki (Quarters)
        case .topLeftQuarter:
            return CGRect(x: x, y: y, width: w / 2, height: h / 2)
        case .topRightQuarter:
            return CGRect(x: x + w / 2, y: y, width: w / 2, height: h / 2)
        case .bottomLeftQuarter:
            return CGRect(x: x, y: y + h / 2, width: w / 2, height: h / 2)
        case .bottomRightQuarter:
            return CGRect(x: x + w / 2, y: y + h / 2, width: w / 2, height: h / 2)

        // Jedna czwarta (Fourths - 1/4)
        case .firstFourth:
            return CGRect(x: x, y: y, width: w / 4, height: h)
        case .secondFourth:
            return CGRect(x: x + w / 4, y: y, width: w / 4, height: h)
        case .thirdFourth:
            return CGRect(x: x + w / 2, y: y, width: w / 4, height: h)
        case .lastFourth:
            return CGRect(x: x + 3 * w / 4, y: y, width: w / 4, height: h)
        case .topFirstFourth:
            return CGRect(x: x, y: y, width: w, height: h / 4)
        case .topSecondFourth:
            return CGRect(x: x, y: y + h / 4, width: w, height: h / 4)
        case .topThirdFourth:
            return CGRect(x: x, y: y + h / 2, width: w, height: h / 4)
        case .topLastFourth:
            return CGRect(x: x, y: y + 3 * h / 4, width: w, height: h / 4)

        // Trzy czwarte (Three Fourths - 3/4)
        case .firstThreeFourths:
            return CGRect(x: x, y: y, width: 3 * w / 4, height: h)
        case .centerThreeFourths:
            return CGRect(x: x + w / 8, y: y, width: 3 * w / 4, height: h)
        case .lastThreeFourths:
            return CGRect(x: x + w / 4, y: y, width: 3 * w / 4, height: h)
        case .topThreeFourths:
            return CGRect(x: x, y: y, width: w, height: 3 * h / 4)
        case .bottomThreeFourths:
            return CGRect(x: x, y: y + h / 4, width: w, height: 3 * h / 4)

        // Szóstki (Sixths - 1/6)
        case .topLeftSixth:
            return CGRect(x: x, y: y, width: w / 3, height: h / 2)
        case .topCenterSixth:
            return CGRect(x: x + w / 3, y: y, width: w / 3, height: h / 2)
        case .topRightSixth:
            return CGRect(x: x + 2 * w / 3, y: y, width: w / 3, height: h / 2)
        case .bottomLeftSixth:
            return CGRect(x: x, y: y + h / 2, width: w / 3, height: h / 2)
        case .bottomCenterSixth:
            return CGRect(x: x + w / 3, y: y + h / 2, width: w / 3, height: h / 2)
        case .bottomRightSixth:
            return CGRect(x: x + 2 * w / 3, y: y + h / 2, width: w / 3, height: h / 2)

        // Maksymalizacja i skalowanie
        case .maximize:
            return CGRect(x: x, y: y, width: w, height: h)
        case .almostMaximize:
            let targetW = w * 0.9
            let targetH = h * 0.9
            return CGRect(x: x + (w - targetW) / 2, y: y + (h - targetH) / 2, width: targetW, height: targetH)
        case .maximizeHeight:
            return CGRect(x: currentWindowRect.origin.x, y: y, width: currentWindowRect.width, height: h)
        case .maximizeWidth:
            return CGRect(x: x, y: currentWindowRect.origin.y, width: w, height: currentWindowRect.height)
        case .reasonableSize:
            let targetW = min(w * 0.6, 1024)
            let targetH = min(h * 0.6, 900)
            return CGRect(x: x + (w - targetW) / 2, y: y + (h - targetH) / 2, width: targetW, height: targetH)
        case .center:
            let targetW = min(currentWindowRect.width, w)
            let targetH = min(currentWindowRect.height, h)
            return CGRect(x: x + (w - targetW) / 2, y: y + (h - targetH) / 2, width: targetW, height: targetH)
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
