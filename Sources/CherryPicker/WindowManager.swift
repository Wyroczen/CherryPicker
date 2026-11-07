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
        case .leftHalf: return "Lewa połowa ekranu (50% szerokości)"
        case .rightHalf: return "Prawa połowa ekranu (50% szerokości)"
        case .topHalf: return "Górna połowa ekranu (50% wysokości)"
        case .bottomHalf: return "Dolna połowa ekranu (50% wysokości)"
        case .centerHalf: return "Wyśrodkowane 50% szerokości ekranu"

        case .firstThird: return "Lewa jedna trzecia ekranu (33% szerokości)"
        case .centerThird: return "Środkowa jedna trzecia ekranu (33% szerokości)"
        case .lastThird: return "Prawa jedna trzecia ekranu (33% szerokości)"
        case .topThird: return "Górna jedna trzecia ekranu (33% wysokości)"
        case .middleThird: return "Środkowa pozioma jedna trzecia (33% wysokości)"
        case .bottomThird: return "Dolna jedna trzecia ekranu (33% wysokości)"

        case .firstTwoThirds: return "Lewe dwie trzecie ekranu (67% szerokości)"
        case .centerTwoThirds: return "Środkowe dwie trzecie ekranu (67% szerokości)"
        case .lastTwoThirds: return "Prawe dwie trzecie ekranu (67% szerokości)"
        case .topTwoThirds: return "Górne dwie trzecie ekranu (67% wysokości)"
        case .bottomTwoThirds: return "Dolne dwie trzecie ekranu (67% wysokości)"
        case .topCenterTwoThirds: return "Górne wyśrodkowane 2/3 szerokości i wysokości"
        case .bottomCenterTwoThirds: return "Dolne wyśrodkowane 2/3 szerokości i wysokości"

        case .topLeftQuarter: return "Lewa górna ćwiartka ekranu"
        case .topRightQuarter: return "Prawa górna ćwiartka ekranu"
        case .bottomLeftQuarter: return "Lewa dolna ćwiartka ekranu"
        case .bottomRightQuarter: return "Prawa dolna ćwiartka ekranu"

        case .firstFourth: return "Pierwsza pionowa ćwiartka (25% szerokości)"
        case .secondFourth: return "Druga pionowa ćwiartka (25% szerokości)"
        case .thirdFourth: return "Trzecia pionowa ćwiartka (25% szerokości)"
        case .lastFourth: return "Czwarta pionowa ćwiartka (25% szerokości)"
        case .topFirstFourth: return "Pierwszy poziomy pas (25% wysokości)"
        case .topSecondFourth: return "Drugi poziomy pas (25% wysokości)"
        case .topThirdFourth: return "Trzeci poziomy pas (25% wysokości)"
        case .topLastFourth: return "Czwarty poziomy pas (25% wysokości)"

        case .firstThreeFourths: return "Lewe trzy czwarte ekranu (75% szerokości)"
        case .centerThreeFourths: return "Środkowe trzy czwarte ekranu (75% szerokości)"
        case .lastThreeFourths: return "Prawe trzy czwarte ekranu (75% szerokości)"
        case .topThreeFourths: return "Górne trzy czwarte ekranu (75% wysokości)"
        case .bottomThreeFourths: return "Dolne trzy czwarte ekranu (75% wysokości)"

        case .topLeftSixth: return "Górna lewa jedna szósta (33% x 50%)"
        case .topCenterSixth: return "Górna środkowa jedna szósta (33% x 50%)"
        case .topRightSixth: return "Górna prawa jedna szósta (33% x 50%)"
        case .bottomLeftSixth: return "Dolna lewa jedna szósta (33% x 50%)"
        case .bottomCenterSixth: return "Dolna środkowa jedna szósta (33% x 50%)"
        case .bottomRightSixth: return "Dolna prawa jedna szósta (33% x 50%)"

        case .maximize: return "Maksymalizacja okna na cały ekran (100%)"
        case .almostMaximize: return "Prawie maksymalizuj (90% ekranu)"
        case .maximizeHeight: return "Maksymalizuj wysokość (100% wysokości)"
        case .maximizeWidth: return "Maksymalizuj szerokość (100% szerokości)"
        case .reasonableSize: return "Optymalny rozmiar (60% ekranu, max 1024x900)"
        case .center: return "Wyśrodkowanie okna na ekranie"
        }
    }

    public var searchKeywords: [String] {
        var keys = [rawValue.lowercased()]
        switch self {
        case .leftHalf: keys += ["lewo", "lewa", "polowa", "połowa", "half", "left"]
        case .rightHalf: keys += ["prawo", "prawa", "polowa", "połowa", "half", "right"]
        case .topHalf: keys += ["gora", "góra", "top", "half", "polowa", "połowa"]
        case .bottomHalf: keys += ["dol", "dół", "bottom", "half", "polowa", "połowa"]
        case .centerHalf: keys += ["srodek", "środek", "center", "half", "polowa", "połowa"]

        case .firstThird: keys += ["trzecia", "third", "1/3", "lewa", "first"]
        case .centerThird: keys += ["trzecia", "third", "1/3", "srodek", "center"]
        case .lastThird: keys += ["trzecia", "third", "1/3", "prawa", "last"]
        case .topThird: keys += ["trzecia", "third", "1/3", "gora", "top"]
        case .middleThird: keys += ["trzecia", "third", "1/3", "srodek", "middle"]
        case .bottomThird: keys += ["trzecia", "third", "1/3", "dol", "bottom"]

        case .firstTwoThirds: keys += ["dwie trzecie", "two thirds", "2/3", "lewa"]
        case .centerTwoThirds: keys += ["dwie trzecie", "two thirds", "2/3", "srodek"]
        case .lastTwoThirds: keys += ["dwie trzecie", "two thirds", "2/3", "prawa"]
        case .topTwoThirds: keys += ["dwie trzecie", "two thirds", "2/3", "gora"]
        case .bottomTwoThirds: keys += ["dwie trzecie", "two thirds", "2/3", "dol"]
        case .topCenterTwoThirds, .bottomCenterTwoThirds: keys += ["dwie trzecie", "two thirds", "2/3", "kwadrat"]

        case .topLeftQuarter: keys += ["cwiartka", "ćwiartka", "quarter", "1/4", "gora lewo"]
        case .topRightQuarter: keys += ["cwiartka", "ćwiartka", "quarter", "1/4", "gora prawo"]
        case .bottomLeftQuarter: keys += ["cwiartka", "ćwiartka", "quarter", "1/4", "dol lewo"]
        case .bottomRightQuarter: keys += ["cwiartka", "ćwiartka", "quarter", "1/4", "dol prawo"]

        case .firstFourth, .secondFourth, .thirdFourth, .lastFourth:
            keys += ["cwiartka", "ćwiartka", "fourth", "1/4", "kolumna"]
        case .topFirstFourth, .topSecondFourth, .topThirdFourth, .topLastFourth:
            keys += ["cwiartka", "ćwiartka", "fourth", "1/4", "pas"]

        case .firstThreeFourths, .centerThreeFourths, .lastThreeFourths,
             .topThreeFourths, .bottomThreeFourths:
            keys += ["trzy czwarte", "three fourths", "3/4"]

        case .topLeftSixth, .topCenterSixth, .topRightSixth,
             .bottomLeftSixth, .bottomCenterSixth, .bottomRightSixth:
            keys += ["szosta", "szósta", "sixth", "1/6", "siatka"]

        case .maximize: keys += ["max", "maksymalizuj", "pelny ekran", "pełny ekran", "full"]
        case .almostMaximize: keys += ["prawie", "almost", "90%"]
        case .maximizeHeight: keys += ["wysokosc", "wysokość", "height"]
        case .maximizeWidth: keys += ["szerokosc", "szerokość", "width"]
        case .reasonableSize: keys += ["rozmiar", "optymalny", "reasonable", "size", "60%"]
        case .center: keys += ["srodek", "środek", "centruj", "center"]
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
