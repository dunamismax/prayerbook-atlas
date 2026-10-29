require "test_helper"

class SiteModeTest < ActionDispatch::IntegrationTest
  IPHONE = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 " \
    "(KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1"
  ANDROID_PHONE = "Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 " \
    "(KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36"
  ANDROID_TABLET = "Mozilla/5.0 (Linux; Android 15; SM-X910) AppleWebKit/537.36 " \
    "(KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"
  IPAD = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 " \
    "(KHTML, like Gecko) Version/18.6 Safari/605.1.15"
  DESKTOP_CHROME = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 " \
    "(KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"

  test "phones get the phone site" do
    [ IPHONE, ANDROID_PHONE ].each do |user_agent|
      get root_path, headers: { "User-Agent" => user_agent }
      assert_site_mode "phone"
    end
  end

  test "desktops and tablets get the full site" do
    [ DESKTOP_CHROME, IPAD, ANDROID_TABLET ].each do |user_agent|
      get root_path, headers: { "User-Agent" => user_agent }
      assert_site_mode "full"
    end
  end

  test "the mobile client hint decides over the user agent" do
    get root_path, headers: { "User-Agent" => DESKTOP_CHROME, "Sec-CH-UA-Mobile" => "?1" }
    assert_site_mode "phone"

    get root_path, headers: { "User-Agent" => ANDROID_PHONE, "Sec-CH-UA-Mobile" => "?0" }
    assert_site_mode "full"
  end

  test "the phone site has the tab bar and the full site has the masthead" do
    get root_path, headers: { "User-Agent" => IPHONE }
    assert_select "nav.tab-bar a", 5
    assert_select "header.masthead", 0

    get root_path, headers: { "User-Agent" => DESKTOP_CHROME }
    assert_select "header.masthead nav.section-nav a", 5
    assert_select "nav.tab-bar", 0
    assert_select "aside.margin"
  end

  test "a person's choice of mode is kept and can be undone" do
    patch site_mode_path, params: { mode: "full" }, headers: { "User-Agent" => IPHONE }
    assert_response :see_other

    get pray_path, headers: { "User-Agent" => IPHONE }
    assert_site_mode "full"
    assert_select "form.mode-switch input[name=mode][value=automatic]"

    patch site_mode_path, params: { mode: "automatic" }, headers: { "User-Agent" => IPHONE }
    get pray_path, headers: { "User-Agent" => IPHONE }
    assert_site_mode "phone"
  end

  test "an unknown mode is treated as automatic" do
    patch site_mode_path, params: { mode: "watch" }, headers: { "User-Agent" => IPHONE }
    get root_path, headers: { "User-Agent" => IPHONE }
    assert_site_mode "phone"
  end

  test "pages vary on what chooses the mode" do
    get root_path, headers: { "User-Agent" => DESKTOP_CHROME }
    vary = response.headers["Vary"].split(/,\s*/)
    assert_includes vary, "User-Agent"
    assert_includes vary, "Sec-CH-UA-Mobile"
    assert_includes vary, "Cookie"
  end

  private
    def assert_site_mode(mode)
      assert_response :success
      assert_select "body[data-site-mode=?]", mode
    end
end
