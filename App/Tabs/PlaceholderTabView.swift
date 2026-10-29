import SwiftUI

/// A tab root that is not built yet. It says so plainly and shows no liturgical text: every
/// text must come from a proofread printing (AGENTS.md §6).
struct PlaceholderTabView: View {
    let tab: AppTab
    /// False when the screen is pushed as a route rather than shown as a tab's root.
    var isRoot = true
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        Text("This part of the app is not built yet.")
            .font(.body)
            .foregroundStyle(Color.muted)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.paper)
            .navigationTitle(Text(tab.title))
            .toolbar {
                if isRoot { RootToolbar(compact: sizeClass == .compact) }
            }
    }
}
