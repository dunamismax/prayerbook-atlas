require "test_helper"

class BookPreferenceTest < ActionDispatch::IntegrationTest
  test "a first visit to Today offers the books in both modes, after the page's title" do
    [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
      get root_path, headers: { "User-Agent" => user_agent }
      assert_select "main h1 ~ .first-visit h2", "Which prayer book does your church use?"
      assert_select ".first-visit input[type=radio][name=book]", PrayerBook.all.size
      assert_select ".first-visit input[name=book][value=bcp1662][checked]"
      assert_select ".first-visit .skip-form input[type=hidden][name=book][value=bcp1662]"
    end
  end

  test "the card is only on Today, and never a dialog" do
    get pray_path
    assert_select ".first-visit", 0
    get root_path
    assert_select "dialog, [role=dialog]", 0
  end

  test "choosing a book keeps it and the card goes" do
    patch book_preference_path, params: { book: "bcp1979us" }, headers: { "Referer" => "http://www.example.com/" }
    assert_redirected_to "http://www.example.com/"

    get root_path
    assert_select ".first-visit", 0
    assert_select ".margin", /The Book of Common Prayer \(1979, The Episcopal Church\)/

    get settings_path
    assert_select "input[name=book][value=bcp1979us][checked]"
  end

  test "skipping records the preset, 1662" do
    patch book_preference_path, params: { book: PrayerBook::PRESET }
    get root_path
    assert_select ".first-visit", 0
    assert_select ".margin", /1662, Church of England/
  end

  test "an unknown book changes nothing" do
    patch book_preference_path, params: { book: "bcp1549" }
    get root_path
    assert_select ".first-visit"
  end
end
