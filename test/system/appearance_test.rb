require "application_system_test_case"

class AppearanceSystemTest < ApplicationSystemTestCase
  test "choosing an appearance in Settings redraws the whole page in it" do
    visit kalendar_path
    within(".masthead-tools") { click_link "Settings" }

    choose "Night: a night chart, deep blue-black with pale ink"
    click_button "Save appearance"
    assert_selector "html[data-appearance=night]", visible: :all

    choose "Automatic: follow this device's light or dark setting"
    click_button "Save appearance"
    assert_no_selector "html[data-appearance]", visible: :all
  end
end
