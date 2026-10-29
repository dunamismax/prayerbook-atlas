require "test_helper"

class LiturgyHelperTest < ActionView::TestCase
  include ComponentsHelper

  setup { render html: liturgy(SampleBlocks.all) }

  test "every block is set, each with its id" do
    SampleBlocks.all.each { |block| assert_select "[data-block='#{block.id}']" }
    assert_select ".liturgy.with-page-marks"
  end

  test "headings sit under the page's own h1" do
    assert_select "h2.liturgy-heading", "[The title of an office]"
  end

  test "rubrics are announced as instructions, left out of a copy" do
    assert_select "p.rubric span.visually-hidden.no-copy", "Instruction:"
    assert_select "p.rubric i", "[italic]"
  end

  test "a page number appears only where a printed page begins" do
    assert_select ".page-mark", 4
    assert_select ".liturgy > .page-mark:first-child + h2[data-block=sample-title]"
    assert_select "[data-block=sample-paragraph] .page-mark", "page p. 13"
    assert_select "[data-block=sample-roles] .page-mark", 0
    assert_select "[data-block=sample-collect] .collect-title .page-mark", "page p. 14"
  end

  test "role labels are read before their lines, as printed" do
    assert_select "[data-block=sample-roles] .versicle", 3
    assert_select "[data-block=sample-roles] .role-label", 2
    assert_select "[data-block=sample-versicles] .role-label--mark", 2
  end

  test "insertion points show what the book prints" do
    assert_select ".insertion[data-insertion=name]", "N."
    assert_select ".insertion[data-insertion=sovereign]", "[the sovereign as printed]"
    assert_select ".seasonal-insertion[data-insertion=sample-season]"
  end

  test "psalm verses keep the book's number, the KJV's where it differs, and the printed mark" do
    assert_select "[data-block=sample-verse-1] .verse-number", "1"
    assert_select "[data-block=sample-verse-1] .verse-number-kjv", 0
    assert_select "[data-block=sample-verse-1] .half-verse-mark[aria-hidden=true]", ":"
    assert_select "[data-block=sample-verse-2] .verse-number-kjv.no-copy", "KJV 3"
    assert_select "[data-block=sample-verse-2] .half-verse-mark", "*"
    assert_select ".small-caps", "Lord"
  end

  test "alternatives are a labelled group with the book's own labels" do
    assert_select ".alternatives[role=group][aria-label='Choices the book offers'] .alternative", 2
    assert_select ".alternative-label", "[Or this.]"
  end

  test "the sample is placeholders only and has no problems" do
    SampleBlocks.all.each do |block|
      assert_empty block.problems
      assert_match(/\A[\[\]A-Za-z.,;:*'\s℣℟N]*\z/, block.plain_text.gsub(/\[[^\]]*\]/, ""), block.id)
    end
  end
end
