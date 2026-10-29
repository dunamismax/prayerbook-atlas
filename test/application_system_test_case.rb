require "test_helper"

# System tests drive headless Chrome against the running app (decision 29).
# This base class is the full site in a desktop-sized window; the phone site
# has its own (PhoneSystemTestCase). Screenshots from failures, and any taken
# with `take_screenshot`, go to tmp/screenshots/, which is never committed.
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1440, 900 ],
    options: { name: :desktop_chrome }

  private
    def assert_site_mode(mode)
      assert_selector "body[data-site-mode=#{mode}]"
    end
end
