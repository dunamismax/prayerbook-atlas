import Foundation

/// The app's tabs (docs/product.md §1). The raw values are saved for state restoration and
/// used in deep links; never change them (`NavigationTests` pins them).
enum AppTab: String, CaseIterable, Codable, Hashable, Sendable {
    case today
    case pray
    case bible
    case kalendar
    case atlas
    case search

    var title: LocalizedStringResource {
        switch self {
        case .today: "Today"
        case .pray: "Pray"
        case .bible: "Bible"
        case .kalendar: "Kalendar"
        case .atlas: "Atlas"
        case .search: "Search"
        }
    }

    /// Placeholder SF Symbols until P2.5 traces the app's own (docs/product.md §1). No
    /// compass rose and no church emblem.
    var systemImage: String {
        switch self {
        case .today: "sun.horizon"
        case .pray: "book.closed"
        case .bible: "text.book.closed"
        case .kalendar: "calendar"
        case .atlas: "map"
        case .search: "magnifyingglass"
        }
    }
}
