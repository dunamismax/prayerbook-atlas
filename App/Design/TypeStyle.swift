import CoreText
import SwiftUI
import UIKit

/// A style from the type scale (docs/design.md §5; `type` in design/tokens.json, pinned by
/// `TypographyTests`). Cardo sets liturgical text, titles, and labels; SF sets the interface.
///
/// Every style follows its Dynamic Type text style to AX5 through `typeStyle(_:)`. Colour is
/// not part of the style: components apply the token colour, so callers can change it.
enum TypeStyle: String, CaseIterable, Sendable {
    case display, title, heading, reading, rubric, eyebrow, role, tab, pageNumber, source, sourceMark, action

    /// A bundled Cardo face, by PostScript name, or the system face for the interface.
    enum Face: Sendable, Equatable {
        case cardo(String)
        case system(Font.Weight)

        static let regular = Face.cardo("Cardo-Regular")
        static let italic = Face.cardo("Cardo-Italic")
        static let bold = Face.cardo("Cardo-Bold")
    }

    var face: Face {
        switch self {
        case .display, .title, .heading, .reading, .eyebrow, .role, .tab: .regular
        case .rubric, .pageNumber, .source, .sourceMark: .italic
        case .action: .system(.semibold)
        }
    }

    /// The size in points at the default text size.
    var size: CGFloat {
        switch self {
        case .display: 31
        case .title: 26
        case .heading: 22
        case .reading: 20
        case .rubric: 17
        case .source: 14
        case .action: 14
        case .eyebrow, .role, .pageNumber, .sourceMark: 13
        case .tab: 12
        }
    }

    /// The Dynamic Type style it scales with.
    var textStyle: Font.TextStyle {
        switch self {
        case .display: .largeTitle
        case .title: .title
        case .heading: .title2
        case .reading: .body
        case .rubric: .callout
        case .source, .action: .subheadline
        case .eyebrow, .role, .pageNumber, .sourceMark: .footnote
        case .tab: .caption
        }
    }

    /// Line height as a multiple of the size, where the tokens give one.
    var leading: CGFloat? {
        switch self {
        case .display, .title: 1.15
        case .heading: 1.2
        case .reading: 1.55
        case .rubric: 1.45
        default: nil
        }
    }

    /// Letter spacing in ems.
    var tracking: CGFloat {
        switch self {
        case .eyebrow: 0.12
        case .role: 0.1
        case .tab: 0.08
        case .action: 0.06
        default: 0
        }
    }

    /// Small capitals from lower-case text, by Cardo Regular's `smcp` (the only face that has it).
    var smallCaps: Bool { [.eyebrow, .role, .tab].contains(self) }

    /// Old-style figures, by `onum` (Cardo Regular and Italic).
    var oldStyleFigures: Bool { self == .pageNumber }

    var uppercase: Bool { self == .action }

    /// The font at a given (already scaled) size.
    func font(size: CGFloat) -> Font {
        switch face {
        case .system(let weight):
            .system(size: size, weight: weight)
        case .cardo:
            Font(uiFont(size: size))
        }
    }

    /// The UIKit font at a given size, with the style's OpenType features. Falls back to the
    /// system serif if Cardo failed to register, so text is never missing.
    func uiFont(size: CGFloat) -> UIFont {
        guard case .cardo(let name) = face else {
            return .systemFont(ofSize: size, weight: .semibold)
        }
        var features: [[UIFontDescriptor.FeatureKey: Int]] = []
        if smallCaps {
            features.append([.type: kLowerCaseType, .selector: kLowerCaseSmallCapsSelector])
        }
        if oldStyleFigures {
            features.append([.type: kNumberCaseType, .selector: kLowerCaseNumbersSelector])
        }
        guard let base = UIFont(name: name, size: size) else {
            let serif = UIFont.systemFont(ofSize: size).fontDescriptor.withDesign(.serif)
            return UIFont(descriptor: serif ?? UIFont.systemFont(ofSize: size).fontDescriptor, size: size)
        }
        guard !features.isEmpty else { return base }
        return UIFont(descriptor: base.fontDescriptor.addingAttributes([.featureSettings: features]), size: size)
    }
}

/// Applies a `TypeStyle`, scaled with Dynamic Type.
private struct TypeStyleModifier: ViewModifier {
    let style: TypeStyle
    @ScaledMetric private var size: CGFloat

    init(_ style: TypeStyle) {
        self.style = style
        _size = ScaledMetric(wrappedValue: style.size, relativeTo: style.textStyle)
    }

    func body(content: Content) -> some View {
        content
            .font(style.font(size: size))
            .tracking(style.tracking * size)
            .lineSpacing(lineSpacing)
            .textCase(style.uppercase ? .uppercase : nil)
    }

    /// The extra space between lines that brings the face's own line height up to the style's.
    private var lineSpacing: CGFloat {
        guard let leading = style.leading else { return 0 }
        return max(0, leading * size - style.uiFont(size: size).lineHeight)
    }
}

extension View {
    /// Sets text in a style from the type scale (docs/design.md §5).
    func typeStyle(_ style: TypeStyle) -> some View {
        modifier(TypeStyleModifier(style))
    }
}
