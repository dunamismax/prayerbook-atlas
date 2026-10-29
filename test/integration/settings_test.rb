require "test_helper"

class SettingsTest < ActionDispatch::IntegrationTest
  test "settings holds every section in both modes" do
    [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
      get settings_path, headers: { "User-Agent" => user_agent }
      assert_response :success
      [ "Prayer book", "Offices from another book", "Appearance", "Reading", "Phone site or full site", "About this site" ].each do |title|
        assert_select ".plate-card h2", title
      end
      assert_select "select[name^=office_books]", Office::SLUGS.size
      assert_select "a[href='mailto:support@prayerbookatlas.com']"
      assert_select ".source", /Version \S+/
    end
  end

  test "an office can come from another book, and be set back" do
    patch book_preference_path, params: { office_books: { "compline" => "bcp1979us", "litany" => "same", "vespers" => "bcp1662" } }
    get settings_path
    assert_select "select[name='office_books[compline]'] option[selected][value=bcp1979us]"
    assert_select "select[name='office_books[litany]'] option[selected][value=same]"

    patch book_preference_path, params: { office_books: Office::SLUGS.index_with("same") }
    get settings_path
    assert_select "select[name='office_books[compline]'] option[selected][value=same]"
  end

  test "office overrides ignore unknown offices and books" do
    assert_equal({ "compline" => "bcp1979us" },
      ApplicationController.parse_office_books("compline:bcp1979us,vespers:bcp1662,litany:bcp1549,junk"))
  end

  test "the site mode can be chosen from settings" do
    patch site_mode_path, params: { mode: "phone" }, headers: { "User-Agent" => UserAgents::DESKTOP_CHROME }
    get settings_path, headers: { "User-Agent" => UserAgents::DESKTOP_CHROME }
    assert_select "body[data-site-mode=phone]"
    assert_select "input[name=mode][value=phone][checked]"
  end

  test "the version is the checkout's commit outside a release" do
    assert_match(/\A\h{7,40}\z|\Aunknown\z/, SiteVersion.current)
  end
end
