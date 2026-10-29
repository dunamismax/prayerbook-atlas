# The Bible translations the site carries, by stable identifier (ported from
# the retired Swift TranslationID, tag ios-archive). Every passage names its
# translation (D5). Licensed translations are added only when
# content/SOURCES.md records the license. The prayer books' own Psalters are
# not translations here: they belong to each book.
class Translation < Data.define(:id)
  ALL = %w[kjva web].map { new(id: _1) }.freeze

  def self.all
    ALL
  end

  def self.find_by_id(id)
    ALL.find { |translation| translation.id == id }
  end

  def title = I18n.t("translations.#{id}")
end
