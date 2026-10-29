# The site's five sections (docs/product.md §1), in the order both modes show
# them: across the masthead on the full site, along the tab bar on the phone.
# Their titles and summaries are interface strings (config/locales).
class SiteSection < Data.define(:key)
  ALL = %w[today pray bible kalendar atlas].map { new(key: _1) }.freeze

  def self.all
    ALL
  end

  def self.find(key)
    ALL.find { |section| section.key == key } or raise KeyError, "no section #{key}"
  end

  def title = I18n.t("sections.#{key}.title")
  def summary = I18n.t("sections.#{key}.summary")
end
