import Foundation

/// One block of a prayer book's text as printed: a heading, a paragraph, a rubric, lines with
/// their roles, a psalm verse, a collect, a set of alternatives, and so on (BUILD.md P2.8).
///
/// Every block carries its source: the book, the printing it was transcribed from, and the
/// printed page (AGENTS.md §6). A block belongs to one book; texts are never shared between
/// books by reference. Within a block, inline runs keep the printing's italics, small capitals,
/// insertion points, and page breaks, so the renderer (P2.9) can set it as printed.
public struct LiturgicalBlock: Hashable, Codable, Sendable, Identifiable {
    /// A stable identifier, unique across the content database (P3.2).
    public var id: String
    public var source: SourceCitation
    public var kind: Kind

    public init(id: String, source: SourceCitation, kind: Kind) {
        self.id = id
        self.source = source
        self.kind = kind
    }

    public enum Kind: Hashable, Codable, Sendable {
        /// A heading; level 1 is an office's or service's title.
        case heading(level: Int, text: [Inline])
        case paragraph(text: [Inline])
        /// An instruction, never words to be said.
        case rubric(text: [Inline])
        /// Lines led by the speaker's role as the book prints it ("Minister", "People").
        case roleLines(lines: [RoleLine])
        /// Versicles and responses, led by ℣ and ℟ or the book's own labels.
        case versicles(lines: [RoleLine])
        /// The Amen, with the printing's own words and emphasis.
        case amen(text: [Inline])
        /// The Gloria Patri as the book prints it at this point (often abbreviated), and the id of
        /// the same book's full text when the book gives it elsewhere.
        case gloriaPatri(printed: [Inline], fullText: String?)
        case psalmVerse(verse: PsalmVerse)
        /// A canticle the book appoints here, by the id of the same book's text of it.
        case canticleReference(canticle: String, printed: [Inline])
        case collect(title: [Inline]?, text: [Inline])
        /// Choices the book offers ("or this"), each with its own label as printed.
        case alternatives(options: [Alternative])
        /// A point where the day's proper or seasonal material goes (P6.1), with whatever the
        /// book prints there.
        case seasonalInsertion(key: String, printed: [Inline])
    }
}

/// A run of text within a block.
public enum Inline: Hashable, Codable, Sendable {
    case text(String)
    /// Italic in the printing.
    case italic(String)
    /// Small capitals in the printing, such as the 1979 Psalter's LORD. The text is as printed.
    case smallCaps(String)
    /// A place for a name or title the person or the day supplies.
    case insertion(Insertion)
    /// A line break the printing makes and the reading needs, as in verse.
    case lineBreak
    /// A new printed page begins here, with that page's number as printed.
    case pageBreak(page: String)

    /// The words, without styling; insertion points as printed, page breaks dropped.
    public var plainText: String {
        switch self {
        case .text(let text), .italic(let text), .smallCaps(let text): text
        case .insertion(let insertion): insertion.printed
        case .lineBreak: "\n"
        case .pageBreak: ""
        }
    }
}

extension [Inline] {
    public var plainText: String { map(\.plainText).joined() }
}

/// A place where a name or title is said: the book prints a mark ("N.", "our Sovereign Lord"),
/// and the person or the day may supply the name.
public struct Insertion: Hashable, Codable, Sendable {
    public enum Kind: String, Hashable, Codable, Sendable, CaseIterable {
        /// A person's name, often printed "N." (P13.3's intercession names).
        case name
        /// The sovereign or head of state in the state prayers (P7.9).
        case sovereign
        /// The bishop of the diocese.
        case bishop
        /// Any other insertion the book marks.
        case other
    }

    public var kind: Kind
    /// Exactly what the printing shows at this point.
    public var printed: String

    public init(kind: Kind, printed: String) {
        self.kind = kind
        self.printed = printed
    }
}

/// A line led by its role.
public struct RoleLine: Hashable, Codable, Sendable {
    /// The role exactly as printed, including ℣ and ℟ or nothing at all.
    public var role: String
    public var text: [Inline]

    public init(role: String, text: [Inline]) {
        self.role = role
        self.text = text
    }
}

/// The mark a Psalter prints between the halves of a verse.
public enum HalfVerseMark: String, Hashable, Codable, Sendable, CaseIterable {
    case colon
    case asterisk
}

