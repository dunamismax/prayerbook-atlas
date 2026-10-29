# The prayer books the site carries, by stable identifier (ported from the
# retired Swift PrayerBookID, tag ios-archive). The ids appear in URLs
# (docs/urls.md), content files, and the person's settings, so they never
# change once released; PrayerBookTest pins them. Books added by permission
# (D6) get new entries.
#
# Each book's title, and `summary`, one plain line for the first-visit card
# (P2.11) saying who authorized the book in that church's own terms with no
# ranking among the books, are interface strings (config/locales).
class PrayerBook < Data.define(:id, :year)
  ALL = [
    new(id: "bcp1662", year: 1662),
    new(id: "bcp1928us", year: 1928),
    new(id: "bcp1979us", year: 1979)
  ].freeze

  # Until the person chooses, the site uses 1662, the common ancestor (D4).
  PRESET = "bcp1662"

  ID_PATTERN = Regexp.union(ALL.map(&:id))

  def self.all
    ALL
  end

  def self.ids
    ALL.map(&:id)
  end

  def self.find(id)
    ALL.find { |book| book.id == id } or raise KeyError, "no prayer book #{id}"
  end

  def title = I18n.t("prayer_books.#{id}.title")
  def summary = I18n.t("prayer_books.#{id}.summary")

  def to_param
    id
  end
end
