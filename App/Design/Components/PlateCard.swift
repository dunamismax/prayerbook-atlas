import SwiftUI

/// Spacing from `space` in design/tokens.json.
enum Spacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    /// The page margin on iPhone.
    static let margin: CGFloat = 22
    static let cardPadding: CGFloat = 16
    /// The reading measure: wider screens add margins, not longer lines.
    static let readingMeasure: CGFloat = 640
}

/// A card: `card` ground in a double-rule frame of `line`, square-cornered, with an optional
/// small-capital label (docs/design.md §7, §12).
struct PlateCard<Content: View>: View {
    var label: LocalizedStringResource?
    var labelColor: Color = .muted
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s + 2) {
            if let label {
                Eyebrow(label, color: labelColor)
            }
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardPadding)
        .background(Color.card)
        .doubleRuleFrame(.line)
    }
}

/// The atlas plate: the same frame drawn in `ink`, for the Atlas tab's plates (compare, book
/// pages, the lineage map).
struct AtlasPlate<Content: View>: View {
    var label: LocalizedStringResource?
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            if let label {
                Eyebrow(label)
            }
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.m + 2)
        .background(Color.card)
        .doubleRuleFrame(.ink)
    }
}
