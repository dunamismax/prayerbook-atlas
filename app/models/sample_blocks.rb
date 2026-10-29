# Every kind of LiturgicalBlock in bracketed placeholders, across a printed
# page break, for the development sample (/dev/liturgy) and the renderer's
# tests. None of it is a prayer book's text (AGENTS.md §6); "example" is not
# a registered printing, so none of it could be compiled into the content.
module SampleBlocks
  include LiturgicalBlock

  def self.all
    page = ->(number) { SourceCitation.new(book: "bcp1662", printing: "example", page: number) }
    text = ->(words) { Inline::Text.new(text: words) }

    [
      Heading.new(id: "sample-title", source: page.("12"), level: 1, text: [ text.("[The title of an office]") ]),
      Rubric.new(id: "sample-rubric", source: page.("12"), text: [ text.("[A rubric, with "), Inline::Italic.new(text: "[italic]"), text.(" words as printed.]") ]),
      Paragraph.new(id: "sample-paragraph", source: page.("12"), text: [
        text.("[A paragraph of the book's text, running long enough to wrap across several lines in the reading column, so that a page break in the middle of it shows where the next printed page begins;]"),
        Inline::PageBreak.new(page: "13"),
        text.(" [and then it goes on, on the next page.]")
      ]),
      RoleLines.new(id: "sample-roles", source: page.("13"), lines: [
        RoleLine.new(role: "[Minister]", text: [ text.("[A line said by the minister.]") ]),
        RoleLine.new(role: "[People]", text: [ text.("[A line said by the people.]") ]),
        RoleLine.new(role: "", text: [ text.("[A line printed with no role.]") ])
      ]),
      Versicles.new(id: "sample-versicles", source: page.("13"), lines: [
        RoleLine.new(role: "℣", text: [ text.("[A versicle.]") ]),
        RoleLine.new(role: "℟", text: [ text.("[Its response.]") ])
      ]),
      Collect.new(id: "sample-collect", source: page.("14"), title: [ text.("[The title of a collect]") ], text: [
        text.("[A collect, with a place for a name, "), Inline::Insertion.new(kind: "name", printed: "N."),
        text.(", and for the sovereign, "), Inline::Insertion.new(kind: "sovereign", printed: "[the sovereign as printed]"), text.(".]")
      ]),
      Amen.new(id: "sample-amen", source: page.("14"), text: [ text.("[Amen as printed.]") ]),
      PsalmVerse.new(id: "sample-verse-1", source: page.("14"), psalm: 1, verse: 1, kjv_verse: nil,
        first_half: [ text.("[The first half of a verse, with the "), Inline::SmallCaps.new(text: "Lord"), text.(" in small capitals]") ],
        second_half: [ text.("[the second half.]") ], mark: "colon"),
      PsalmVerse.new(id: "sample-verse-2", source: page.("14"), psalm: 1, verse: 2, kjv_verse: 3,
        first_half: [ text.("[A verse numbered differently in the KJV]") ], second_half: [ text.("[with an asterisk.]") ], mark: "asterisk"),
      GloriaPatri.new(id: "sample-gloria", source: page.("14"), printed: [ text.("[The Gloria Patri as printed here.]") ], full_text: nil),
      CanticleReference.new(id: "sample-canticle", source: page.("15"), canticle: "sample-canticle-text", printed: [ text.("[A canticle appointed here.]") ]),
      Alternatives.new(id: "sample-alternatives", source: page.("15"), options: [
        Alternative.new(label: nil, blocks: [ Paragraph.new(id: "sample-choice-1", source: page.("15"), text: [ text.("[The first choice.]") ]) ]),
        Alternative.new(label: [ text.("[Or this.]") ], blocks: [ Paragraph.new(id: "sample-choice-2", source: page.("15"), text: [ text.("[The second choice.]") ]) ])
      ]),
      SeasonalInsertion.new(id: "sample-seasonal", source: page.("15"), key: "sample-season", printed: [ text.("[Here the day's proper is said.]") ])
    ]
  end
end
