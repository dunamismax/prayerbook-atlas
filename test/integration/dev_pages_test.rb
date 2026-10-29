require "test_helper"

class DevPagesTest < ActionDispatch::IntegrationTest
  test "the type specimen renders in both modes with every mark" do
    [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
      get dev_type_path, headers: { "User-Agent" => user_agent }
      assert_response :success
      assert_select "main#main h1", "Type specimen"
      %w[℣ ℟ † ¶ ✠].each { |mark| assert_select "td.specimen-mark", text: mark }
      assert_select "[lang=el]"
    end
  end

  test "the cross falls back to a system serif before the general fallbacks" do
    base = Rails.root.join("app/assets/stylesheets/base.css").read
    fonts = Rails.root.join("app/assets/stylesheets/fonts.css").read
    assert_match(/--face-book: "Cardo", "Atlas Cross",/, base)
    assert_match(/font-family: "Atlas Cross";[^}]*unicode-range: U\+2720;/m, fonts)
  end

  test "the component gallery renders in both modes" do
    [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
      get dev_components_path, headers: { "User-Agent" => user_agent }
      assert_response :success
      assert_select "main#main h1", "Components"
      assert_select ".ribbon-marker", DesignTokens.ribbons.size
      assert_select ".state[role=alert]", 1
      assert_select "[popover]"
      assert_select ".margin-note h2", "A margin note"
    end
  end

  test "the block sample renders in both modes" do
    [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
      get dev_liturgy_path, headers: { "User-Agent" => user_agent }
      assert_response :success
      assert_select ".liturgy [data-block]", minimum: SampleBlocks.all.size
    end
  end
end
