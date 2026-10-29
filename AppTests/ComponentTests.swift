import ContentKit
import Foundation
import Testing

@testable import PrayerbookAtlas

/// The shared components' pure parts (BUILD.md P2.5).
struct ComponentTests {
    private let source = SourceDetails(
        citation: SourceCitation(book: .bcp1662, printing: "example", page: "45"),
        printingTitle: "Example Printing"
    )

    /// Shared text always carries its source, and any licence notice after it.
    @Test func sharedTextCarriesItsSource() {
        let shared = ShareableText(body: "[Text]", source: source)
        #expect(shared.formatted == "[Text]\n\n— The Book of Common Prayer (1662), Example Printing, p. 45")
    }

    @Test func sharedTextEndsWithItsNotice() {
        let shared = ShareableText(body: "[Text]", source: source, notice: "[Notice]")
        #expect(shared.formatted.hasSuffix("p. 45\n\n[Notice]"))
    }

    @Test func rubricPresentationRawValuesNeverChange() {
        #expect(RubricPresentation.allCases.map(\.rawValue) == ["colour", "italic"])
    }

    /// Book titles are what sources and share lines print; the short titles head compare columns.
    @Test func bookTitles() {
        #expect(PrayerBookID.allCases.map { String(localized: $0.shortTitle) } == ["1662", "1928", "1979"])
        #expect(String(localized: PrayerBookID.bcp1979us.title) == "The Book of Common Prayer (1979)")
    }
}
