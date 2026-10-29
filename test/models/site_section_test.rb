require "test_helper"

class SiteSectionTest < ActiveSupport::TestCase
  test "the five sections, in order" do
    assert_equal %w[today pray bible kalendar atlas], SiteSection.all.map(&:key)
  end

  test "finding a section that does not exist is an error" do
    assert_raises(KeyError) { SiteSection.find("search") }
  end
end
