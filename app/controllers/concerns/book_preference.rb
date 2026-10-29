# The person's prayer book (D4): chosen on the first-visit card on Today or
# in Settings, and kept in a preference cookie holding only the book's id, so
# it works without JavaScript. Until a choice is made the site uses 1662,
# and skipping the card records that preset so the card does not return.
module BookPreference
  extend ActiveSupport::Concern

  COOKIE = :book

  included do
    helper_method :prayer_book, :prayer_book_chosen?
  end

  private
    def prayer_book
      @prayer_book ||= PrayerBook.find(cookies[COOKIE].presence_in(PrayerBook.ids) || PrayerBook::PRESET)
    end

    def prayer_book_chosen?
      cookies[COOKIE].presence_in(PrayerBook.ids).present?
    end
end
