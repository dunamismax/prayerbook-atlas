import SwiftUI

/// A season's ribbon marker colour (docs/design.md §4), always shown beside its name.
///
/// Most prayer books prescribe no liturgical colours, so the app presents them as custom
/// (P4.8). The raw values are stored in settings, so they never change once released
/// (pinned by `RibbonColourTests`).
enum RibbonColour: String, CaseIterable, Sendable {
    case violet, white, green, red, rose, black, blue, array

    /// The word that always accompanies the colour: colour is never the only carrier of meaning.
    var name: LocalizedStringResource {
        switch self {
        case .violet: "Violet"
        case .white: "White"
        case .green: "Green"
        case .red: "Red"
        case .rose: "Rose"
        case .black: "Black"
        case .blue: "Sarum blue"
        case .array: "Lenten array"
        }
    }

    /// The swatch from design/tokens.json (`ribbon`). Never used for text or chrome.
    var color: Color {
        switch self {
        case .violet: .ribbonViolet
        case .white: .ribbonWhite
        case .green: .ribbonGreen
        case .red: .ribbonRed
        case .rose: .ribbonRose
        case .black: .ribbonBlack
        case .blue: .ribbonBlue
        case .array: .ribbonArray
        }
    }

    /// The appearance in which the ribbon falls below 3:1 against paper and is drawn with a
    /// hairline edge in `muted` (`edge: muted` in design/tokens.json; checked by
    /// `ColorContrastTests`), or nil if it is visible in both.
    var edgeScheme: ColorScheme? {
        switch self {
        case .white, .array: .light
        case .black: .dark
        default: nil
        }
    }

    var needsEdge: Bool { edgeScheme != nil }
}
