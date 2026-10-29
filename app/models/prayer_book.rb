# The prayer books the site carries, by stable identifier (ported from the
# retired Swift PrayerBookID, tag ios-archive). The ids appear in URLs
# (docs/urls.md), content files, and the person's settings, so they never
# change once released; PrayerBookTest pins them. Books added by permission
# (D6) get new entries.
class PrayerBook < Data.define(:id, :title, :year)
  ALL = [
    new(id: "bcp1662", title: "The Book of Common Prayer (1662, Church of England)", year: 1662),
    new(id: "bcp1928us", title: "The Book of Common Prayer (1928, The Episcopal Church)", year: 1928),
    new(id: "bcp1979us", title: "The Book of Common Prayer (1979, The Episcopal Church)", year: 1979)
  ].freeze

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

  def to_param
    id
  end
end
