import Foundation
import Observation

/// The selected tab and each tab's navigation path, restored on relaunch (docs/product.md §2).
@MainActor
@Observable
final class NavigationModel {
    var selectedTab: AppTab = .today
    var paths: [AppTab: [AppRoute]] = [:]

    /// The path for one tab, for binding to its `NavigationStack`.
    func path(for tab: AppTab) -> [AppRoute] {
        paths[tab] ?? []
    }

    func setPath(_ path: [AppRoute], for tab: AppTab) {
        paths[tab] = path.isEmpty ? nil : path
    }

    /// Opens a deep link: a tab is selected as it was left; a route is pushed onto its home
    /// tab's root, replacing that tab's path. `compact` is true on iPhone, where Search is
    /// pushed onto the current tab instead of being a tab (decision 17).
    func open(_ link: DeepLink, compact: Bool) {
        switch link {
        case .tab(.search), .route(.search):
            if compact {
                if selectedTab == .search { selectedTab = .today }
                paths[selectedTab] = [.search]
            } else {
                selectedTab = .search
                setPath([], for: .search)
            }
        case .tab(let tab):
            selectedTab = tab
        case .route(let route):
            selectedTab = route.homeTab
            paths[route.homeTab] = [route]
        }
    }

    // MARK: Restoration

    private struct Snapshot: Codable {
        var selectedTab: AppTab
        var paths: [AppTab: [AppRoute]]
    }

    /// The state to save, as JSON.
    var snapshot: Data {
        (try? JSONEncoder().encode(Snapshot(selectedTab: selectedTab, paths: paths))) ?? Data()
    }

    /// Restores saved state. Anything that no longer decodes (after an update removed a route,
    /// say) is dropped, and the app starts on Today.
    func restore(from data: Data) {
        guard let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) else { return }
        selectedTab = snapshot.selectedTab
        paths = snapshot.paths
    }
}
