import Cocoa
import SwiftUI
import Carbon

@main
final class AppMain: NSObject, NSApplicationDelegate {
    static var shared: AppMain!
    var hudPanel: FloatingHUDPanel?
    var hotKeyRef: EventHotKeyRef?

    static func main() {
        let app = NSApplication.shared
        let delegate = AppMain()
        AppMain.shared = delegate
        app.delegate = delegate
        // Uruchomienie jako proces Accessory/Agent (brak ikony w Docku i w przełączniku Cmd+Tab)
        app.setActivationPolicy(.accessory)
        app.run()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("=== CherryPicker Uruchomiony ===")
        // Start śledzenia aktywnej aplikacji
        _ = FrontmostAppTracker.shared

        print("1. Sprawdzanie uprawnień Dostępności (Accessibility)...")
        let trusted = WindowManager.shared.isAccessibilityGranted(prompt: true)
        if !trusted {
            print("Wymagane uprawnienia Dostępności: Ustawienia systemowe -> Prywatność i bezpieczeństwo -> Dostępność")
        } else {
            print("Uprawnienia Dostępności są aktywne.")
        }

        print("2. Inicjalizacja okna HUD...")
        let panel = FloatingHUDPanel(contentRect: NSRect(x: 0, y: 0, width: 720, height: 460))
        let contentView = MainHUDView { [weak panel] in
            panel?.hideHUD(restoreFocus: true)
        }
        panel.contentView = NSHostingView(rootView: contentView)
        panel.center()
        self.hudPanel = panel

        print("3. Rejestracja globalnego skrótu (Option + Space)...")
        registerGlobalHotKey()

        // Pokazanie panelu po starcie aplikacji
        panel.toggleVisibility()
    }

    private func registerGlobalHotKey() {
        let hotKeyID = EventHotKeyID(signature: OSType(0x43485259), id: 1) // 'CHRY'
        var gMyHotKeyRef: EventHotKeyRef?

        // Klawisz Spacja (kVK_Space = 49), modyfikator Option (optionKey = 0x0800)
        let status = RegisterEventHotKey(
            UInt32(kVK_Space),
            UInt32(optionKey),
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &gMyHotKeyRef
        )

        if status == noErr {
            self.hotKeyRef = gMyHotKeyRef
            var eventType = EventTypeSpec(
                eventClass: OSType(kEventClassKeyboard),
                eventKind: UInt32(kEventHotKeyPressed)
            )

            InstallEventHandler(
                GetApplicationEventTarget(),
                { (_, _, userData) -> OSStatus in
                    DispatchQueue.main.async {
                        AppMain.shared.hudPanel?.toggleVisibility()
                    }
                    return noErr
                },
                1,
                &eventType,
                nil,
                nil
            )
            print("Zarejestrowano skrót globalny: Option + Spacja (⌥ + Space)")
        } else {
            print("Błąd rejestracji skrótu: \(status)")
        }
    }
}
