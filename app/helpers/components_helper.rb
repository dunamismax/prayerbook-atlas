# The shared pieces of Engraved Plate (docs/design.md §12) as helpers. Each
# draws the same markup in both modes; components.css places it for the full
# site or the phone. None supplies words of a prayer book: the caller passes
# the book's own text, labels, and page.
module ComponentsHelper
  # A small-capital label above a heading.
  def eyebrow(text)
    tag.span(text, class: "eyebrow")
  end

  # The double rule under a page's title.
  def title_rule
    tag.hr(class: "title-rule")
  end

  # A card (a double rule in line) or, with `plate: true`, an atlas plate (a
  # double rule in ink), labelled by its own heading.
  def plate_card(title, label: nil, level: 2, plate: false, &block)
    id = component_id("plate")
    tag.section(class: plate ? "atlas-plate" : "plate-card", aria: { labelledby: id }) do
      safe_join([ (eyebrow(label) if label), content_tag(:"h#{level}", title, id: id), capture(&block) ].compact)
    end
  end

  # A paragraph that opens with an initial in rubric, two lines deep.
  def initial_paragraph(text = nil, &block)
    tag.p(text || capture(&block), class: "has-initial")
  end

  # A rubric: an instruction, not words to be said, and announced as one.
  def rubric(text = nil, &block)
    tag.p(class: "rubric") do
      safe_join([ tag.span(t("components.instruction"), class: "visually-hidden no-copy"), text || capture(&block) ])
    end
  end

  # A role label with the words the book prints (Officiant, Priest, People,
  # Answer), or the versicle and response marks, which keep the text's size.
  def role_label(name)
    tag.span(name, class: [ "role-label", ("role-label--mark" if name.in?(%w[℣ ℟])) ])
  end

  # Versicles and responses, each line with the label the book gives it:
  # versicles(["℣", "..."], ["℟", "..."]) or with Priest and Answer.
  def versicles(*lines)
    tag.div(class: "versicles") do
      safe_join(lines.map { |label, text| tag.p(safe_join([ role_label(label), " ", text ]), class: "versicle") })
    end
  end

  # The Amen as the book prints it, kept on the line it ends.
  def amen(text)
    tag.span(text, class: "amen")
  end

  # A line the book directs to be said again, set in from the margin.
  def repetition(text = nil, &block)
    tag.p(class: "repetition") do
      safe_join([ tag.span(t("components.repeated"), class: "visually-hidden no-copy"), text || capture(&block) ])
    end
  end

  # A name in the prayers: a person's own name from their list, or the book's
  # placeholder (such as "N.") where none is given.
  def name_chip(name)
    tag.span(name, class: "name-chip")
  end

  # A season's ribbon: always the band and its name together, never colour alone.
  def ribbon_marker(key, name: DesignTokens.ribbons.fetch(key.to_s))
    tag.span(class: "ribbon-marker ribbon--#{key}") do
      safe_join([ tag.span(class: "ribbon-band", aria: { hidden: true }), name ])
    end
  end

  # A printed page number: beside the text on the full site when the text is
  # wrapped in .with-page-marks, inline on the phone (components.css).
  def page_mark(page)
    tag.span(class: "page-mark") do
      safe_join([ tag.span(t("components.page"), class: "visually-hidden"), tag.span(t("components.page_abbreviation"), aria: { hidden: true }), page.to_s ])
    end
  end

  # A source mark that opens its note through the HTML popover attribute, so
  # it needs no script. A browser without popovers shows the note inline after
  # the mark instead.
  def source_note(label: t("components.source"), &block)
    id = component_id("source")
    safe_join([
      tag.button(label, type: "button", class: "source-mark", popovertarget: id),
      tag.span(id: id, popover: "auto", class: "source-note") do
        safe_join([
          capture(&block),
          tag.button(t("components.close"), type: "button", class: "source-note-close", popovertarget: id, popovertargetaction: "hide")
        ])
      end
    ])
  end

  # A note set in the margin on the full site and under "Notes and sources" on
  # the phone (the layouts place content_for :margin).
  def margin_note(title, &block)
    content_for :margin, tag.section(safe_join([ tag.h2(title), capture(&block) ]), class: "margin-note")
    nil
  end

  private
    def component_id(prefix)
      @component_sequence = (@component_sequence || 0) + 1
      "#{prefix}-#{@component_sequence}"
    end
end
