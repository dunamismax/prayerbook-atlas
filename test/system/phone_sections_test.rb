require "phone_system_test_case"

class PhoneSectionsTest < PhoneSystemTestCase
  test "the phone site visits every section from the tab bar" do
    visit root_path
    assert_site_mode "phone"

    SiteSection.all.each do |section|
      within(".tab-bar") { click_link section.title }
      assert_selector "main#main h1", count: 1
      assert_selector ".tab-bar a[aria-current=page]", text: /\A#{section.title}\z/i
      assert_no_selector ".masthead"
    end

    within(".site-footer") { click_link "About" }
    assert_selector "main#main h1", count: 1
  end

  test "the phone site switches to the full site and back" do
    visit bible_path
    click_button "Use the full site"
    assert_site_mode "full"
    assert_current_path bible_path

    click_button "Choose for this device automatically"
    assert_site_mode "phone"
  end
end
