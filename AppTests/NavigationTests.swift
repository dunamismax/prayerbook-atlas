import Foundation
import Testing

@testable import PrayerbookAtlas

/// Tabs, routes, deep links, and restored navigation (docs/product.md §2, decision 17).
@MainActor
struct NavigationTests {
    @Test func tabRawValuesNeverChange() {
        #expect(AppTab.allCases.map(\.rawValue) == ["today", "pray", "bible", "kalendar", "atlas", "search"])
    }

    @Test func routePathsNeverChange() {
        #expect([AppRoute.settings, .search].map(\.path) == ["settings", "search"])
    }

    @Test(arguments: [AppRoute.settings, .search])
    func routesRoundTripThroughTheirPaths(route: AppRoute) throws {
        #expect(AppRoute(path: route.path) == route)
        let data = try JSONEncoder().encode(route)
        #expect(try JSONDecoder().decode(AppRoute.self, from: data) == route)
    }

    @Test func parsesDeepLinks() throws {
        func link(_ string: String) throws -> DeepLink? { DeepLink(url: try #require(URL(string: string))) }
        #expect(try link("prayerbookatlas://atlas") == .tab(.atlas))
        #expect(try link("PrayerbookAtlas://Kalendar") == .tab(.kalendar))
        #expect(try link("prayerbookatlas://settings") == .route(.settings))
        #expect(try link("prayerbookatlas://search") == .tab(.search))
        #expect(try link("prayerbookatlas://nowhere") == nil)
        #expect(try link("https://prayerbookatlas.com/atlas") == nil)
        for tab in AppTab.allCases {
            #expect(DeepLink(url: DeepLink.tab(tab).url) == .tab(tab))
        }
    }

    @Test func routeLinksOpenInTheirHomeTab() {
        let model = NavigationModel()
        model.selectedTab = .bible
        model.open(.route(.settings), compact: true)
        #expect(model.selectedTab == .today)
        #expect(model.path(for: .today) == [.settings])
    }

    @Test func searchIsPushedOntoTheCurrentTabOnIPhone() {
        let model = NavigationModel()
        model.selectedTab = .kalendar
        model.open(.tab(.search), compact: true)
        #expect(model.selectedTab == .kalendar)
        #expect(model.path(for: .kalendar) == [.search])
    }

    @Test func searchIsATabOnIPad() {
        let model = NavigationModel()
        model.open(.route(.search), compact: false)
        #expect(model.selectedTab == .search)
        #expect(model.path(for: .search).isEmpty)
    }

    @Test func restoresSavedStateAndIgnoresGarbage() {
        let saved = NavigationModel()
        saved.selectedTab = .atlas
        saved.setPath([.settings], for: .atlas)

        let restored = NavigationModel()
        restored.restore(from: saved.snapshot)
        #expect(restored.selectedTab == .atlas)
        #expect(restored.path(for: .atlas) == [.settings])

        let fresh = NavigationModel()
        fresh.restore(from: Data(#"{"selectedTab":"atlas","paths":{"atlas":["gone"]}}"#.utf8))
        #expect(fresh.selectedTab == .today)
        fresh.restore(from: Data("not json".utf8))
        #expect(fresh.selectedTab == .today)
    }
}
