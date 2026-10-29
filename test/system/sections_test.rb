require "application_system_test_case"

class SectionsTest < ApplicationSystemTestCase
  test "the full site visits every section from the masthead" do
    visit root_path
    assert_site_mode "full"

    SiteSection.all.each do |section|
      within(".masthead .section-nav") { click_link section.title }
      assert_selector "main#main h1", count: 1
      assert_selector ".section-nav a[aria-current=page]", text: /\A#{section.title}\z/i
      assert_selector ".contents"
      assert_no_selector ".tab-bar"
    end

    within(".site-footer") { click_link "About" }
    assert_selector "main#main h1", count: 1
  end

  test "the full site switches to the phone site and back" do
    visit pray_path
    click_button "Use the phone site"
    assert_site_mode "phone"
    assert_current_path pray_path

    click_button "Choose for this device automatically"
    assert_site_mode "full"
  end
end
