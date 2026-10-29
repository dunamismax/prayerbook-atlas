require "test_helper"

class AppearanceTest < ActionDispatch::IntegrationTest
  test "automatic writes no appearance, so the system's choice holds" do
    get root_path
    assert_select "html[lang=en]"
    assert_select "html[data-appearance]", 0
  end

  test "a chosen appearance is written on html by the server" do
    patch appearance_path, params: { appearance: "night" }
    assert_response :see_other
    assert_redirected_to settings_path

    get pray_path
    assert_select "html[data-appearance=night]"

    patch appearance_path, params: { appearance: "day" }
    get pray_path
    assert_select "html[data-appearance=day]"
  end

  test "automatic and unknown choices delete the cookie" do
    patch appearance_path, params: { appearance: "night" }
    patch appearance_path, params: { appearance: "automatic" }
    get root_path
    assert_select "html[data-appearance]", 0

    patch appearance_path, params: { appearance: "sepia" }
    get root_path
    assert_select "html[data-appearance]", 0
  end

  test "the form returns the person to the page they came from" do
    patch appearance_path, params: { appearance: "night" }, headers: { "Referer" => "http://www.example.com/kalendar" }
    assert_redirected_to "http://www.example.com/kalendar"
  end

  test "settings shows the current choice in both modes" do
    patch appearance_path, params: { appearance: "day" }
    [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
      get settings_path, headers: { "User-Agent" => user_agent }
      assert_response :success
      assert_select "form[action='#{appearance_path}'][data-turbo=false] input[type=radio][name=appearance]", 3
      assert_select "input[type=radio][value=day][checked]"
      assert_select "a[href='#{settings_path}'][aria-current=page]", "Settings"
    end
  end
end
