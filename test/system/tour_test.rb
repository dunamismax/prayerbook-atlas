require "application_system_test_case"

# The tour (BUILD.md P2.14): every section and Settings on the full site,
# by day and by night, with a screenshot of each in tmp/screenshots/ (never
# committed) for looking over the whole site at once.
class TourSystemTest < ApplicationSystemTestCase
  include TourSteps

  test "the full site, every page, by day and by night" do
    tour("full")
  end
end
