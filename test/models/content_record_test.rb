require "test_helper"

# The read-only content database and its models (BUILD.md P3.7), against the
# fixture database test_helper.rb compiles.
class ContentRecordTest < ActiveSupport::TestCase
  test "documents, blocks, and sources are read back" do
    document = Content::Document.find("bcp1662.example-office")
    assert_equal "example-1662", document.source.id
    assert_equal PrayerBook.find("bcp1662"), document.prayer_book
    assert_equal "bcp1662.example-office.title", document.blocks.first.id
  end

  test "a block comes back as the LiturgicalBlock it was compiled from" do
    block = Content::Block.find("bcp1662.example-office.collect").liturgical_block
    assert_kind_of LiturgicalBlock::Collect, block
    assert_equal SourceCitation.new(book: "bcp1662", printing: "example-1662", page: "4"), block.source
  end

  test "original work has no liturgical block" do
    assert_nil Content::Block.find("note.example.2").liturgical_block
  end

  test "scripture verses keep their translation" do
    verse = Content::ScriptureVerse.find_by(translation: "kjva", bible_book: "GEN", chapter: 1, verse: 1)
    assert_equal "[Example verse about grace.]", LiturgicalBlock::Inline.plain_text(verse.text)
  end

  test "the database is read-only" do
    assert_raises(ActiveRecord::ReadOnlyRecord) { Content::Work.first.update!(title: "x") }
    assert_raises(ActiveRecord::StatementInvalid) { ContentRecord.connection.execute("DELETE FROM works") }
  end
end
