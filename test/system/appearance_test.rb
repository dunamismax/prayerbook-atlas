require "application_system_test_case"

class AppearanceSystemTest < ApplicationSystemTestCase
  test "choosing an appearance in Settings redraws the whole page in it" do
    visit kalendar_path
    within(".masthead-tools") { click_link "Settings" }

    choose "Night: a night chart, deep blue-black with pale ink"
    click_button "Save appearance"
    assert_selector "html[data-appearance=night]", visible: :all

    # Load the next page afresh: acting at once on the page the redirect drew
    # has lost the race with the browser more than once (Selenium reported a
    # node no longer in the document).
    visit settings_path
    choose "Automatic: follow this device's light or dark setting"
    click_button "Save appearance"
    assert_no_selector "html[data-appearance]", visible: :all
  end

  test "reading settings apply across the site and can be undone" do
    visit settings_path
    choose "Largest"
    choose "In italic only"
    click_button "Save reading settings"
    assert_selector "html[data-text-size=largest][data-rubrics=italic]", visible: :all

    visit about_path
    assert_selector "html[data-text-size=largest]", visible: :all

    visit settings_path
    choose "Standard: your browser's own size"
    choose "In colour and italic"
    click_button "Save reading settings"
    assert_no_selector "html[data-text-size]", visible: :all
  end
end
