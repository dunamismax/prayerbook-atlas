require "test_helper"

class SectionsTest < ActionDispatch::IntegrationTest
  PAGES = %w[/ /pray /bible /kalendar /atlas /about].freeze

  test "every page renders in both modes" do
    PAGES.each do |path|
      [ SiteModeTest::IPHONE, SiteModeTest::DESKTOP_CHROME ].each do |user_agent|
        get path, headers: { "User-Agent" => user_agent }
        assert_response :success, "#{path} failed for #{user_agent}"
        assert_select "main#main h1", 1
        assert_select "a.skip-link[href='#main']"
        assert_select "html[lang=en]"
      end
    end
  end

  test "the current section is marked for assistive technology" do
    get kalendar_path, headers: { "User-Agent" => SiteModeTest::DESKTOP_CHROME }
    assert_select ".section-nav a[aria-current=page]", text: "Kalendar"
  end

  test "pages say plainly that nothing is ready for prayer" do
    get root_path
    assert_select ".notice", /Nothing here is ready for prayer yet/
  end

  test "pages load nothing from another site" do
    PAGES.each do |path|
      get path
      assert_select "link[href^='http'], script[src^='http'], img[src^='http']", 0, "#{path} loads a remote asset"
    end
  end

  test "the content security policy allows only this site" do
    get root_path
    policy = response.headers["Content-Security-Policy"]
    assert_match "default-src 'self'", policy
    assert_match "frame-ancestors 'none'", policy
    assert_no_match(/https:|\*/, policy)
  end
end
