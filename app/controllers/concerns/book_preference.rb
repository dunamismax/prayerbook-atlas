# The person's prayer book (D4): chosen on the first-visit card on Today or
# in Settings, and kept in a preference cookie holding only the book's id, so
# it works without JavaScript. Until a choice is made the site uses 1662,
# and skipping the card records that preset so the card does not return.
module BookPreference
  extend ActiveSupport::Concern

  COOKIE = :book
  # Per-office choices (P2.12): "compline:bcp1979us,litany:bcp1928us".
  OFFICE_COOKIE = :office_books

  included do
    helper_method :prayer_book, :prayer_book_chosen?, :office_book_overrides, :prayer_book_for
  end

  private
    def prayer_book
      @prayer_book ||= PrayerBook.find(cookies[COOKIE].presence_in(PrayerBook.ids) || PrayerBook::PRESET)
    end

    def prayer_book_chosen?
      cookies[COOKIE].presence_in(PrayerBook.ids).present?
    end

    # { "compline" => "bcp1979us" }: offices the person prays from another book.
    def office_book_overrides
      @office_book_overrides ||= self.class.parse_office_books(cookies[OFFICE_COOKIE])
    end

    # The book for an office: its override, or the person's prayer book.
    def prayer_book_for(office)
      office_book_overrides[office.to_s].then { _1 ? PrayerBook.find(_1) : prayer_book }
    end

  class_methods do
    def parse_office_books(value)
      value.to_s.split(",").filter_map { _1.split(":", 2) if _1.include?(":") }.to_h
        .select { |office, book| Office::SLUGS.include?(office) && book.in?(PrayerBook.ids) }
    end
  end
end
