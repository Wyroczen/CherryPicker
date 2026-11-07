import SwiftUI
import AppKit

public struct MainHUDView: View {
    public var onClose: () -> Void

    @State private var searchText = ""
    @State private var allApps: [SearchItem] = []
    @State private var allWindowCommands: [SearchItem] = SearchItem.allWindowCommands
    @State private var filteredResults: [SearchItem] = []
    @State private var selectedIndex = 0
    @State private var keyMonitor: Any?

    public init(onClose: @escaping () -> Void) {
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Pasek wyszukiwania
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)

                TextField("Szukaj aplikacji, plików lub poleceń okien...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16, weight: .medium))
                    .onSubmit {
                        if let item = selectedItem {
                            executeSelection(item: item)
                        }
                    }
                    .onChange(of: searchText) { newValue in
                        updateSearch(query: newValue)
                    }

                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(NSColor.controlBackgroundColor).opacity(0.8))

            Divider()

            // Zunifikowana lista wyników (Aplikacje, Polecenia okien, Pliki)
            ScrollViewReader { proxy in
                List(Array(filteredResults.enumerated()), id: \.element.id) { index, item in
                    HStack(spacing: 12) {
                        // Ikona elementu
                        leadingIcon(for: item)

                        // Tytuł i ścieżka / opis
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedIndex == index ? .primary : .primary.opacity(0.9))

                            Text(item.subtitle)
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()

                        // Etykieta rodzaju (Aplikacja / Polecenie / Plik)
                        Text(item.kind.badgeText)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(badgeBackground(for: item.kind, isSelected: selectedIndex == index))
                            .cornerRadius(4)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(selectedIndex == index ? Color.accentColor.opacity(0.25) : Color.clear)
                    .cornerRadius(6)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        executeSelection(item: item)
                    }
                }
                .listStyle(.plain)
                .onChange(of: selectedIndex) { newIndex in
                    if filteredResults.indices.contains(newIndex) {
                        proxy.scrollTo(filteredResults[newIndex].id, anchor: .center)
                    }
                }
            }

            Divider()

            // Dolny pasek akcji (Action Bar ze statusem i skrótami)
            HStack(spacing: 12) {
                if let selected = selectedItem {
                    HStack(spacing: 6) {
                        Text(actionDescription(for: selected.kind))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(selected.title)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                    }
                } else {
                    Text("Brak wyników")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack(spacing: 8) {
                    keyBadge("↵", label: "Wykonaj")
                    keyBadge("ESC", label: "Zamknij")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(NSColor.windowBackgroundColor).opacity(0.95))
        }
        .frame(width: 720, height: 460)
        .background(VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .onAppear {
            loadInitialData()
            setupKeyboardMonitor()
        }
        .onDisappear {
            removeKeyboardMonitor()
        }
    }

    private var selectedItem: SearchItem? {
        if filteredResults.indices.contains(selectedIndex) {
            return filteredResults[selectedIndex]
        }
        return filteredResults.first
    }

    @ViewBuilder
    private func leadingIcon(for item: SearchItem) -> some View {
        switch item.kind {
        case .application(let path), .file(let path):
            Image(nsImage: NSWorkspace.shared.icon(forFile: path))
                .resizable()
                .frame(width: 26, height: 26)

        case .windowCommand(let action):
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.accentColor.opacity(0.18))
                Image(systemName: action.iconName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.accentColor)
            }
            .frame(width: 26, height: 26)
        }
    }

    private func badgeBackground(for kind: SearchItemKind, isSelected: Bool) -> Color {
        switch kind {
        case .windowCommand:
            return Color.accentColor.opacity(isSelected ? 0.35 : 0.2)
        case .application:
            return Color.secondary.opacity(isSelected ? 0.35 : 0.2)
        case .file:
            return Color.secondary.opacity(isSelected ? 0.3 : 0.15)
        }
    }

    private func actionDescription(for kind: SearchItemKind) -> String {
        switch kind {
        case .windowCommand: return "Zastosuj układ:"
        case .application: return "Uruchom aplikację:"
        case .file: return "Otwórz plik:"
        }
    }

    private func keyBadge(_ key: String, label: String) -> some View {
        HStack(spacing: 4) {
            Text(key)
                .font(.system(size: 10, weight: .bold))
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(4)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
    }

    private func loadInitialData() {
        DispatchQueue.global(qos: .userInitiated).async {
            let apps = SpotlightSearcher.shared.getInstalledAppItems()
            let commands = self.allWindowCommands

            DispatchQueue.main.async {
                self.allApps = apps
                // Domyślnie prezentujemy najpopularniejsze aplikacje oraz pełny katalog poleceń okien
                self.filteredResults = apps + commands
                self.selectedIndex = 0
            }
        }
    }

    private func updateSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            DispatchQueue.main.async {
                self.filteredResults = self.allApps + self.allWindowCommands
                self.selectedIndex = 0
            }
            return
        }

        // Asynchroniczne wyszukiwanie w tle, aby zapobiec blokowaniu NSTableView i zachować płynność
        DispatchQueue.global(qos: .userInteractive).async {
            let matchedCommands = self.allWindowCommands.filter { $0.matches(query: trimmed) }
            let matchedApps = self.allApps.filter { $0.matches(query: trimmed) }
            let fileResults = SpotlightSearcher.shared.searchFileItems(queryText: trimmed, limit: 15)

            // Łączymy: najpierw dopasowane komendy i aplikacje, następnie pliki
            let combined = matchedCommands + matchedApps + fileResults

            DispatchQueue.main.async {
                guard self.searchText.trimmingCharacters(in: .whitespaces) == trimmed else { return }
                self.filteredResults = combined
                self.selectedIndex = 0
            }
        }
    }

    private func executeSelection(item: SearchItem) {
        onClose()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            switch item.kind {
            case .application(let path), .file(let path):
                NSWorkspace.shared.open(URL(fileURLWithPath: path))
            case .windowCommand(let action):
                WindowManager.shared.applyAction(action)
            }
        }
    }

    private func setupKeyboardMonitor() {
        guard keyMonitor == nil else { return }
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 126 { // Strzałka w górę (Up Arrow)
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
                return nil
            } else if event.keyCode == 125 { // Strzałka w dół (Down Arrow)
                if selectedIndex < filteredResults.count - 1 {
                    selectedIndex += 1
                }
                return nil
            }
            return event
        }
    }

    private func removeKeyboardMonitor() {
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
            keyMonitor = nil
        }
    }
}

public struct VisualEffectBlur: NSViewRepresentable {
    public var material: NSVisualEffectView.Material
    public var blendingMode: NSVisualEffectView.BlendingMode

    public init(material: NSVisualEffectView.Material, blendingMode: NSVisualEffectView.BlendingMode) {
        self.material = material
        self.blendingMode = blendingMode
    }

    public func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
