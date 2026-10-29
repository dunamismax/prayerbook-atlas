import Foundation
import Testing

@testable import ContentKit

/// The block model (BUILD.md P2.8). Every word here is a bracketed placeholder: no prayer-book
/// text is typed from memory (AGENTS.md §6).
struct LiturgicalBlockTests {
    private let page12 = SourceCitation(book: .bcp1662, printing: "example", page: "12")

    private func block(_ id: String, _ kind: LiturgicalBlock.Kind, book: PrayerBookID = .bcp1662) -> LiturgicalBlock {
        LiturgicalBlock(id: id, source: SourceCitation(book: book, printing: "example", page: "12"), kind: kind)
    }

    @Test func roundTripsThroughJSON() throws {
        let blocks = [
            block("h", .heading(level: 1, text: [.text("[Office]")])),
            block("r", .rubric(text: [.text("[Rubric] "), .italic("[italic]")])),
            block(
                "v",
                .versicles(lines: [
                    RoleLine(role: "℣", text: [.text("[Versicle]")]),
                    RoleLine(role: "℟", text: [.text("[Response]")]),
                ])),
            block(
                "p",
                .psalmVerse(
                    verse: PsalmVerse(
                        psalm: 1, verse: 2, kjvVerse: 3, firstHalf: [.smallCaps("[Lord]")], secondHalf: [.text("[b]")],
                        mark: .asterisk))),
            block(
                "c",
                .collect(title: nil, text: [.text("[Collect] "), .insertion(Insertion(kind: .name, printed: "N."))])),
            block("g", .gloriaPatri(printed: [.text("[Glory]")], fullText: "gloria-full")),
            block(
                "a",
                .alternatives(options: [
                    Alternative(label: nil, blocks: [block("a1", .paragraph(text: [.text("[One]")]))]),
                    Alternative(
                        label: [.italic("[Or this]")], blocks: [block("a2", .paragraph(text: [.text("[Two]")]))]),
                ])),
        ]
        let data = try JSONEncoder().encode(blocks)
        #expect(try JSONDecoder().decode([LiturgicalBlock].self, from: data) == blocks)
    }

    @Test func plainTextKeepsInsertionsAsPrintedAndDropsPageBreaks() {
        let paragraph = block(
            "p",
            .paragraph(text: [
                .text("[Before] "), .insertion(Insertion(kind: .sovereign, printed: "[Sovereign]")),
                .pageBreak(page: "13"), .text(" [after]"),
            ]))
        #expect(paragraph.plainText == "[Before] [Sovereign] [after]")
        #expect(paragraph.pages == ["12", "13"])
    }

    @Test func psalmVerseShowsItsOwnHalfVerseMark() {
        let colon = block(
            "c",
            .psalmVerse(
                verse: PsalmVerse(
                    psalm: 1, verse: 1, firstHalf: [.text("[a]")], secondHalf: [.text("[b]")], mark: .colon)))
        #expect(colon.plainText == "[a] : [b]")
    }

    @Test func roleLinesKeepTheirPrintedRoles() {
        let lines = block(
            "l",
            .roleLines(lines: [
                RoleLine(role: "[Minister]", text: [.text("[a]")]), RoleLine(role: "", text: [.text("[b]")]),
            ]))
        #expect(lines.plainText == "[Minister] [a]\n[b]")
    }

    @Test func soundBlocksHaveNoProblems() {
        #expect(block("ok", .paragraph(text: [.text("[Words]")])).problems.isEmpty)
    }

    @Test func emptyAndUnpagedBlocksAreProblems() {
        #expect(block("empty", .paragraph(text: [.pageBreak(page: "13")])).problems == ["empty: no words"])
        let unpaged = LiturgicalBlock(
            id: "x", source: SourceCitation(book: .bcp1662, printing: "example", page: " "),
            kind: .paragraph(text: [.text("[Words]")]))
        #expect(unpaged.problems == ["x: no printed page"])
    }

    @Test func psalmNumbersAreChecked() {
        let bad = block(
            "p",
            .psalmVerse(
                verse: PsalmVerse(
                    psalm: 151, verse: 1, firstHalf: [.text("[a]")], secondHalf: [.text("[b]")], mark: .colon)))
        #expect(bad.problems == ["p: psalm or verse out of range"])
    }

    /// Each book on its own terms: an alternative may never come from another book (D8).
    @Test func alternativesMayNotBorrowFromAnotherBook() {
        let mixed = block(
            "alt",
            .alternatives(options: [
                Alternative(label: nil, blocks: [block("own", .paragraph(text: [.text("[One]")]))]),
                Alternative(label: nil, blocks: [block("other", .paragraph(text: [.text("[Two]")]), book: .bcp1979us)]),
            ]))
        #expect(mixed.problems == ["alt: alternative other is from another book"])
    }

    @Test func alternativesNeedTwoOptions() {
        let single = block(
            "alt",
            .alternatives(options: [Alternative(label: nil, blocks: [block("one", .paragraph(text: [.text("[One]")]))])]
            ))
        #expect(single.problems == ["alt: alternatives need at least two options"])
    }

    @Test func storedRawValuesNeverChange() {
        #expect(HalfVerseMark.allCases.map(\.rawValue) == ["colon", "asterisk"])
        #expect(Insertion.Kind.allCases.map(\.rawValue) == ["name", "sovereign", "bishop", "other"])
    }
}
