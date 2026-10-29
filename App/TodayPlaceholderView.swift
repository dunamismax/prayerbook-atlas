import SwiftUI

/// A placeholder for the Today screen (BUILD.md P1.7): today's date in paper
/// and ink, and nothing else. P5.1 replaces it with the real Today. It shows no
/// liturgical text: every text must come from a proofread printing (AGENTS.md §6).
struct TodayPlaceholderView: View {
    /// Shown as given; P5.2 adds the Debug `-today` override and the midnight rollover.
    var date: Date = .now

    var body: some View {
        VStack(spacing: 8) {
            Text(date, format: .dateTime.weekday(.wide))
                .font(.title3)
                .foregroundStyle(Color("Muted"))
            Text(date, format: .dateTime.day().month(.wide).year())
                .font(.system(.largeTitle, design: .serif))
                .foregroundStyle(Color("Ink"))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Paper"))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    TodayPlaceholderView()
}