/// A psalm verse in a book's own Psalter, numbered as that book numbers it.
public struct PsalmVerse: Hashable, Codable, Sendable {
    public var psalm: Int
    /// The verse number as this book prints it.
    public var verse: Int
    /// The King James Version's verse number, where it differs from the book's.
    public var kjvVerse: Int?
    public var firstHalf: [Inline]
    public var secondHalf: [Inline]
    public var mark: HalfVerseMark

    public init(
        psalm: Int, verse: Int, kjvVerse: Int? = nil, firstHalf: [Inline], secondHalf: [Inline],
        mark: HalfVerseMark
    ) {
        self.psalm = psalm
        self.verse = verse
        self.kjvVerse = kjvVerse
        self.firstHalf = firstHalf
        self.secondHalf = secondHalf
        self.mark = mark
    }
}

/// One choice in a set of alternatives, with the book's own label ("Or this", "Or else").
public struct Alternative: Hashable, Codable, Sendable {
    public var label: [Inline]?
    public var blocks: [LiturgicalBlock]

    public init(label: [Inline]?, blocks: [LiturgicalBlock]) {
        self.label = label
        self.blocks = blocks
    }
}

extension LiturgicalBlock {
    /// The block's words without styling, for search, sharing, and VoiceOver.
    public var plainText: String {
        switch kind {
        case .heading(_, let text), .paragraph(let text), .rubric(let text), .amen(let text):
            text.plainText
        case .roleLines(let lines), .versicles(let lines):
            lines.map { [$0.role, $0.text.plainText].filter { !$0.isEmpty }.joined(separator: " ") }
                .joined(separator: "\n")
        case .gloriaPatri(let printed, _), .canticleReference(_, let printed), .seasonalInsertion(_, let printed):
            printed.plainText
        case .psalmVerse(let verse):
            [verse.firstHalf.plainText, verse.mark == .colon ? ":" : "*", verse.secondHalf.plainText]
                .joined(separator: " ")
        case .collect(let title, let text):
            [title?.plainText, text.plainText].compactMap { $0 }.joined(separator: "\n")
        case .alternatives(let options):
            options.flatMap(\.blocks).map(\.plainText).joined(separator: "\n")
        }
    }

    /// The printed pages the block appears on: its own, then any page breaks within it.
    public var pages: [String] {
        [source.page] + inlines.compactMap { if case .pageBreak(let page) = $0 { page } else { nil } }
    }

    /// Every inline run in the block, nested alternatives included.
    public var inlines: [Inline] {
        switch kind {
        case .heading(_, let text), .paragraph(let text), .rubric(let text), .amen(let text):
            text
        case .roleLines(let lines), .versicles(let lines):
            lines.flatMap(\.text)
        case .gloriaPatri(let printed, _), .canticleReference(_, let printed), .seasonalInsertion(_, let printed):
            printed
        case .psalmVerse(let verse):
            verse.firstHalf + verse.secondHalf
        case .collect(let title, let text):
            (title ?? []) + text
        case .alternatives(let options):
            options.flatMap { ($0.label ?? []) + $0.blocks.flatMap(\.inlines) }
        }
    }

    /// Problems that make a block unusable: no words, no page, a misnumbered verse, or an
    /// alternative drawn from another book. The content compiler (P3.3, P3.10) refuses them.
    public var problems: [String] {
        var found: [String] = []
        if source.page.trimmingCharacters(in: .whitespaces).isEmpty { found.append("\(id): no printed page") }
        if source.printing.isEmpty { found.append("\(id): no printing") }
        switch kind {
        case .psalmVerse(let verse):
            if verse.psalm < 1 || verse.psalm > 150 || verse.verse < 1 {
                found.append("\(id): psalm or verse out of range")
            }
        case .heading(let level, _):
            if level < 1 { found.append("\(id): heading level below 1") }
        case .alternatives(let options):
            if options.count < 2 { found.append("\(id): alternatives need at least two options") }
            for block in options.flatMap(\.blocks) {
                if block.source.book != source.book {
                    found.append("\(id): alternative \(block.id) is from another book")
                }
                found += block.problems
            }
        default:
            break
        }
        if case .alternatives = kind {
        } else if plainText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            found.append("\(id): no words")
        }
        return found
    }
}
