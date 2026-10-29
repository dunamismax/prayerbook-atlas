# The prayer books the site carries, by stable identifier (ported from the
# retired Swift PrayerBookID, tag ios-archive). The ids appear in URLs
# (docs/urls.md), content files, and the person's settings, so they never
# change once released; PrayerBookTest pins them. Books added by permission
# (D6) get new entries.
#
# `summary` is one plain line for the first-visit card (P2.11): who authorized
# the book, in that church's own terms, with no ranking among the books.
class PrayerBook < Data.define(:id, :title, :year, :summary)
  ALL = [
    new(id: "bcp1662", title: "The Book of Common Prayer (1662, Church of England)", year: 1662,
      summary: "The Church of England's Book of Common Prayer, from which most later Anglican prayer books descend."),
    new(id: "bcp1928us", title: "The Book of Common Prayer (1928, The Episcopal Church)", year: 1928,
      summary: "The Episcopal Church's book from 1928 until 1979, still used by many Anglicans in North America."),
    new(id: "bcp1979us", title: "The Book of Common Prayer (1979, The Episcopal Church)", year: 1979,
      summary: "The Book of Common Prayer of The Episcopal Church today.")
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

  def to_param
    id
  end
end
