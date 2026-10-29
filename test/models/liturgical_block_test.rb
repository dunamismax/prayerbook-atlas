require "test_helper"

# The block model (BUILD.md P2.8), ported with the retired Swift tests. Every
# word here is a bracketed placeholder: no prayer-book text is typed from
# memory (AGENTS.md §6).
class LiturgicalBlockTest < ActiveSupport::TestCase
  include LiturgicalBlock

  def source(book: "bcp1662", page: "12", printing: "example")
    SourceCitation.new(book: book, printing: printing, page: page)
  end

  def text(words) = Inline::Text.new(text: words)

  def paragraph(id, *inlines, book: "bcp1662")
    Paragraph.new(id: id, source: source(book: book), text: inlines.presence || [ text("[Words]") ])
  end

  def psalm_verse(psalm: 1, verse: 1, kjv_verse: nil, mark: "colon")
    PsalmVerse.new(id: "p", source: source, psalm: psalm, verse: verse, kjv_verse: kjv_verse,
      first_half: [ text("[a]") ], second_half: [ text("[b]") ], mark: mark)
  end

  test "every kind round-trips through its hash form and JSON" do
    blocks = [
      Heading.new(id: "h", source: source, level: 1, text: [ text("[Office]") ]),
      paragraph("para", text("[Words]"), Inline::LineBreak.new, Inline::PageBreak.new(page: "13"), text("[More]")),
      Rubric.new(id: "r", source: source, text: [ text("[Rubric] "), Inline::Italic.new(text: "[italic]") ]),
      RoleLines.new(id: "l", source: source, lines: [ RoleLine.new(role: "[Minister]", text: [ text("[a]") ]) ]),
      Versicles.new(id: "v", source: source, lines: [
        RoleLine.new(role: "℣", text: [ text("[Versicle]") ]), RoleLine.new(role: "℟", text: [ text("[Response]") ])
      ]),
      Amen.new(id: "amen", source: source, text: [ Inline::Italic.new(text: "[Amen]") ]),
      PsalmVerse.new(id: "p", source: source, psalm: 1, verse: 2, kjv_verse: 3,
        first_half: [ Inline::SmallCaps.new(text: "[Lord]") ], second_half: [ text("[b]") ], mark: "asterisk"),
      CanticleReference.new(id: "cr", source: source, canticle: "bcp1662-te-deum", printed: [ text("[Te Deum]") ]),
      Collect.new(id: "c", source: source, title: nil,
        text: [ text("[Collect] "), Inline::Insertion.new(kind: "name", printed: "N."), Inline::LineBreak.new ]),
      Collect.new(id: "c2", source: source, title: [ text("[Title]") ], text: [ text("[Collect]") ]),
      GloriaPatri.new(id: "g", source: source, printed: [ text("[Glory]") ], full_text: "gloria-full"),
      Alternatives.new(id: "a", source: source, options: [
        Alternative.new(label: nil, blocks: [ paragraph("a1") ]),
        Alternative.new(label: [ Inline::Italic.new(text: "[Or this]") ], blocks: [ paragraph("a2") ])
      ]),
      SeasonalInsertion.new(id: "s", source: source, key: "advent-sentences", printed: [ text("[Seasonal]") ])
    ]
    assert_equal LiturgicalBlock::KINDS.keys.sort, blocks.map(&:kind).uniq.sort

    blocks.each do |block|
      assert_equal block, LiturgicalBlock.from_h(block.to_h)
      assert_equal block, LiturgicalBlock.from_h(JSON.parse(JSON.generate(block.to_h)))
      assert_empty block.problems, block.id
    end
  end

  test "the stored form keeps stable keys" do
    assert_equal({ "id" => "x", "source" => { "book" => "bcp1662", "printing" => "example", "page" => "12" },
      "kind" => "paragraph", "text" => [ { "text" => "[Words]" }, { "page_break" => "13" } ] },
      paragraph("x", text("[Words]"), Inline::PageBreak.new(page: "13")).to_h)
  end

  test "plain text keeps insertions as printed and drops page breaks" do
    block = paragraph("p", text("[Before] "), Inline::Insertion.new(kind: "sovereign", printed: "[Sovereign]"),
      Inline::PageBreak.new(page: "13"), text(" [after]"))
    assert_equal "[Before] [Sovereign] [after]", block.plain_text
    assert_equal %w[12 13], block.pages
  end

  test "a psalm verse shows its own half-verse mark" do
    assert_equal "[a] : [b]", psalm_verse(mark: "colon").plain_text
    assert_equal "[a] * [b]", psalm_verse(mark: "asterisk").plain_text
  end

  test "role lines keep their printed roles" do
    lines = RoleLines.new(id: "l", source: source, lines: [
      RoleLine.new(role: "[Minister]", text: [ text("[a]") ]), RoleLine.new(role: "", text: [ text("[b]") ])
    ])
    assert_equal "[Minister] [a]\n[b]", lines.plain_text
  end

  test "empty, unpaged, and unprinted blocks are problems" do
    assert_equal [ "empty: no words" ], paragraph("empty", Inline::PageBreak.new(page: "13")).problems
    unpaged = Paragraph.new(id: "x", source: source(page: " "), text: [ text("[Words]") ])
    assert_equal [ "x: no printed page" ], unpaged.problems
    unprinted = Paragraph.new(id: "y", source: source(printing: ""), text: [ text("[Words]") ])
    assert_equal [ "y: no printing" ], unprinted.problems
  end

  test "a block must come from a book the site knows" do
    assert_equal [ "x: unknown prayer book bcp1549" ], paragraph("x", book: "bcp1549").problems
  end

  test "psalm numbers, marks, and the KJV numbering are checked" do
    assert_equal [ "p: psalm or verse out of range" ], psalm_verse(psalm: 151).problems
    assert_equal [ "p: psalm or verse out of range" ], psalm_verse(verse: 0).problems
    assert_equal [ "p: unknown half-verse mark dash" ], psalm_verse(mark: "dash").problems
    assert_equal [ "p: KJV verse given but the same as the book's" ], psalm_verse(verse: 2, kjv_verse: 2).problems
    assert_empty psalm_verse(verse: 2, kjv_verse: 3).problems
  end

  test "headings start at level 1 and insertions have a known kind" do
    heading = Heading.new(id: "h", source: source, level: 0, text: [ text("[Office]") ])
    assert_equal [ "h: heading level below 1" ], heading.problems
    odd = paragraph("i", Inline::Insertion.new(kind: "deacon", printed: "[N.]"))
    assert_equal [ "i: unknown insertion kind deacon" ], odd.problems
  end

  # Each book on its own terms: an alternative may never come from another book (D8).
  test "alternatives may not borrow from another book" do
    mixed = Alternatives.new(id: "alt", source: source, options: [
      Alternative.new(label: nil, blocks: [ paragraph("own") ]),
      Alternative.new(label: nil, blocks: [ paragraph("other", book: "bcp1979us") ])
    ])
    assert_equal [ "alt: alternative other is from another book" ], mixed.problems
  end

  test "alternatives need two options and pass on their blocks' problems" do
    single = Alternatives.new(id: "alt", source: source, options: [ Alternative.new(label: nil, blocks: [ paragraph("one") ]) ])
    assert_equal [ "alt: alternatives need at least two options" ], single.problems

    nested = Alternatives.new(id: "alt", source: source, options: [
      Alternative.new(label: nil, blocks: [ paragraph("one") ]),
      Alternative.new(label: nil, blocks: [ paragraph("empty", Inline::PageBreak.new(page: "13")) ])
    ])
    assert_equal [ "empty: no words" ], nested.problems
  end

  test "stored values never change" do
    assert_equal %w[colon asterisk], LiturgicalBlock::HALF_VERSE_MARKS.keys
    assert_equal %w[name sovereign bishop other], LiturgicalBlock::INSERTION_KINDS
    assert_equal %w[heading paragraph rubric role_lines versicles amen gloria_patri psalm_verse
      canticle_reference collect alternatives seasonal_insertion], LiturgicalBlock::KINDS.keys
  end

  test "unknown kinds and inlines are refused when read" do
    assert_raises(ArgumentError) { LiturgicalBlock.from_h("id" => "x", "kind" => "hymn", "source" => source.to_h) }
    assert_raises(ArgumentError) { Inline.from_h([ { "bold" => "[x]" } ]) }
  end
end
