import SwiftUI

/// Engraved rules (docs/design.md §7; `rule` in design/tokens.json). Rules are ornament:
/// VoiceOver never reads them.
enum Rule {
    static let hairline: CGFloat = 1
    /// The overall thickness of a double rule: two hairlines with a gap between.
    static let double: CGFloat = 3
}

/// A horizontal double rule: under an office's title in ink, or between sections.
struct DoubleRule: View {
    var color: Color = .ink

    var body: some View {
        VStack(spacing: Rule.double - 2 * Rule.hairline) {
            Rectangle().fill(color).frame(height: Rule.hairline)
            Rectangle().fill(color).frame(height: Rule.hairline)
        }
        .accessibilityHidden(true)
    }
}

/// A single horizontal hairline in `line`, between rows.
struct Hairline: View {
    var body: some View {
        Rectangle().fill(Color.line).frame(height: Rule.hairline).accessibilityHidden(true)
    }
}

/// Frames a view with a double rule on all four sides, square-cornered.
private struct DoubleRuleFrame: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content.overlay {
            ZStack {
                Rectangle().strokeBorder(color, lineWidth: Rule.hairline)
                Rectangle().strokeBorder(color, lineWidth: Rule.hairline).padding(Rule.double - Rule.hairline)
            }
            .accessibilityHidden(true)
        }
    }
}

extension View {
    /// A double-rule frame: `line` for cards, `ink` for the atlas plate (docs/design.md §7).
    func doubleRuleFrame(_ color: Color = .line) -> some View {
        modifier(DoubleRuleFrame(color: color))
    }
}
