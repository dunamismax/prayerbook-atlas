require "test_helper"

# The sources page and the acknowledgements come from the content database
# (BUILD.md P3.8), here the fixture database test_helper.rb compiles.

class SourcesPageTest < ActionDispatch::IntegrationTest
  test "the sources page lists the register by status, in both modes" do
    [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
      get sources_path, headers: { "User-Agent" => user_agent }
      assert_response :success
      assert_select "h2", "In use"
      assert_select "h2", "Being researched"
      assert_select "li#example-1662", /\[An example printing of 1662\].*Cleared for: US/m
      assert_select "li#example-pending", /In the United States: test fixture/
    end
  end

  test "Settings acknowledges the sources marked for it, from the content database" do
    get settings_path
    assert_select ".acknowledgements li", "[Example acknowledgement of the 1662 printing.]"
    assert_select "a[href='/sources']"
  end
end
