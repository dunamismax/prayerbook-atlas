import CoreText
import Foundation
import SwiftUI
import Testing
import UIKit

@testable import PrayerbookAtlas

/// The bundled book face (Cardo) registers, carries the marks the prayer books print, and gives
/// the OpenType features the type scale relies on; and the scale matches design/tokens.json
/// (docs/design.md §5, BUILD.md P2.4).
@MainActor
struct TypographyTests {
    nonisolated static let faces = ["Cardo-Regular", "Cardo-Italic", "Cardo-Bold"]

    @Test(arguments: faces)
    func faceIsRegistered(name: String) {
        #expect(UIFont(name: name, size: 17) != nil, "\(name) is not registered (UIAppFonts)")
    }

    /// ℣ ℟ † ¶ and polytonic Greek, in every face.
    @Test(arguments: faces)
    func faceHasLiturgicalMarksAndGreek(name: String) throws {
        let font = try #require(UIFont(name: name, size: 17)) as CTFont
        for text in ["\u{2123}", "\u{211F}", "\u{2020}", "\u{00B6}", "ἀρχὴ καὶ τέλος"] {
            #expect(hasGlyphs(font, for: text), "\(name) lacks \(text)")
        }
    }

    /// No candidate face has ✠ (decision 18); it falls back to the system's symbol font. If a
    /// future Cardo adds it, this test says so and docs/design.md §5 should change.
    @Test func cardoLacksMalteseCross() throws {
        let font = try #require(UIFont(name: "Cardo-Regular", size: 17)) as CTFont
        #expect(!hasGlyphs(font, for: "\u{2720}"))
    }

    @Test func smallCapitalsChangeTheGlyphs() {
        let plain = UIFont(name: "Cardo-Regular", size: 17)
        let small = TypeStyle.eyebrow.uiFont(size: 17)
        #expect(plain != nil)
        if let plain {
            #expect(shapedGlyphs("minister", plain) != shapedGlyphs("minister", small))
        }
    }

    @Test func pageNumbersUseOldStyleFigures() {
        let plain = UIFont(name: "Cardo-Italic", size: 13)
        let figures = TypeStyle.pageNumber.uiFont(size: 13)
        #expect(plain != nil)
        if let plain {
            #expect(shapedGlyphs("1662", plain) != shapedGlyphs("1662", figures))
        }
    }

    @Test(arguments: TypeStyle.allCases)
    func styleScalesToAccessibilitySizes(style: TypeStyle) {
        let ax5 = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        let scaled = UIFontMetrics(forTextStyle: uiTextStyle(style.textStyle))
            .scaledValue(for: style.size, compatibleWith: ax5)
        #expect(scaled > style.size)
    }

    /// Each style's size, text style, tracking, and leading match `type` in design/tokens.json.
    @Test(arguments: TypeStyle.allCases)
    func styleMatchesTokens(style: TypeStyle) throws {
        let tokensURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent()
            .appending(path: "design/tokens.json")
        let tokens = try JSONSerialization.jsonObject(with: Data(contentsOf: tokensURL)) as? [String: Any]
        let types = try #require(tokens?["type"] as? [String: Any])
        let entry = try #require(types[style.rawValue] as? [String: Any], "no \(style.rawValue) in tokens")

        #expect((entry["size"] as? Double).map { CGFloat($0) } == style.size)
        #expect(entry["textStyle"] as? String == name(style.textStyle))
        let tracking = (entry["tracking"] as? String).flatMap { Double($0.replacing("em", with: "")) } ?? 0
        #expect(abs(CGFloat(tracking) - style.tracking) < 0.0001)
        #expect((entry["leading"] as? Double).map { CGFloat($0) } == style.leading)
        let isSerif = entry["font"] as? String == "serif"
        if case .cardo = style.face { #expect(isSerif) } else { #expect(!isSerif) }
        let italic = entry["style"] as? String == "italic"
        #expect(italic == (style.face == .italic))
    }

    @Test func styleRawValuesNeverChange() {
        #expect(
            TypeStyle.allCases.map(\.rawValue) == [
                "display", "title", "heading", "reading", "rubric", "eyebrow", "role", "tab", "pageNumber",
                "source", "sourceMark", "action",
            ]
        )
    }

    // MARK: - Helpers

    private func hasGlyphs(_ font: CTFont, for text: String) -> Bool {
        let characters = Array(text.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: characters.count)
        return CTFontGetGlyphsForCharacters(font, characters, &glyphs, characters.count)
    }

    /// The glyphs CoreText chooses after OpenType substitution.
    private func shapedGlyphs(_ text: String, _ font: UIFont) -> [CGGlyph] {
        let line = CTLineCreateWithAttributedString(NSAttributedString(string: text, attributes: [.font: font]))
        let runs = CTLineGetGlyphRuns(line) as? [CTRun] ?? []
        return runs.flatMap { run in
            var glyphs = [CGGlyph](repeating: 0, count: CTRunGetGlyphCount(run))
            CTRunGetGlyphs(run, CFRange(location: 0, length: 0), &glyphs)
            return glyphs
        }
    }

    private func uiTextStyle(_ style: Font.TextStyle) -> UIFont.TextStyle {
        switch style {
        case .largeTitle: .largeTitle
        case .title: .title1
        case .title2: .title2
        case .title3: .title3
        case .headline: .headline
        case .subheadline: .subheadline
        case .callout: .callout
        case .footnote: .footnote
        case .caption: .caption1
        case .caption2: .caption2
        default: .body
        }
    }

    private func name(_ style: Font.TextStyle) -> String {
        switch style {
        case .largeTitle: "largeTitle"
        case .title: "title"
        case .title2: "title2"
        case .title3: "title3"
        case .headline: "headline"
        case .subheadline: "subheadline"
        case .callout: "callout"
        case .footnote: "footnote"
        case .caption: "caption"
        case .caption2: "caption2"
        default: "body"
        }
    }
}
