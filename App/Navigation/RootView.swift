import SwiftUI

/// The app's tab structure: one navigation stack per tab plus search, with the selected tab and
/// every path restored on relaunch (docs/product.md §1–2). Search is the system search tab on
/// regular widths and a toolbar button on iPhone (decision 17).
struct RootView: View {
    @State private var navigation = NavigationModel()
    /// The saved tab and paths. UserDefaults rather than SceneStorage, as on Beautiful Corner: it
    /// is written on every change, so the place survives however the app is closed. Never
    /// rename the key.
    @AppStorage("navigation.state") private var savedNavigation = Data()
    @State private var hasRestored = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    /// UI tests pass this to start from a clean state.
    static let resetArgument = "-resetNavigation"

    var body: some View {
        TabView(selection: $navigation.selectedTab) {
            ForEach([AppTab.today, .pray, .bible, .kalendar, .atlas], id: \.self) { tab in
                Tab(value: tab) {
                    stack(for: tab)
                } label: {
                    Label {
                        Text(tab.title)
                    } icon: {
                        Image(systemName: tab.systemImage)
                    }
                }
                .accessibilityIdentifier("tab-\(tab.rawValue)")
            }
            // An iPhone tab bar holds five items and the search tab counts as one, so on compact
            // widths Search is a toolbar button on every root instead (decision 17).
            if sizeClass != .compact {
                Tab(value: AppTab.search, role: .search) {
                    stack(for: .search)
                } label: {
                    Label {
                        Text(AppTab.search.title)
                    } icon: {
                        Image(systemName: AppTab.search.systemImage)
                    }
                }
                .accessibilityIdentifier("tab-search")
            }
        }
        .tint(Color.rubric)
        .onAppear(perform: restore)
        .onOpenURL { url in
            if let link = DeepLink(url: url) {
                navigation.open(link, compact: sizeClass == .compact)
            }
        }
        .onChange(of: sizeClass, initial: true) { _, sizeClass in
            if sizeClass == .compact && navigation.selectedTab == .search {
                navigation.open(.tab(.search), compact: true)
            }
        }
        .onChange(of: navigation.snapshot) { _, snapshot in
            if hasRestored { savedNavigation = snapshot }
        }
    }

    private func stack(for tab: AppTab) -> some View {
        NavigationStack(
            path: Binding(
                get: { navigation.path(for: tab) },
                set: { navigation.setPath($0, for: tab) }
            )
        ) {
            root(for: tab)
                .navigationDestination(for: AppRoute.self) { route in
                    RouteDestination(route: route)
                }
        }
    }

    @ViewBuilder
    private func root(for tab: AppTab) -> some View {
        switch tab {
        case .today: TodayPlaceholderView()
        case .pray, .bible, .kalendar, .atlas, .search: PlaceholderTabView(tab: tab)
        }
    }

    private func restore() {
        guard !hasRestored else { return }
        let arguments = ProcessInfo.processInfo.arguments
        if !arguments.contains(Self.resetArgument) {
            navigation.restore(from: savedNavigation)
        }
        #if DEBUG
            // Screenshots and UI tests can open a tab or a route directly: `-tab atlas`,
            // `-route settings`.
            if let flag = arguments.firstIndex(of: "-tab"), flag + 1 < arguments.count,
                let tab = AppTab(rawValue: arguments[flag + 1])
            {
                navigation.selectedTab = tab
            }
            if let flag = arguments.firstIndex(of: "-route"), flag + 1 < arguments.count,
                let route = AppRoute(path: arguments[flag + 1])
            {
                navigation.open(.route(route), compact: sizeClass == .compact)
            }
        #endif
        hasRestored = true
    }
}

/// The view for each route.
struct RouteDestination: View {
    let route: AppRoute

    var body: some View {
        switch route {
        case .settings: SettingsPlaceholderView()
        case .search: PlaceholderTabView(tab: .search, isRoot: false)
        }
    }
}

/// The buttons on every tab's root screen (docs/product.md §1): Settings, and on iPhone,
/// Search (decision 17).
struct RootToolbar: ToolbarContent {
    let compact: Bool

    var body: some ToolbarContent {
        if compact {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: AppRoute.search) {
                    Label {
                        Text(AppTab.search.title)
                    } icon: {
                        Image(systemName: AppTab.search.systemImage)
                    }
                }
                .accessibilityIdentifier("search-button")
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(value: AppRoute.settings) {
                Label("Settings", systemImage: "gearshape")
            }
            .accessibilityIdentifier("settings-button")
        }
    }
}

/// Adds the root toolbar, reading the size class itself so every root gets the same buttons.
struct RootToolbarModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass

    func body(content: Content) -> some View {
        content.toolbar { RootToolbar(compact: sizeClass == .compact) }
    }
}

extension View {
    func rootToolbar() -> some View {
        modifier(RootToolbarModifier())
    }
}
