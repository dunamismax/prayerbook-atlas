require "application_system_test_case"

# The phone site, as a phone's browser reaches it: Chrome's mobile emulation
# gives a phone-sized viewport with touch, a phone user agent, and the
# `Sec-CH-UA-Mobile: ?1` client hint that SiteMode reads first.
class PhoneSystemTestCase < ApplicationSystemTestCase
  PHONE_USER_AGENT = "Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 " \
    "(KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36"

  driven_by :selenium, using: :headless_chrome, screen_size: [ 390, 844 ],
    options: { name: :phone_chrome } do |options|
    options.add_emulation(
      device_metrics: { width: 390, height: 844, pixelRatio: 3, touch: true, mobile: true },
      user_agent: PHONE_USER_AGENT
    )
  end
end
