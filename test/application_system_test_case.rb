require "test_helper"
require_relative "support/tour_steps"

# System tests drive headless Chrome against the running app (decision 29).
# This base class is the full site in a desktop-sized window; the phone site
# has its own (PhoneSystemTestCase). Screenshots from failures, and any taken
# with `take_screenshot`, go to tmp/screenshots/, which is never committed.
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1440, 900 ],
    options: { name: :desktop_chrome }

  # bin/ci clears tmp/ before the tests, so the first pages are drawn cold;
  # Capybara's default two seconds was occasionally too short for them.
  Capybara.default_max_wait_time = 5

  private
    def assert_site_mode(mode)
      assert_selector "body[data-site-mode=#{mode}]"
    end
end
