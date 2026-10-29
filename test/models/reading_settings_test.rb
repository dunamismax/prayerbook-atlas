require "test_helper"

class ReadingSettingsTest < ActiveSupport::TestCase
  test "defaults are the first option of each, and store nothing" do
    settings = ReadingSettings.new
    assert_equal "standard", settings[:text_size]
    assert_equal "colour", settings[:rubrics]
    assert_equal "", settings.to_cookie
    assert_empty settings.html_data
  end

  test "only valid choices that differ from the defaults are kept" do
    settings = ReadingSettings.new("text_size" => "larger", "rubrics" => "colour", "page_numbers" => "purple", "font" => "comic")
    assert_equal({ "text_size" => "larger" }, settings.changed)
    assert_equal "text_size:larger", settings.to_cookie
    assert_equal({ text_size: "larger" }, settings.html_data)
  end

  test "the cookie round-trips and ignores what it does not know" do
    settings = ReadingSettings.from_cookie("text_size:largest,show_rubrics:no,evil:<script>,keep_awake")
    assert_equal({ "text_size" => "largest", "show_rubrics" => "no" }, settings.changed)
    assert_equal settings.changed, ReadingSettings.from_cookie(settings.to_cookie).changed
    assert_empty ReadingSettings.from_cookie(nil).changed
  end

  test "every option has a style or a behaviour" do
    css = Rails.root.join("app/assets/stylesheets/reading.css").read
    %w[text-size line-spacing rubrics show-rubrics page-numbers].each { assert_includes css, "data-#{_1}=" }
    assert Rails.root.join("app/javascript/controllers/wake_lock_controller.js").exist?
  end
end
