import SwiftUI

/// Settings until P2.12 builds them: the version and build, and nothing else yet.
struct SettingsPlaceholderView: View {
    private var version: String {
        let info = Bundle.main.infoDictionary
        let marketing = info?["CFBundleShortVersionString"] as? String ?? "?"
        let build = info?["CFBundleVersion"] as? String ?? "?"
        return "\(marketing) (\(build))"
    }

    var body: some View {
        List {
            LabeledContent("Version", value: version)
                .listRowBackground(Color.card)
        }
        .scrollContentBackground(.hidden)
        .background(Color.paper)
        .navigationTitle("Settings")
    }
}
