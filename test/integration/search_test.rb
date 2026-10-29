require "test_helper"

# Search (BUILD.md P3.9) over the fixture content database.
class SearchTest < ActionDispatch::IntegrationTest
  PHONE = { "User-Agent" => UserAgents::IPHONE }.freeze
  DESKTOP = { "User-Agent" => UserAgents::DESKTOP_CHROME }.freeze

  test "results are ranked, marked, and cited, in both modes" do
    [ PHONE, DESKTOP ].each do |headers|
      get search_path(q: "grace"), headers: headers
      assert_response :success
      assert_select "h2", "4 results for “grace”"
      assert_select ".search-results mark", "grace"
      assert_match(/1662.*office · page 4/, css_select(".search-results .source").map(&:text).join(" ").squish)
    end
  end

  test "filters narrow by book and kind" do
    get search_path(q: "grace", book: "bcp1979us")
    assert_select ".search-results li", 1
    assert_select ".search-results h3", "[An Example Prayer]"

    get search_path(q: "grace", kind: "scripture")
    assert_select ".search-results li", 1
    assert_select ".search-results h3", "[Example 1] 1:1"

    get search_path(q: "kneeling", kind: "rubric")
    assert_select ".search-results li", 1
  end

  test "the full site puts the filters in the contents column; the phone folds them" do
    get search_path(q: "grace"), headers: DESKTOP
    assert_select "nav.contents form.search-filters select#search-book"
    get search_path(q: "grace"), headers: PHONE
    assert_select "details.search-filters-fold form.search-filters"
  end

  test "the full site's masthead has a search field; the phone bar links to search" do
    get root_path, headers: DESKTOP
    assert_select ".masthead-tools form[role=search][action='/search'] input[type=search][name=q]"
    get root_path, headers: PHONE
    assert_select ".phone-bar-tools a[href='/search']"
  end

  test "words that look like search syntax are only words" do
    get search_path(q: %q{grace" OR (NEAR* -AND})
    assert_response :success
    get search_path(q: "* ( )")
    assert_response :success
    assert_select ".search-results", 0
  end

  test "nothing found says so plainly" do
    get search_path(q: "zymurgy")
    assert_select ".state--empty", /nothing found for “zymurgy”/
  end

  test "an unknown filter is ignored" do
    get search_path(q: "grace", book: "bcp1549", kind: "hymn")
    assert_select "h2", "4 results for “grace”"
  end
end
