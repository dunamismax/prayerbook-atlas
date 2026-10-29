require "test_helper"

# The content format's parser (docs/content-format.md, BUILD.md P3.2).
class Content::TextFileTest < ActiveSupport::TestCase
  HEAD = "id: bcp1662.t\nkind: office\ntitle: [T]\nbook: bcp1662\nprinting: p\nsource: p\npage: 7\n"

  test "inline marks become runs, and plain words join" do
    inlines, problems = Content::Inlines.parse("[a] {i|b} {sc|LORD}{br}{name|N.} {{x}} {page|8}")
    assert_empty problems
    assert_equal [ "Text", "Italic", "Text", "SmallCaps", "LineBreak", "Insertion", "Text", "PageBreak" ],
      inlines.map { _1.class.name.demodulize }
    assert_equal " {x} ", inlines[6].text
  end

  test "unknown or broken marks are problems" do
    assert_match(/unknown mark \{bold\}/, Content::Inlines.parse("{bold|x}").last.join)
    assert_match(/unmatched brace/, Content::Inlines.parse("a } b").last.join)
    assert_match(/empty mark \{i\}/, Content::Inlines.parse("{i|}").last.join)
  end

  test "paragraphs join their lines and keep {br}" do
    file = parse("@paragraph\n[one]\n[two] {br}\n[three]\n")
    assert_equal "[one] [two]\n[three]", file.blocks.first.plain_text
  end

  test "role lines keep their roles as printed" do
    file = parse("@versicles\n℣ | [a]\n℟ | [b]\n[c]\nMinister | [d]\n")
    assert_equal [ "℣", "℟", "", "Minister" ], file.blocks.first.lines.map(&:role)
    assert_equal "[c]", file.blocks.first.lines[2].plain_text
  end

  test "pages follow @page and page breaks" do
    file = parse("@paragraph\n[a] {page|8}\n@paragraph\n[b]\n@page 9\n@paragraph\n[c]\n")
    assert_equal %w[7 8 9], file.blocks.map { _1.source.page }
  end

  test "psalm verses split at the book's mark and keep the KJV's number" do
    file = parse("@psalm 23\n1 [a] : [b]\n5 [kjv 6] [c] : [d]\n", "half_verse_mark: colon\n")
    assert_equal [ [ 23, 1, nil ], [ 23, 5, 6 ] ], file.blocks.map { [ _1.psalm, _1.verse, _1.kjv_verse ] }
    assert_match(/exactly one ":"/, parse("@psalm 23\n1 [a] [b]\n", "half_verse_mark: colon\n").problems.join)
    assert_match(/needs half_verse_mark/, parse("@psalm 23\n1 [a] : [b]\n").problems.join)
  end

  test "alternatives hold options with their labels" do
    file = parse("@alternatives id=c\n@option label=\"[Or]\"\n@paragraph\n[a]\n@option\n@paragraph\n[b]\n@end\n")
    alternatives = file.blocks.first
    assert_equal %w[bcp1662.t.c.1.1 bcp1662.t.c.2.1], alternatives.options.flat_map(&:blocks).map(&:id)
    assert_equal "[Or]", LiturgicalBlock::Inline.plain_text(alternatives.options.first.label)
    assert_match(/without @end/, parse("@alternatives\n@option\n@paragraph\n[a]\n").problems.join)
  end

  test "front matter is checked" do
    assert_match(/unknown front matter key colour/, Content::TextFile.new("#{HEAD}colour: red\n---\n", path: "x").problems.join)
    assert_match(/missing page/, Content::TextFile.new(HEAD.sub("page: 7\n", "") + "---\n", path: "x").problems.join)
    assert_match(/no front matter/, Content::TextFile.new("@paragraph\n[a]\n", path: "x").problems.join)
    assert_match(/same printing and source/, Content::TextFile.new(HEAD.sub("source: p", "source: q") + "---\n", path: "x").problems.join)
  end

  test "unknown directives, stray text, and bad attributes are problems" do
    assert_match(/unknown directive @verse/, parse("@verse\n[a]\n").problems.join)
    assert_match(/text outside a block/, parse("[a]\n").problems.join)
    assert_match(/does not take colour/, parse("@paragraph colour=red\n[a]\n").problems.join)
  end

  test "Scripture is one verse per line" do
    file = Content::TextFile.new("id: kjva.x\nkind: scripture\ntitle: [X]\nsource: s\ntranslation: kjva\nbible_book: GEN\n---\n1:1 [a]\n1:2 [b]\n", path: "x")
    assert_empty file.problems
    assert_equal [ [ 1, 1 ], [ 1, 2 ] ], file.verses.map { [ _1.chapter, _1.verse ] }
  end

  test "original work is paragraphs and headings" do
    file = Content::TextFile.new("id: note.x\nkind: note\ntitle: [X]\nsource: original\nreview: pending\n---\n# [H]\n\n[a\nb]\n", path: "x")
    assert_equal [ [ "heading", "[H]" ], [ "paragraph", "[a b]" ] ], file.blocks.map { [ _1.kind, _1.plain_text ] }
  end

  private
    def parse(body, extra = "")
      Content::TextFile.new("#{HEAD}#{extra}---\n#{body}", path: "x")
    end
end
