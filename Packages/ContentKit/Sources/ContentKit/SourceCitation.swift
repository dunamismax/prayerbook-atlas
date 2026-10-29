/// Where a text comes from: its book, the printing it was transcribed from, and the printed
/// page (AGENTS.md §6). Every liturgical block carries one (P2.8), and the source footnote shows
/// it one tap away (P2.5).
public struct SourceCitation: Hashable, Codable, Sendable {
    public var book: PrayerBookID
    /// The printing's identifier, as registered in content/SOURCES.md.
    public var printing: String
    /// The printed page exactly as the printing numbers it: "45", "xii", or a range "45–46".
    public var page: String

    public init(book: PrayerBookID, printing: String, page: String) {
        self.book = book
        self.printing = printing
        self.page = page
    }
}
