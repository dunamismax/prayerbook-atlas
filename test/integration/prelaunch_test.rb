require "test_helper"

# Until launch (BUILD.md P22) the site asks not to be indexed and says on every
# page that it is unfinished (P5.7).
class PrelaunchTest < ActionDispatch::IntegrationTest
  test "every page says the site is in development and asks not to be indexed" do
    %w[/ /pray /bible /kalendar /atlas /about /settings].each do |path|
      [ UserAgents::IPHONE, UserAgents::DESKTOP_CHROME ].each do |user_agent|
        get path, headers: { "User-Agent" => user_agent }
        assert_select "p.development-notice[role=note]", /still being built/, "#{path} for #{user_agent}"
        assert_select "meta[name=robots][content='noindex, nofollow']", 1
      end
    end
  end

  test "robots.txt disallows the whole site" do
    rules = Rails.public_path.join("robots.txt").read.lines.map(&:strip).reject { it.empty? || it.start_with?("#") }
    assert_equal [ "User-agent: *", "Disallow: /" ], rules
  end
end
