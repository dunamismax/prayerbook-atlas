require "phone_system_test_case"

# The tour on the phone site (BUILD.md P2.14).
class PhoneTourSystemTest < PhoneSystemTestCase
  include TourSteps

  test "the phone site, every page, by day and by night" do
    tour("phone")
  end
end
