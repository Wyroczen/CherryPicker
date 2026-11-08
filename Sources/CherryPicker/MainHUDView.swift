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
    @FocusState private var isSearchFocused: Bool

    // Geometria nagłówka i stopki pływającego szkła
    private let headerHeight: CGFloat = 52
    private let footerHeight: CGFloat = 38

    public init(onClose: @escaping () -> Void) {
        self.onClose = onClose
    }

    public var body: some View {
        ZStack(alignment: .top) {
            // 1. Pełnowymiarowa lista (Full-Bleed) rozciągająca się na całą wysokość okna pod nagłówkiem i stopką
            resultsList

            // 2. Pływający nagłówek wyszukiwarki (Floating Glass Header) z subtelnym gradientem
            searchBarHeader

            // 3. Pływająca stopka akcji (Floating Glass Footer) z subtelnym gradientem
            actionBarFooter
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(width: 700, height: 460)
        .background(
            ZStack {
                VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow, cornerRadius: 26)
                Color(red: 18/255, green: 20/255, blue: 26/255).opacity(0.48)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.18),
                            Color.white.opacity(0.06),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .onAppear {
            loadInitialData()
            setupKeyboardMonitor()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                isSearchFocused = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isSearchFocused = true
            }
        }
        .onDisappear {
            removeKeyboardMonitor()
        }
    }

    // MARK: - Subviews

    private var searchBarHeader: some View {
        HStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 19, weight: .medium))
                .foregroundColor(.white.opacity(0.55))

            TextField("Szukaj aplikacji, plików lub poleceń okien...", text: $searchText)
                .focused($isSearchFocused)
                .textFieldStyle(.plain)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
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
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.5))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 22)
        .frame(height: headerHeight)
        .background(Color.clear)
    }

    private var resultsList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 3) {
                    ForEach(Array(filteredResults.enumerated()), id: \.element.id) { index, item in
                        resultRow(item: item, index: index)
                    }
                }
                .padding(.top, 54)
                .padding(.bottom, 40)
                .padding(.horizontal, 12)
            }
            .scrollIndicators(.hidden)
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .black.opacity(0.18), location: 0.05),
                        .init(color: .black.opacity(0.40), location: 0.09),
                        .init(color: .black, location: 0.12),
                        .init(color: .black, location: 0.88),
                        .init(color: .black.opacity(0.45), location: 0.94),
                        .init(color: .clear, location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .onChange(of: selectedIndex) { newIndex in
                if filteredResults.indices.contains(newIndex) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        proxy.scrollTo(filteredResults[newIndex].id, anchor: .center)
                    }
                }
            }
        }
    }

    private func resultRow(item: SearchItem, index: Int) -> some View {
        let isSelected = selectedIndex == index

        return HStack(spacing: 12) {
            // Ikona elementu
            leadingIcon(for: item)

            // Tytuł i ścieżka / opis
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 13.5, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.92))

                Text(item.subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .white.opacity(0.70) : .white.opacity(0.45))
                    .lineLimit(1)
            }

            Spacer()

            // Etykieta rodzaju (Aplikacja / Polecenie / Plik)
            Text(item.kind.badgeText)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(isSelected ? .white.opacity(0.90) : .white.opacity(0.65))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.white.opacity(isSelected ? 0.16 : 0.08))
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            Group {
                if isSelected {
                    Color.white.opacity(0.11)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                } else {
                    Color.clear
                }
            }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            executeSelection(item: item)
        }
    }

    private var actionBarFooter: some View {
        HStack(spacing: 12) {
            if let selected = selectedItem {
                HStack(spacing: 6) {
                    Text(actionDescription(for: selected.kind))
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.48))
                    Text(selected.title)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.88))
                        .lineLimit(1)
                }
            } else {
                Text("Brak wyników")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.45))
            }

            Spacer()

            // Dyskretny keycap akcji
            HStack(spacing: 6) {
                Text("↵")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2.5)
                    .background(Color.white.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(Color.white.opacity(0.14), lineWidth: 0.5)
                    )

                Text("Wykonaj")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.horizontal, 20)
        .frame(height: footerHeight)
        .background(Color.clear)
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
            WindowPreviewIcon(action: action, size: 28)
        }
    }

    private func actionDescription(for kind: SearchItemKind) -> String {
        switch kind {
        case .windowCommand: return "Zastosuj układ:"
        case .application: return "Uruchom aplikację:"
        case .file: return "Otwórz plik:"
        }
    }

    private func loadInitialData() {
        DispatchQueue.global(qos: .userInitiated).async {
            let apps = SpotlightSearcher.shared.getInstalledAppItems()
            let commands = self.allWindowCommands

            var seenIDs = Set<String>()
            let combined = (apps + commands).filter { seenIDs.insert($0.id).inserted }

            DispatchQueue.main.async {
                self.allApps = apps
                // Domyślnie prezentujemy najpopularniejsze aplikacje oraz pełny katalog poleceń okien
                self.filteredResults = combined
                self.selectedIndex = 0
            }
        }
    }

    private func updateSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            DispatchQueue.main.async {
                var seenIDs = Set<String>()
                self.filteredResults = (self.allApps + self.allWindowCommands).filter { seenIDs.insert($0.id).inserted }
                self.selectedIndex = 0
            }
            return
        }

        // Asynchroniczne wyszukiwanie w tle, aby zapobiec blokowaniu UI i zachować płynność
        DispatchQueue.global(qos: .userInteractive).async {
            let matchedCommands = self.allWindowCommands.filter { $0.matches(query: trimmed) }
            let matchedApps = self.allApps.filter { $0.matches(query: trimmed) }
            let fileResults = SpotlightSearcher.shared.searchFileItems(queryText: trimmed, limit: 15)

            // Łączymy i deduplikujemy elementy wg unikalnego id, eliminując kolizje tożsamości w SwiftUI ForEach
            var seenIDs = Set<String>()
            let combined = (matchedCommands + matchedApps + fileResults).filter { seenIDs.insert($0.id).inserted }

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
    public var cornerRadius: CGFloat

    public init(
        material: NSVisualEffectView.Material = .hudWindow,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        cornerRadius: CGFloat = 26
    ) {
        self.material = material
        self.blendingMode = blendingMode
        self.cornerRadius = cornerRadius
    }

    public func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.wantsLayer = true
        view.layer?.cornerRadius = cornerRadius
        view.layer?.cornerCurve = .continuous
        view.layer?.masksToBounds = true
        return view
    }

    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.layer?.cornerRadius = cornerRadius
        nsView.layer?.cornerCurve = .continuous
        nsView.layer?.masksToBounds = true
    }
}
