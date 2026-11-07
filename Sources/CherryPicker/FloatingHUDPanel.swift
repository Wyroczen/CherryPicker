import Cocoa
import SwiftUI

public final class FloatingHUDPanel: NSPanel {
    public init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        self.level = .floating
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.isMovableByWindowBackground = true

        // Okno widoczne na wszystkich wirtualnych pulpitach (Spaces) i nad pełnym ekranem
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient]
    }

    public override var canBecomeKey: Bool { true }
    public override var canBecomeMain: Bool { true }

    public func toggleVisibility() {
        if isVisible {
            orderOut(nil)
        } else {
            center()
            makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    public override func cancelOperation(_ sender: Any?) {
        // Obsługa naciśnięcia klawisza ESC
        orderOut(nil)
    }
}
