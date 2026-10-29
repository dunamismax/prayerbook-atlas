require "phone_system_test_case"

class PhoneAppearanceSystemTest < PhoneSystemTestCase
  test "the phone reaches Settings from its bar and keeps the appearance chosen" do
    visit pray_path
    within(".phone-bar-tools") { click_link "Settings" }

    choose "Day: chart paper and iron-blue ink"
    click_button "Save appearance"
    assert_selector "html[data-appearance=day]", visible: :all

    within(".tab-bar") { click_link "Atlas" }
    assert_selector "html[data-appearance=day]", visible: :all
  end
end
