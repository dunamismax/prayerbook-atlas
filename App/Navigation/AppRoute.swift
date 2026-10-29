import Foundation

/// Every destination below a tab's root (docs/product.md §2). Each route has a stable path,
/// used in deep links (`prayerbookatlas://settings`) and in saved navigation state, so a
/// route's path never changes once released (`NavigationTests` pins them).
enum AppRoute: Hashable, Sendable {
    case settings
    case search

    /// The route's path in the URL scheme and in saved state.
    var path: String {
        switch self {
        case .settings: "settings"
        case .search: "search"
        }
    }

    /// Parses a path such as `settings`, or returns nil for one the app does not know.
    init?(path: String) {
        switch path.lowercased() {
        case "settings": self = .settings
        case "search": self = .search
        default: return nil
        }
    }

    /// The tab a deep link to this route opens in.
    var homeTab: AppTab {
        switch self {
        case .settings: .today
        case .search: .search
        }
    }
}

extension AppRoute: Codable {
    init(from decoder: any Decoder) throws {
        let path = try decoder.singleValueContainer().decode(String.self)
        guard let route = AppRoute(path: path) else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Unknown route \(path)"))
        }
        self = route
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(path)
    }
}
