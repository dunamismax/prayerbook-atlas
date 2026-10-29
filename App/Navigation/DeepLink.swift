import Foundation

/// Deep links in the app's URL scheme (D1): `prayerbookatlas://pray` selects a tab, and
/// `prayerbookatlas://settings` opens a route in its home tab. Widgets, notifications,
/// Shortcuts, and links within the app use them (docs/product.md §2).
enum DeepLink: Equatable, Sendable {
    case tab(AppTab)
    case route(AppRoute)

    static let scheme = "prayerbookatlas"

    /// Parses a deep link, or returns nil for anything that is not one of ours.
    init?(url: URL) {
        guard url.scheme?.lowercased() == Self.scheme, let host = url.host()?.lowercased() else { return nil }
        let extra = url.pathComponents.filter { $0 != "/" }
        // Tab names come first: `search` is both a tab and a route, and both open Search.
        if extra.isEmpty, let tab = AppTab(rawValue: host) {
            self = .tab(tab)
        } else if let route = AppRoute(path: ([host] + extra).joined(separator: "/")) {
            self = .route(route)
        } else {
            return nil
        }
    }

    var url: URL {
        switch self {
        case .tab(let tab): URL(string: "\(Self.scheme)://\(tab.rawValue)")!
        case .route(let route): URL(string: "\(Self.scheme)://\(route.path)")!
        }
    }
}
