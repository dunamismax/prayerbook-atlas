# Search across the content database (BUILD.md P3.9): FTS5 over every block
# and verse, ranked by bm25 with the title weighted, with a snippet of the
# matching words. The person's words are quoted term by term, so nothing they
# type is read as FTS5 syntax.
class Content::Search
  KINDS = %w[office prayer collect psalm scripture rubric].freeze
  LIMIT = 50
  # Snippet markers no text contains: the match begins and ends here.
  OPEN = "\u0002"
  CLOSE = "\u0003"

  Result = Data.define(:target_id, :document_id, :title, :book, :kind, :block_kind, :page, :snippet) do
    def prayer_book = book && PrayerBook.find(book)

    # The snippet as [text, matched?] pairs, for the view to mark up safely.
    def snippet_parts
      snippet.split(/(#{OPEN}.*?#{CLOSE})/o).reject(&:empty?).map do |part|
        part.start_with?(OPEN) ? [ part.delete(OPEN + CLOSE), true ] : [ part, false ]
      end
    end

    # "Genesis 1:1" style for a verse, from its target id.
    def verse = block_kind == "verse" ? target_id.split(".").last(2).join(":") : nil
  end

  attr_reader :query, :book, :kind

  def initialize(query:, book: nil, kind: nil)
    @query = query.to_s.strip.first(200)
    @book = book.presence_in(PrayerBook.ids)
    @kind = kind.presence_in(KINDS)
  end

  def terms = query.scan(/[\p{L}\p{N}]+/).first(12)
  def blank? = terms.empty?

  def results
    return [] if blank?

    @results ||= ContentRecord.connection.select_all(sql, "Content search", binds).map { Result.new(**_1.symbolize_keys) }
  end

  private
    def match = terms.map { %("#{_1}") }.join(" ")

    def sql
      conditions = [ "search MATCH ?" ]
      conditions << "search.book = ?" if book
      conditions << (kind == "rubric" ? "search.block_kind = ?" : "search.kind = ?") if kind
      <<~SQL
        SELECT search.target_id, search.document_id, search.title, search.book, search.kind, search.block_kind,
          blocks.page AS page, snippet(search, 1, '#{OPEN}', '#{CLOSE}', '…', 16) AS snippet
        FROM search LEFT JOIN blocks ON blocks.id = search.target_id
        WHERE #{conditions.join(" AND ")}
        ORDER BY bm25(search, 5.0, 1.0), search.target_id
        LIMIT #{LIMIT}
      SQL
    end

    def binds = [ match, book, kind ].compact
end
