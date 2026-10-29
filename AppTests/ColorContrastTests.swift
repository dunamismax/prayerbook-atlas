import Foundation
import Testing
import UIKit

@testable import PrayerbookAtlas

/// Every text pair in docs/design.md §3 meets WCAG 2 AA (4.5:1) in day and night, measured on
/// the colours actually compiled into the asset catalog, and every ribbon either reaches 3:1
/// against paper or is drawn with an edge in muted that does.
struct ColorContrastTests {
    struct Pair: CustomTestStringConvertible, Sendable {
        let text: String
        let background: String
        var testDescription: String { "\(text) on \(background)" }
    }

    static let pairs: [Pair] =
        ["paper", "card", "wash"].flatMap { surface in
            ["ink", "muted", "rubric"].map { Pair(text: $0, background: surface) }
        } + [Pair(text: "onRubric", background: "rubric")]

    static let styles: [UIUserInterfaceStyle] = [.light, .dark]

    @Test(arguments: pairs, styles)
    func textMeetsAA(pair: Pair, style: UIUserInterfaceStyle) throws {
        let ratio = try contrast(pair.text, pair.background, style)
        #expect(ratio >= 4.5, "\(pair.testDescription) is \(ratio):1 in \(name(style))")
    }

    /// Where a ribbon is faint against paper, its edge in muted must be visible against both.
    @Test(arguments: RibbonColour.allCases.filter(\.needsEdge), styles)
    func faintRibbonEdgeIsVisible(ribbon: RibbonColour, style: UIUserInterfaceStyle) throws {
        guard ribbon.edgeScheme == (style == .dark ? .dark : .light) else { return }
        #expect(try contrast("muted", assetName(ribbon), style) >= 3)
        #expect(try contrast("muted", "paper", style) >= 3)
    }

    /// A ribbon is edged in exactly the appearance where it is faint against paper.
    @Test(arguments: RibbonColour.allCases, styles)
    func ribbonIsVisibleOrEdged(ribbon: RibbonColour, style: UIUserInterfaceStyle) throws {
        let faint = try contrast(assetName(ribbon), "paper", style) < 3
        let edged = ribbon.edgeScheme == (style == .dark ? .dark : .light)
        #expect(faint == edged, "\(ribbon.rawValue) in \(name(style)): faint \(faint), edged \(edged)")
    }

    @Test func ribbonRawValuesNeverChange() {
        #expect(
            RibbonColour.allCases.map(\.rawValue) == [
                "violet", "white", "green", "red", "rose", "black", "blue", "array",
            ]
        )
    }

    private func assetName(_ ribbon: RibbonColour) -> String {
        "ribbon" + ribbon.rawValue.prefix(1).uppercased() + ribbon.rawValue.dropFirst()
    }

    private func name(_ style: UIUserInterfaceStyle) -> String { style == .dark ? "night" : "day" }

    private func contrast(_ a: String, _ b: String, _ style: UIUserInterfaceStyle) throws -> Double {
        let traits = UITraitCollection(userInterfaceStyle: style)
        let first = try #require(UIColor(named: a)).resolvedColor(with: traits)
        let second = try #require(UIColor(named: b)).resolvedColor(with: traits)
        let (lighter, darker) = (max(luminance(first), luminance(second)), min(luminance(first), luminance(second)))
        return (lighter + 0.05) / (darker + 0.05)
    }

    /// WCAG 2 relative luminance of an sRGB colour.
    private func luminance(_ color: UIColor) -> Double {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        func linear(_ channel: CGFloat) -> Double {
            let c = Double(channel)
            return c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * linear(red) + 0.7152 * linear(green) + 0.0722 * linear(blue)
    }
}
