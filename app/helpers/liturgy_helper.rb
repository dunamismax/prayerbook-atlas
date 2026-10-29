# Sets LiturgicalBlocks out as semantic HTML (BUILD.md P2.9), the same in
# both modes; the stylesheets place what differs. Rubrics are announced as
# instructions and role labels are read before their lines; printed page
# numbers mark where each page begins (in a gutter beside the text on the
# full site, inline on the phone); insertion points are visible as what the
# book prints there. What is announced but not printed (the "Instruction:"
# prefix, page numbers) is left out of a copy, so selecting and copying a
# prayer gives its words.
module LiturgyHelper
  # Headings in the blocks start at `heading_level` (level 1 becomes an h2
  # under the page's own h1).
  def liturgy(blocks, heading_level: 2)
    @liturgy_page = nil
    @liturgy_heading_level = heading_level
    tag.div(safe_join(blocks.map { liturgical_block(_1) }), class: "liturgy with-page-marks")
  end

  private
    def liturgical_block(block)
      mark = liturgy_page_mark(block.source.page)
      data = { block: block.id }

      case block
      when LiturgicalBlock::Heading
        level = (@liturgy_heading_level + block.level - 1).clamp(1, 6)
        # The page number goes before the heading, not in it, so it is not
        # part of the heading's name.
        safe_join([ mark, content_tag(:"h#{level}", inlines(block.text), class: "liturgy-heading", data: data) ].compact)
      when LiturgicalBlock::Paragraph
        tag.p(safe_join([ mark, inlines(block.text) ]), data: data)
      when LiturgicalBlock::Rubric
        tag.p(safe_join([ mark, announced("Instruction: "), inlines(block.text) ]), class: "rubric", data: data)
      when LiturgicalBlock::RoleLines, LiturgicalBlock::Versicles
        role_lines(block, mark, data)
      when LiturgicalBlock::Amen
        tag.p(safe_join([ mark, tag.span(inlines(block.text), class: "amen") ]), class: "amen-line", data: data)
      when LiturgicalBlock::GloriaPatri
        tag.p(safe_join([ mark, inlines(block.printed) ]), class: "gloria-patri", data: data)
      when LiturgicalBlock::PsalmVerse
        psalm_verse(block, mark, data)
      when LiturgicalBlock::CanticleReference
        tag.p(safe_join([ mark, inlines(block.printed) ]), class: "canticle-reference", data: data.merge(canticle: block.canticle))
      when LiturgicalBlock::Collect
        collect(block, mark, data)
      when LiturgicalBlock::Alternatives
        alternatives(block, mark, data)
      when LiturgicalBlock::SeasonalInsertion
        tag.p(safe_join([ mark, inlines(block.printed) ]), class: "seasonal-insertion", data: data.merge(insertion: block.key))
      end
    end

    def role_lines(block, mark, data)
      kind = block.is_a?(LiturgicalBlock::Versicles) ? "versicles" : "role-lines"
      lines = block.lines.map.with_index do |line, index|
        tag.p(class: "versicle") do
          safe_join([ (mark if index.zero?), (role_label(line.role) if line.role.present?), (" " if line.role.present?), inlines(line.text) ])
        end
      end
      tag.div(safe_join(lines), class: kind, data: data)
    end

    def psalm_verse(block, mark, data)
      numbers = [ tag.span(block.verse.to_s, class: "verse-number") ]
      numbers << tag.span("KJV #{block.kjv_verse}", class: "verse-number-kjv no-copy") if block.kjv_verse
      tag.p(class: "psalm-verse", data: data.merge(psalm: block.psalm, verse: block.verse)) do
        safe_join([ mark, *numbers, " ", inlines(block.first_half), " ",
          tag.span(LiturgicalBlock::HALF_VERSE_MARKS.fetch(block.mark), class: "half-verse-mark", aria: { hidden: true }),
          " ", inlines(block.second_half) ])
      end
    end

    def collect(block, mark, data)
      tag.div(class: "collect", data: data) do
        safe_join([
          (tag.p(safe_join([ mark, inlines(block.title) ]), class: "collect-title") if block.title),
          tag.p(safe_join([ (mark unless block.title), inlines(block.text) ]))
        ].compact)
      end
    end

    def alternatives(block, mark, data)
      options = block.options.map do |option|
        tag.div(class: "alternative") do
          safe_join([ (tag.p(inlines(option.label), class: "alternative-label") if option.label),
            *option.blocks.map { liturgical_block(_1) } ])
        end
      end
      tag.div(safe_join([ mark, *options ]), class: "alternatives", role: "group", aria: { label: "Choices the book offers" }, data: data)
    end

    def inlines(list)
      safe_join(Array(list).map do |inline|
        case inline
        when LiturgicalBlock::Inline::Text then inline.text
        when LiturgicalBlock::Inline::Italic then tag.i(inline.text)
        when LiturgicalBlock::Inline::SmallCaps then tag.span(inline.text, class: "small-caps")
        when LiturgicalBlock::Inline::Insertion then tag.span(inline.printed, class: "name-chip insertion", data: { insertion: inline.kind })
        when LiturgicalBlock::Inline::LineBreak then tag.br
        when LiturgicalBlock::Inline::PageBreak then liturgy_page_mark(inline.page)
        end
      end)
    end

    # A page number where a new printed page begins, and nothing otherwise.
    def liturgy_page_mark(page)
      return if page == @liturgy_page

      @liturgy_page = page
      page_mark(page)
    end

    # Words for screen readers that are not part of the text.
    def announced(text)
      tag.span(text, class: "visually-hidden no-copy")
    end
end
