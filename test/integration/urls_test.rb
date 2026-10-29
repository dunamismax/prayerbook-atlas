require "test_helper"

class UrlsTest < ActionDispatch::IntegrationTest
  # docs/urls.md lists these, but their phases route them later.
  ROUTED_LATER = %w[/kalendar/bcp1662.ics /support /privacy /terms /sources /accessibility].freeze

  test "every URL in docs/urls.md answers, in both modes" do
    urls = Rails.root.join("docs/urls.md").read.scan(/^\| (`[^|]+`) \|/).flatten
      .flat_map { |cell| cell.scan(/`([^`]+)`/).flatten }
    assert_operator urls.size, :>, 30

    (urls - ROUTED_LATER).each do |url|
      [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
        get url, headers: { "User-Agent" => user_agent }
        assert_response :success, "#{url} for #{user_agent}"
      end
    end
  end

  test "a planned page says plainly that it is not built and keeps its section" do
    get office_path(book: "bcp1662", office: "evening-prayer", date: "2027-03-28")
    assert_select "h1", "Evening Prayer · 1662"
    assert_select ".notice", /planned and not yet built/
    assert_select ".plate-card p", /28 March 2027/
    assert_select ".section-nav a[aria-current=page]", "Pray"
  end

  test "named routes build the documented URLs" do
    assert_equal "/pray/bcp1979us/compline", office_path(book: "bcp1979us", office: "compline")
    assert_equal "/bible/psalter/bcp1662/day/4", psalter_day_path(book: "bcp1662", day: 4)
    assert_equal "/kalendar/2027-03-28", kalendar_day_path(date: "2027-03-28")
    assert_equal "/atlas/compare/te-deum/bcp1662/bcp1928us/bcp1979us",
      compare_path(key: "te-deum", first: "bcp1662", second: "bcp1928us", third: "bcp1979us")
  end

  test "addresses that cannot exist are not found" do
    %w[
      /pray/bcp1549
      /pray/bcp1662/vespers
      /pray/bcp1662/morning-prayer/2027-02-30
      /kalendar/2027-13-01
      /kalendar/2027/13
      /bible/john/3?translation=niv
      /atlas/compare/te-deum/bcp1662
      /pray/bcp1662/morning-prayer.json
    ].each do |url|
      get url
      assert_response :not_found, url
    end
  end
end
