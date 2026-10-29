# The site's five sections (docs/product.md §1), in the order both modes show
# them: across the masthead on the full site, along the tab bar on the phone.
class SiteSection < Data.define(:key, :title, :summary)
  ALL = [
    new(key: "today", title: "Today",
      summary: "The day in the Church's year and the office for the hour, from your prayer book."),
    new(key: "pray", title: "Pray",
      summary: "The offices, the Litany, prayers and thanksgivings, Holy Communion, and the pastoral offices."),
    new(key: "bible", title: "Bible",
      summary: "Holy Scripture, the day's lessons, each book's Psalter, the lectionaries, and reading plans."),
    new(key: "kalendar", title: "Kalendar",
      summary: "The Christian year by month and year: holy days, commemorations, fasts, and the Easter tables."),
    new(key: "atlas", title: "Atlas",
      summary: "The prayer books themselves: each book's page, any prayer compared across books, and their lineage.")
  ].freeze

  def self.all
    ALL
  end

  def self.find(key)
    ALL.find { |section| section.key == key } or raise KeyError, "no section #{key}"
  end
end
