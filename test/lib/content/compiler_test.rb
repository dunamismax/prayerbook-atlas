require "test_helper"

# The content compiler (BUILD.md P3.3–P3.6, P3.10): the fixture content
# compiles, the output is deterministic, and every refusal in
# docs/content-format.md §9 is made.
class Content::CompilerTest < ActiveSupport::TestCase
  FIXTURE = Rails.root.join("test/fixtures/files/content")

  setup do
    @out = Pathname(Dir.mktmpdir("compiled"))
    @dir = @out.join("content")
    FileUtils.cp_r(FIXTURE, @dir)
  end

  teardown { FileUtils.rm_rf(@out) }

  test "the fixture content compiles, with blocks, verses, sources, and search" do
    result = compile
    assert_equal 4, result.documents
    database = SQLite3::Database.new(result.output.to_s)
    assert_equal 1, database.get_first_value("PRAGMA user_version")
    assert_equal "4", database.get_first_value("SELECT page FROM blocks WHERE id = 'bcp1662.example-office.collect'")
    assert_equal "bcp1662.example-office.choice",
      database.get_first_value("SELECT parent_id FROM blocks WHERE id = 'bcp1662.example-office.choice.2.second'")
    assert_equal 2, database.get_first_value("SELECT count(*) FROM scripture_verses")
    assert_equal 4, database.get_first_value("SELECT count(*) FROM search WHERE search MATCH 'grace'")
  end

  test "the same content compiles to the same bytes" do
    first = compile(output: @out.join("one.sqlite3")).output.binread
    second = compile(output: @out.join("two.sqlite3")).output.binread
    assert_equal Digest::SHA256.hexdigest(first), Digest::SHA256.hexdigest(second)
  end

  test "the repository's own content compiles with release checks" do
    result = Content::Compiler.new(root: Rails.root.join("content"), output: @out.join("real.sqlite3"),
      territories: %w[US], design_registry: Rails.root.join("design/image-registry.json")).compile!
    assert_empty result.warnings
  end

  test "an unknown source is refused" do
    edit("original/example-note.txt") { _1.sub("source: original", "source: nowhere") }
    assert_refused(/unknown source nowhere/)
  end

  test "an uncleared source is refused, and is only a warning when pending is allowed" do
    edit("books/bcp1979us/example-prayer.txt") { _1.gsub("example-1979", "example-pending").gsub("bcp1979us", "bcp1928us") }
    assert_refused(/source example-pending is pending, not cleared for US/)
    result = compile(allow_pending: true)
    assert_match(/example-pending is pending/, result.warnings.join)
  end

  test "a source cleared for one territory is not cleared for another" do
    assert_refused(/example-1662 is cleared, not cleared for US, UK/, territories: %w[US UK])
  end

  test "a text is not placed in a book its printing does not belong to" do
    edit("books/bcp1979us/example-prayer.txt") { _1.gsub("example-1979", "example-1662") }
    assert_refused(/printing example-1662 belongs to bcp1662, not bcp1979us/)
  end

  test "an unknown book is refused" do
    edit("books/bcp1979us/example-prayer.txt") { _1.sub("book: bcp1979us", "book: bcp1549") }
    assert_refused(/unknown prayer book bcp1549/)
  end

  test "duplicate ids are refused" do
    @dir.join("original/copy.txt").write(@dir.join("original/example-note.txt").read)
    assert_refused(/document id note.example used twice/)
  end

  test "a reference that does not resolve is refused" do
    edit("books/bcp1662/example-office.txt") { _1.sub("full=bcp1662.example-office.gloria-full", "full=bcp1662.nowhere") }
    assert_refused(/refers to bcp1662.nowhere, which does not exist/)
  end

  test "a reference into another book is refused" do
    edit("books/bcp1662/example-office.txt") { _1.sub("full=bcp1662.example-office.gloria-full", "full=bcp1979us.example-prayer.text") }
    assert_refused(/in another book \(bcp1979us\)/)
  end

  test "an unknown work is refused" do
    edit("books/bcp1979us/example-prayer.txt") { _1.sub("work: example-prayer", "work: nowhere") }
    assert_refused(/unknown work nowhere/)
  end

  test "original work without review is refused" do
    edit("original/example-note.txt") { _1.sub("review: pending\n", "") }
    assert_refused(/missing review/)
  end

  test "a block with no words or no page is refused" do
    edit("books/bcp1979us/example-prayer.txt") { _1.sub("[Example prayer about grace and peace.]", "") }
    assert_refused(/no words/)
    edit("books/bcp1979us/example-prayer.txt") { _1.sub("page: 101\n", "") }
    assert_refused(/missing page/)
  end

  test "Scripture must name an accepted translation that its source is an edition of" do
    edit("scripture/kjva/example.txt") { _1.sub("translation: kjva", "translation: niv") }
    assert_refused(/unknown translation niv/)
    edit("scripture/kjva/example.txt") { _1.sub("translation: niv", "translation: web") }
    assert_refused(/source example-kjva is the kjva, not the web/)
  end

  test "licensed Scripture needs a notice and stays within its verse limit" do
    edit("SOURCES.md") do
      _1.sub("license: public-domain\nai_use: not-applicable; a test fixture\nstatus: cleared\ncleared_in: US\nchecked",
        "license: permission\nai_use: not-applicable; a test fixture\nstatus: cleared\ncleared_in: US\nverse_limit: 1\nchecked")
    end
    assert_refused(/licensed source example-kjva has no notice/)
    assert_refused(/2 verses, beyond its license's 1/)
  end

  test "an AI-generated image of a sacred person is refused" do
    registry = @out.join("registry.json")
    registry.write(JSON.generate("assets" => [ { "id" => "x", "path" => "x.png", "source_type" => "AI-generated", "creator" => "tool",
      "date" => "2026-10-29", "holder" => nil, "rights_basis" => "generated", "status" => "pending", "depicts_sacred_person" => true } ]))
    assert_refused(/must not depict a sacred person/, design_registry: registry)
  end

  test "the repository's design registry passes the image check" do
    assert compile(design_registry: Rails.root.join("design/image-registry.json"))
  end

  test "a file in the wrong place is refused" do
    @dir.join("books/bcp1662/notes.md").write("stray")
    assert_refused(%r{books/bcp1662/notes.md: not a place for content})
  end

  test "a calendar table needs its source and a page on every entry" do
    edit("calendar/bcp1662.json") { _1.sub(', "page": "xx"', "") }
    assert_refused(/entry 1 has no page/)
  end

  private
    def compile(output: @out.join("out.sqlite3"), territories: %w[US], allow_pending: false, design_registry: nil)
      Content::Compiler.new(root: @dir, output: output, territories: territories, allow_pending: allow_pending,
        design_registry: design_registry).compile!
    end

    def assert_refused(pattern, **options)
      error = assert_raises(Content::Compiler::Failed) { compile(**options) }
      assert_match pattern, error.message
    end

    def edit(relative)
      path = @dir.join(relative)
      path.write(yield(path.read))
    end
end
