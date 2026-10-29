import SwiftUI

/// A small-capital label above a heading or on a plate (`eyebrow`, docs/design.md §5). The
/// app's own words are lower-cased so Cardo's `smcp` sets every letter as a small capital.
struct Eyebrow: View {
    private let text: String
    var color: Color = .muted

    init(_ text: LocalizedStringResource, color: Color = .muted) {
        self.text = String(localized: text)
        self.color = color
    }

    var body: some View {
        Text(verbatim: text.lowercased())
            .typeStyle(.eyebrow)
            .foregroundStyle(color)
            .accessibilityLabel(Text(verbatim: text))
            .accessibilityAddTraits(.isHeader)
    }
}

/// A role label exactly as the book prints it ("Minister", "People", or ℣ and ℟), in small
/// capitals and the accent (`role`, docs/design.md §5). The words come from the book's text,
/// so they are never lower-cased or translated.
struct RoleLabel: View {
    let text: String

    var body: some View {
        Text(verbatim: text)
            .typeStyle(.role)
            .foregroundStyle(Color.rubric)
    }
}

/// The printed page number, in italic old-style figures (`pageNumber`, docs/design.md §6).
struct PageNumberMark: View {
    /// The page exactly as the printing numbers it.
    let page: String

    var body: some View {
        Text("p. \(page)", comment: "A printed page number, abbreviated as a book would print it")
            .typeStyle(.pageNumber)
            .foregroundStyle(Color.muted)
            .accessibilityLabel(Text("Page \(page)", comment: "VoiceOver: a printed page number"))
    }
}

/// A season's ribbon marker with its name beside it: colour is never the only carrier of
/// meaning (docs/design.md §4). Faint ribbons get an edge in `muted` in the appearance where
/// they are faint.
struct RibbonMarker: View {
    let ribbon: RibbonColour
    /// Words after the name, such as the note that the colour is a custom (P4.8).
    var caption: LocalizedStringResource?
    @Environment(\.colorScheme) private var colorScheme
    @ScaledMetric(relativeTo: .subheadline) private var length: CGFloat = 34
    @ScaledMetric(relativeTo: .subheadline) private var thickness: CGFloat = 6

    var body: some View {
        HStack(spacing: Spacing.s + 2) {
            Rectangle()
                .fill(ribbon.color)
                .overlay {
                    if ribbon.edgeScheme == colorScheme {
                        Rectangle().strokeBorder(Color.muted, lineWidth: Rule.hairline)
                    }
                }
                .frame(width: length, height: thickness)
                .accessibilityHidden(true)
            Group {
                if let caption {
                    Text("\(ribbon.name) · \(caption)", comment: "A ribbon's colour name, then a note about it")
                } else {
                    Text(ribbon.name)
                }
            }
            .typeStyle(.source)
            .foregroundStyle(Color.muted)
        }
        .accessibilityElement(children: .combine)
    }
}
