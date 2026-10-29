# The offices and services a prayer book may set out, by the slug its URLs use
# (docs/urls.md); their names are interface strings (config/locales). Phase 7
# grows this namespace into the office engine (Office::Assembler). Not every
# book has every one: a book without an office says so plainly, never
# borrowing another book's (P7.1).
module Office
  SLUGS = %w[morning-prayer evening-prayer noonday-prayer compline family-prayer litany holy-communion].freeze
  SLUG_PATTERN = Regexp.union(SLUGS)

  def self.name_for(slug)
    I18n.t("offices.#{slug}")
  end
end
