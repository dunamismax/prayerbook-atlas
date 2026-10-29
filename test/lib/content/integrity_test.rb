require "test_helper"

# The content-integrity suite (BUILD.md P3.10). The compiler refuses bad
# content as it reads it; these checks read what it wrote, for the
# repository's own content/ and for the fixture content, so a compiler bug
# cannot let a broken database through. bin/ci also compiles content/ with
# release checks ("Content: compile and check").
class Content::IntegrityTest < ActiveSupport::TestCase
  DATABASES = {
    "content/" => Rails.root.join("content"),
    "fixture content" => Rails.root.join("test/fixtures/files/content")
  }.freeze

  DATABASES.each do |label, root|
    test "#{label}: every id is unique and every reference resolves" do
      database = compile(root)
      ids = database.execute("SELECT id FROM documents UNION ALL SELECT id FROM blocks").flatten
      assert_equal ids.uniq.size, ids.size

      database.execute("SELECT id, data_json FROM blocks WHERE kind IN ('gloria_patri', 'canticle_reference')").each do |id, json|
        target = JSON.parse(json).values_at("full_text", "canticle").compact.first
        next unless target

        found = database.get_first_value("SELECT count(*) FROM blocks WHERE id = ?", target) +
          database.get_first_value("SELECT count(*) FROM documents WHERE id = ?", target)
        assert_equal 1, found, "#{id} refers to #{target}"
      end
      orphans = database.execute("SELECT id FROM blocks WHERE document_id NOT IN (SELECT id FROM documents)")
      assert_empty orphans
      unknown_works = database.execute("SELECT id FROM documents WHERE work IS NOT NULL AND work NOT IN (SELECT id FROM works)")
      assert_empty unknown_works
    end

    test "#{label}: every document's source is registered and cleared for the served territories" do
      database = compile(root)
      territories = Rails.application.config_for(:content).fetch(:territories)
      database.execute("SELECT documents.id, sources.status, sources.cleared_in FROM documents LEFT JOIN sources ON sources.id = documents.source_id").each do |id, status, cleared_in|
        assert_equal "cleared", status, "#{id} has an unregistered or uncleared source"
        cleared = cleared_in.split(",")
        assert(cleared.include?("all") || (territories - cleared).empty?, "#{id} is not cleared for #{territories.join(", ")}")
      end
    end

    test "#{label}: no block is empty, and every book's block has its book, printing, and page" do
      database = compile(root)
      assert_empty database.execute("SELECT id FROM blocks WHERE trim(plain_text) = '' AND kind <> 'alternatives'")
      database.execute("SELECT blocks.id, blocks.book, blocks.printing, blocks.page, documents.book FROM blocks JOIN documents ON documents.id = blocks.document_id WHERE documents.book IS NOT NULL").each do |id, book, printing, page, document_book|
        assert_equal document_book, book, "#{id} is in another book"
        assert printing.present?, "#{id} has no printing"
        assert page.present?, "#{id} has no page"
      end
      assert_empty database.execute("SELECT id FROM documents WHERE kind IN ('note', 'guide', 'glossary') AND review IS NULL")
    end
  end

  private
    def compile(root)
      output = Pathname(Dir.mktmpdir("integrity")).join("content.sqlite3")
      Content::Compiler.new(root: root, output: output, territories: Rails.application.config_for(:content).fetch(:territories)).compile!
      SQLite3::Database.new(output.to_s, readonly: true)
    end
end
