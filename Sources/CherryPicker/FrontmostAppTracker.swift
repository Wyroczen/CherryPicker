import Cocoa

/// Obserwuje zmiany aktywnej aplikacji w systemie macOS i zapamiętuje poprzednio aktywną aplikację.
/// Pozwala na przywrócenie fokusu i manipulację oknami właściwej aplikacji po otwarciu i zamknięciu HUD-a.
public final class FrontmostAppTracker {
    public static let shared = FrontmostAppTracker()

    /// Ostatnio uaktywniona aplikacja zewnętrzna (inna niż CherryPicker)
    private(set) public var currentTargetApp: NSRunningApplication?

    /// Poprzednia aplikacja zewnętrzna w historii
    private(set) public var previousTargetApp: NSRunningApplication?

    private var observer: NSObjectProtocol?

    private init() {
        // Inicjalnie pobierz aktualnie aktywną aplikację, jeśli nie jest to nasz proces
        if let frontApp = NSWorkspace.shared.frontmostApplication,
           frontApp.processIdentifier != NSRunningApplication.current.processIdentifier {
            currentTargetApp = frontApp
        }
        startObserving()
    }

    deinit {
        stopObserving()
    }

    /// Rozpoczyna nasłuchiwanie powiadomień NSWorkspace o aktywacji aplikacji
    public func startObserving() {
        guard observer == nil else { return }

        observer = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleApplicationActivated(notification)
        }
    }

    /// Zatrzymuje nasłuchiwanie powiadomień
    public func stopObserving() {
        if let obs = observer {
            NSWorkspace.shared.notificationCenter.removeObserver(obs)
            observer = nil
        }
    }

    private func handleApplicationActivated(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }

        // Ignorujemy własny proces CherryPicker – nie powinien nadpisywać docelowej aplikacji
        if app.processIdentifier == NSRunningApplication.current.processIdentifier {
            return
        }

        // Jeśli uaktywniła się inna aplikacja niż dotychczasowa, przesuwamy historię
        if app.processIdentifier != currentTargetApp?.processIdentifier {
            previousTargetApp = currentTargetApp
            currentTargetApp = app
        }
    }

    /// Zwraca najlepszą aplikację docelową do manipulacji oknem
    public var targetApplication: NSRunningApplication? {
        if let current = currentTargetApp, !current.isTerminated {
            return current
        }
        if let prev = previousTargetApp, !prev.isTerminated {
            return prev
        }
        // Fallback: pierwsza aktywna aplikacja w systemie inna niż nasz proces
        return NSWorkspace.shared.runningApplications.first {
            $0.isActive && $0.processIdentifier != NSRunningApplication.current.processIdentifier
        }
    }

    /// Przywraca fokus docelowej aplikacji na pierwszym planie
    @discardableResult
    public func bringTargetAppToFront() -> Bool {
        guard let app = targetApplication, !app.isTerminated else {
            return false
        }
        return app.activate(options: .activateIgnoringOtherApps)
    }
}
