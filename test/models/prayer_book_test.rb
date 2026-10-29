require "test_helper"

class PrayerBookTest < ActiveSupport::TestCase
  test "the ids never change once released" do
    assert_equal %w[bcp1662 bcp1928us bcp1979us], PrayerBook.all.map(&:id)
    assert_equal %w[kjva web], Translation.all.map(&:id)
  end

  test "books are listed by date, never ranked" do
    assert_equal PrayerBook.all.sort_by(&:year), PrayerBook.all
  end

  test "finding an unknown book fails plainly" do
    assert_raises(KeyError) { PrayerBook.find("bcp1549") }
    assert_nil Translation.find_by_id("niv")
  end
end
