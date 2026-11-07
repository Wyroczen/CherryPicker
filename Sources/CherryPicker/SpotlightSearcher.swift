import Foundation
import CoreServices

public struct SearchResultItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let path: String
    public let isApp: Bool
    public let lastUsedDate: Date?

    public init(id: String, name: String, path: String, isApp: Bool, lastUsedDate: Date?) {
        self.id = id
        self.name = name
        self.path = path
        self.isApp = isApp
        self.lastUsedDate = lastUsedDate
    }
}

public final class SpotlightSearcher: @unchecked Sendable {
    public static let shared = SpotlightSearcher()
    private init() {}

    /// Błyskawiczne pobieranie wszystkich zainstalowanych aplikacji przez Spotlight MDQuery
    public func getInstalledApplications() -> [SearchResultItem] {
        let queryStr = "kMDItemContentTypeTree == 'com.apple.application-bundle'" as CFString
        guard let query = MDQueryCreate(kCFAllocatorDefault, queryStr, nil, nil) else {
            return []
        }

        // Synchroniczne wykonanie zapytania Spotlight (kMDQuerySynchronous = 1)
        MDQueryExecute(query, 1)

        let count = MDQueryGetResultCount(query)
        var items: [SearchResultItem] = []
        items.reserveCapacity(count)

        for i in 0..<count {
            guard let rawItem = MDQueryGetResultAtIndex(query, i) else { continue }
            let item = Unmanaged<MDItem>.fromOpaque(rawItem).takeUnretainedValue()

            guard let rawPath = MDItemCopyAttribute(item, kMDItemPath),
                  let path = rawPath as? String else { continue }

            // Pomiń wewnętrzne binarki i usługi systemowe z /System/Library/
            if path.hasPrefix("/System/Library/") { continue }

            let rawName = MDItemCopyAttribute(item, kMDItemDisplayName) as? String
            let name = rawName ?? (path as NSString).lastPathComponent.replacingOccurrences(of: ".app", with: "")
            let lastUsed = MDItemCopyAttribute(item, kMDItemLastUsedDate) as? Date

            items.append(SearchResultItem(
                id: path,
                name: name,
                path: path,
                isApp: true,
                lastUsedDate: lastUsed
            ))
        }

        // Sortowanie wg Most Recently Used (MRU)
        return items.sorted { ($0.lastUsedDate ?? .distantPast) > ($1.lastUsedDate ?? .distantPast) }
    }

    /// Wyszukiwanie plików po wpisanej frazie
    public func searchFiles(queryText: String, limit: Int = 30) -> [SearchResultItem] {
        guard !queryText.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }

        let escaped = queryText.replacingOccurrences(of: "'", with: "\\'")
        let queryStr = "(kMDItemFSName == '*\(escaped)*'c || kMDItemDisplayName == '*\(escaped)*'c)" as CFString
        guard let query = MDQueryCreate(kCFAllocatorDefault, queryStr, nil, nil) else { return [] }

        MDQueryExecute(query, 1)
        let count = min(MDQueryGetResultCount(query), limit)
        var items: [SearchResultItem] = []

        for i in 0..<count {
            guard let rawItem = MDQueryGetResultAtIndex(query, i) else { continue }
            let item = Unmanaged<MDItem>.fromOpaque(rawItem).takeUnretainedValue()

            guard let rawPath = MDItemCopyAttribute(item, kMDItemPath),
                  let path = rawPath as? String else { continue }

            let name = (MDItemCopyAttribute(item, kMDItemDisplayName) as? String) ?? (path as NSString).lastPathComponent
            let isApp = path.hasSuffix(".app")
            let lastUsed = MDItemCopyAttribute(item, kMDItemLastUsedDate) as? Date

            items.append(SearchResultItem(
                id: path,
                name: name,
                path: path,
                isApp: isApp,
                lastUsedDate: lastUsed
            ))
        }

        return items
    }
}
