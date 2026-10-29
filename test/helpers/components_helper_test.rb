require "test_helper"

class ComponentsHelperTest < ActionView::TestCase
  test "a card is labelled by its own heading" do
    render html: plate_card("The books", label: "atlas") { tag.p("Body") }
    assert_select "section.plate-card[aria-labelledby=plate-1]" do
      assert_select "span.eyebrow", "atlas"
      assert_select "h2#plate-1", "The books"
    end
  end

  test "an atlas plate uses its own frame" do
    render html: plate_card("Compare", plate: true) { "" }
    assert_select "section.atlas-plate"
  end

  test "rubrics and repetitions are announced for what they are" do
    render html: rubric("Then shall be said") + repetition("Again")
    assert_select "p.rubric span.visually-hidden", "Instruction:"
    assert_select "p.repetition span.visually-hidden", "Repeated:"
  end

  test "versicles keep the labels the book gives them" do
    render html: versicles([ "Priest.", "V" ], [ "Answer.", "R" ])
    assert_select ".versicles p.versicle", 2
    assert_select "p.versicle:first-child span.role-label", "Priest."
    assert_select "span.role-label--mark", 0
  end

  test "the versicle and response marks keep the text's size" do
    render html: versicles([ "℣", "V" ], [ "℟", "R" ])
    assert_select "span.role-label.role-label--mark", 2
  end

  test "a ribbon always carries its name" do
    render html: ribbon_marker(:violet)
    assert_select "span.ribbon-marker.ribbon--violet", "Violet"
    assert_select "span.ribbon-band[aria-hidden=true]"
  end

  test "every ribbon in the tokens has a style" do
    css = Rails.root.join("app/assets/stylesheets/components.css").read
    DesignTokens.ribbons.each_key { |key| assert_includes css, ".ribbon--#{key} {" }
  end

  test "a page mark reads as a page to screen readers" do
    render html: page_mark(42)
    assert_select "span.page-mark", "page p. 42"
    assert_select "span.page-mark span[aria-hidden=true]", "p."
  end

  test "a source note opens as a popover without script" do
    render html: source_note { "The book, p. 1" }
    assert_select "button.source-mark[popovertarget=source-1][type=button]", "source"
    assert_select "span#source-1[popover=auto].source-note", /The book, p. 1/
    assert_select "button[popovertarget=source-1][popovertargetaction=hide]", "Close"
  end

  test "a margin note goes to the margin" do
    margin_note("Sources") { tag.p("Note") }
    assert_match "<h2>Sources</h2>", content_for(:margin)
  end
end
