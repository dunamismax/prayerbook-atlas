# The offices and services a prayer book may set out, by the slug its URLs use
# (docs/urls.md). Phase 7 grows this namespace into the office engine
# (Office::Assembler). Not every book has every one: a book without an office
# says so plainly, never borrowing another book's (P7.1).
module Office
  NAMES = {
    "morning-prayer" => "Morning Prayer",
    "evening-prayer" => "Evening Prayer",
    "noonday-prayer" => "Noonday Prayer",
    "compline" => "Compline",
    "family-prayer" => "Family Prayer",
    "litany" => "The Litany",
    "holy-communion" => "Holy Communion"
  }.freeze

  SLUG_PATTERN = Regexp.union(NAMES.keys)
end
