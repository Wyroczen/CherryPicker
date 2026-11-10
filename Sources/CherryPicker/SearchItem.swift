import Foundation
import Cocoa

/// Typ elementu wynikowego w uniwersalnej wyszukiwarce
public enum SearchItemKind: Hashable, Sendable {
    case application(path: String)
    case file(path: String)
    case windowCommand(action: WindowAction)

    public var badgeText: String {
        switch self {
        case .application: return "Application"
        case .file: return "File"
        case .windowCommand: return "Command"
        }
    }
}

/// Zunifikowany model elementu wyszukiwania (aplikacja, plik lub polecenie manipulacji oknem)
public struct SearchItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let kind: SearchItemKind
    public let keywords: [String]
    public let lastUsedDate: Date?

    public init(
        id: String,
        title: String,
        subtitle: String,
        kind: SearchItemKind,
        keywords: [String] = [],
        lastUsedDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.kind = kind
        self.keywords = keywords
        self.lastUsedDate = lastUsedDate
    }

    /// Sprawdza czy element pasuje do wpisanej frazy
    public func matches(query: String) -> Bool {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return true }

        if title.localizedCaseInsensitiveContains(q) {
            return true
        }
        if subtitle.localizedCaseInsensitiveContains(q) {
            return true
        }
        return keywords.contains { $0.localizedCaseInsensitiveContains(q) }
    }

    /// Tworzy element na podstawie zainstalowanej aplikacji
    public static func fromApp(name: String, path: String, lastUsed: Date?) -> SearchItem {
        SearchItem(
            id: path,
            title: name,
            subtitle: path,
            kind: .application(path: path),
            keywords: [name.lowercased(), "app", "application"],
            lastUsedDate: lastUsed
        )
    }

    /// Tworzy element na podstawie pliku
    public static func fromFile(name: String, path: String, lastUsed: Date?) -> SearchItem {
        SearchItem(
            id: path,
            title: name,
            subtitle: path,
            kind: .file(path: path),
            keywords: [name.lowercased(), "file"],
            lastUsedDate: lastUsed
        )
    }

    /// Tworzy element na podstawie akcji zarządzania oknem
    public static func fromWindowAction(_ action: WindowAction) -> SearchItem {
        SearchItem(
            id: "windowAction_\(action.id)",
            title: action.rawValue,
            subtitle: action.descriptionText,
            kind: .windowCommand(action: action),
            keywords: action.searchKeywords,
            lastUsedDate: nil
        )
    }

    /// Zwraca listę wszystkich poleceń okien jako SearchItem
    public static var allWindowCommands: [SearchItem] {
        WindowAction.allCases.map { fromWindowAction($0) }
    }
}
