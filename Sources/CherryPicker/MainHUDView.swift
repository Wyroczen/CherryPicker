import SwiftUI
import AppKit

public struct MainHUDView: View {
    public var onClose: () -> Void

    @State private var searchText = ""
    @State private var allApps: [SearchResultItem] = []
    @State private var filteredResults: [SearchResultItem] = []
    @State private var selectedIndex = 0

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
                TextField("Szukaj aplikacji, plików lub akcji okna...", text: $searchText)
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

            // Lista wyników
            ScrollViewReader { proxy in
                List(Array(filteredResults.enumerated()), id: \.element.id) { index, item in
                    HStack(spacing: 12) {
                        Image(nsImage: NSWorkspace.shared.icon(forFile: item.path))
                            .resizable()
                            .frame(width: 26, height: 26)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.system(size: 14, weight: .medium))
                            Text(item.path)
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(item.isApp ? "Aplikacja" : "Plik")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.2))
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
            }

            Divider()

            // Pasek szybkiego zarządzania oknami (Window Management)
            HStack(spacing: 8) {
                Text("Okna:")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)

                windowButton("Lewo", icon: "arrow.left.to.line") {
                    WindowManager.shared.applyAction(.leftHalf)
                }
                windowButton("Prawo", icon: "arrow.right.to.line") {
                    WindowManager.shared.applyAction(.rightHalf)
                }
                windowButton("Góra", icon: "arrow.up.to.line") {
                    WindowManager.shared.applyAction(.topHalf)
                }
                windowButton("Dół", icon: "arrow.down.to.line") {
                    WindowManager.shared.applyAction(.bottomHalf)
                }
                windowButton("Maksymalizuj", icon: "arrow.up.left.and.arrow.down.right") {
                    WindowManager.shared.applyAction(.maximize)
                }
                windowButton("Środek", icon: "dot.viewfinder") {
                    WindowManager.shared.applyAction(.center)
                }

                Spacer()
                Text("ESC, aby zamknąć")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(Color(NSColor.windowBackgroundColor).opacity(0.95))
        }
        .frame(width: 680, height: 420)
        .background(VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .onAppear {
            DispatchQueue.global(qos: .userInitiated).async {
                let apps = SpotlightSearcher.shared.getInstalledApplications()
                DispatchQueue.main.async {
                    self.allApps = apps
                    self.filteredResults = apps
                }
            }
        }
    }

    private var selectedItem: SearchResultItem? {
        if filteredResults.indices.contains(selectedIndex) {
            return filteredResults[selectedIndex]
        }
        return filteredResults.first
    }

    private func windowButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            onClose()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
            }
        }) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 11, weight: .medium))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.secondary.opacity(0.15))
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
    }

    private func updateSearch(query: String) {
        if query.trimmingCharacters(in: .whitespaces).isEmpty {
            filteredResults = allApps
        } else {
            let matchedApps = allApps.filter { $0.name.localizedCaseInsensitiveContains(query) }
            let fileResults = SpotlightSearcher.shared.searchFiles(queryText: query, limit: 15)
            filteredResults = matchedApps + fileResults
        }
        selectedIndex = 0
    }

    private func executeSelection(item: SearchResultItem) {
        onClose()
        NSWorkspace.shared.open(URL(fileURLWithPath: item.path))
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
