require "test_helper"

class ReadingSettingsFormTest < ActionDispatch::IntegrationTest
  test "reading settings are written on html by the server" do
    patch reading_settings_path, params: { text_size: "larger", rubrics: "italic", page_numbers: "hidden", spelling: "original" }
    assert_redirected_to settings_path

    get pray_path
    assert_select "html[data-text-size=larger][data-rubrics=italic][data-page-numbers=hidden]"
    assert_select "html[data-spelling]", 0
    assert_select "body[data-controller]", 0
  end

  test "keeping the screen awake connects the wake-lock controller in both modes" do
    patch reading_settings_path, params: { keep_awake: "yes" }
    [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
      get root_path, headers: { "User-Agent" => user_agent }
      assert_select "body[data-controller=wake-lock]"
    end
  end

  test "choosing every default deletes the cookie" do
    patch reading_settings_path, params: { text_size: "largest" }
    patch reading_settings_path, params: ReadingSettings::DEFAULTS
    get root_path
    assert_select "html[data-text-size]", 0
  end

  test "settings shows each reading choice with the current one checked" do
    patch reading_settings_path, params: { line_spacing: "relaxed" }
    get settings_path
    assert_select "form[action='#{reading_settings_path}'][data-turbo=false]"
    ReadingSettings::OPTIONS.each do |field, values|
      assert_select "input[type=radio][name=#{field}]", values.size
    end
    assert_select "input[name=line_spacing][value=relaxed][checked]"
    assert_select ".liturgy .rubric"
  end
end
