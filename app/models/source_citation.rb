# Where a text comes from: its book, the printing it was transcribed from, and
# the printed page (AGENTS.md §6), ported from the retired Swift ContentKit
# (tag ios-archive). Every LiturgicalBlock carries one, and the source note
# shows it one click away (P2.5). The stored keys are part of the content
# format (P3.2), so they never change.
class SourceCitation < Data.define(:book, :printing, :page)
  # book: a PrayerBook id; printing: the printing's id in content/SOURCES.md;
  # page: exactly as the printing numbers it ("45", "xii", "45–46").
  def self.from_h(hash)
    hash = hash.to_h.stringify_keys
    new(book: hash.fetch("book"), printing: hash.fetch("printing"), page: hash.fetch("page"))
  end

  def to_h
    { "book" => book, "printing" => printing, "page" => page }
  end
end
