# One block of a prayer book's text as printed (BUILD.md P2.8), ported from
# the retired Swift ContentKit (tag ios-archive): a heading, a paragraph, a
# rubric, lines led by their roles, versicles and responses, the Amen, the
# Gloria Patri as printed, a psalm verse, a canticle reference, a collect,
# alternatives, or a seasonal insertion point.
#
# Every block carries its SourceCitation: the book, the printing it was
# transcribed from, and the printed page. A block belongs to one book; texts
# are never shared between books by reference. Inline runs keep the
# printing's italics, small capitals, insertion points, line breaks, and page
# breaks, so the renderer (P2.9) can set it as printed.
#
# Blocks are plain values with a stable hash form (to_h and
# LiturgicalBlock.from_h), which the content compiler stores (P3.3).
# `problems` lists what makes a block unusable; the compiler refuses them.
module LiturgicalBlock
  INSERTION_KINDS = %w[name sovereign bishop other].freeze
  HALF_VERSE_MARKS = { "colon" => ":", "asterisk" => "*" }.freeze

  # A run of text within a block. The hash form is a one-key hash:
  # { "text" => "..." }, { "italic" => "..." }, { "small_caps" => "..." },
  # { "insertion" => { "kind" => "name", "printed" => "N." } },
  # { "line_break" => true }, or { "page_break" => "13" }.
  module Inline
    # Plain words. Italic and small capitals are as printed (the 1979
    # Psalter's LORD is small capitals); the text is exactly the printing's.
    Text = Data.define(:text) { def plain_text = text }
    Italic = Data.define(:text) { def plain_text = text }
    SmallCaps = Data.define(:text) { def plain_text = text }

    # A place where a name or title is said: the book prints a mark ("N.")
    # and the person or the day may supply the name. kind is one of
    # INSERTION_KINDS: a person's name, the sovereign, the bishop, or other.
    Insertion = Data.define(:kind, :printed) { def plain_text = printed }

    # A line break the printing makes and the reading needs, as in verse.
    LineBreak = Data.define { def plain_text = "\n" }

    # A new printed page begins here, with its number as printed.
    PageBreak = Data.define(:page) { def plain_text = "" }

    KEYS = { "text" => Text, "italic" => Italic, "small_caps" => SmallCaps }.freeze

    def self.plain_text(inlines)
      Array(inlines).map(&:plain_text).join
    end

    def self.to_h(inlines)
      inlines&.map do |inline|
        case inline
        when Insertion then { "insertion" => { "kind" => inline.kind, "printed" => inline.printed } }
        when LineBreak then { "line_break" => true }
        when PageBreak then { "page_break" => inline.page }
        else { KEYS.key(inline.class) => inline.text }
        end
      end
    end

    def self.from_h(list)
      list&.map do |hash|
        key, value = hash.to_h.stringify_keys.first
        case key
        when "insertion" then Insertion.new(kind: value.fetch("kind"), printed: value.fetch("printed"))
        when "line_break" then LineBreak.new
        when "page_break" then PageBreak.new(page: value)
        else KEYS.fetch(key) { raise ArgumentError, "unknown inline #{key}" }.new(text: value)
        end
      end
    end
  end

  # A line led by its role exactly as printed: "Minister", "People", ℣, ℟,
  # or nothing at all.
  RoleLine = Data.define(:role, :text) do
    def plain_text = [ role, Inline.plain_text(text) ].reject(&:empty?).join(" ")
    def to_h = { "role" => role, "text" => Inline.to_h(text) }
    def self.from_h(hash) = new(role: hash.fetch("role"), text: Inline.from_h(hash.fetch("text")))
  end

  # One choice in a set of alternatives, with the book's own label ("Or
  # this"), if it prints one.
  Alternative = Data.define(:label, :blocks) do
    def to_h = { "label" => Inline.to_h(label), "blocks" => blocks.map(&:to_h) }
    def self.from_h(hash) = new(label: Inline.from_h(hash["label"]), blocks: hash.fetch("blocks").map { LiturgicalBlock.from_h(_1) })
  end

  # What every kind of block shares: its id (unique across the content
  # database, P3.2), its source, and the checks.
  module Block
    def kind = self.class::KIND

    # The printed pages the block appears on: its own, then any page breaks.
    def pages = [ source.page ] + inlines.grep(Inline::PageBreak).map(&:page)

    def problems
      found = []
      found << "#{id}: no printed page" if source.page.to_s.strip.empty?
      found << "#{id}: no printing" if source.printing.to_s.strip.empty?
      found << "#{id}: unknown prayer book #{source.book}" unless PrayerBook.ids.include?(source.book)
      inlines.grep(Inline::Insertion).reject { _1.kind.in?(INSERTION_KINDS) }.each do |insertion|
        found << "#{id}: unknown insertion kind #{insertion.kind}"
      end
      found.concat(kind_problems)
      found << "#{id}: no words" if plain_text.strip.empty? && !is_a?(Alternatives)
      found
    end

    def to_h
      { "id" => id, "source" => source.to_h, "kind" => kind }.merge(fields_h)
    end

    private
      def kind_problems = []
  end

  # A heading; level 1 is an office's or service's title.
  Heading = Data.define(:id, :source, :level, :text) do
    include Block
    def inlines = text
    def plain_text = Inline.plain_text(text)
    def self.fields_from_h(hash) = { level: hash.fetch("level"), text: Inline.from_h(hash.fetch("text")) }

    private
      def fields_h = { "level" => level, "text" => Inline.to_h(text) }
      def kind_problems = level.to_i < 1 ? [ "#{id}: heading level below 1" ] : []
  end

  # The kinds that are a run of text and nothing else.
  text_kind = proc do
    include Block
    def inlines = text
    def plain_text = Inline.plain_text(text)
    def self.fields_from_h(hash) = { text: Inline.from_h(hash.fetch("text")) }

    private
      def fields_h = { "text" => Inline.to_h(text) }
  end

  Paragraph = Data.define(:id, :source, :text, &text_kind)
  # An instruction, never words to be said.
  Rubric = Data.define(:id, :source, :text, &text_kind)
  # The Amen, with the printing's own words and emphasis.
  Amen = Data.define(:id, :source, :text, &text_kind)

  # Lines led by their roles, or versicles and responses led by ℣ and ℟ or
  # the book's own labels (Priest, Answer).
  role_kind = proc do
    include Block
    def inlines = lines.flat_map(&:text)
    def plain_text = lines.map(&:plain_text).join("\n")
    def self.fields_from_h(hash) = { lines: hash.fetch("lines").map { RoleLine.from_h(_1) } }

    private
      def fields_h = { "lines" => lines.map(&:to_h) }
  end

  RoleLines = Data.define(:id, :source, :lines, &role_kind)
  Versicles = Data.define(:id, :source, :lines, &role_kind)

  # The Gloria Patri as the book prints it at this point (often abbreviated),
  # and the id of the same book's full text where the book gives it elsewhere.
  GloriaPatri = Data.define(:id, :source, :printed, :full_text) do
    include Block
    def inlines = printed
    def plain_text = Inline.plain_text(printed)
    def self.fields_from_h(hash) = { printed: Inline.from_h(hash.fetch("printed")), full_text: hash["full_text"] }

    private
      def fields_h = { "printed" => Inline.to_h(printed), "full_text" => full_text }
  end

  # A verse in a book's own Psalter, numbered as that book numbers it, with
  # the King James Version's number where it differs, and the half-verse mark
  # the book prints (a colon or an asterisk).
  PsalmVerse = Data.define(:id, :source, :psalm, :verse, :kjv_verse, :first_half, :second_half, :mark) do
    include Block
    def inlines = first_half + second_half
    def plain_text = [ Inline.plain_text(first_half), HALF_VERSE_MARKS[mark], Inline.plain_text(second_half) ].join(" ")

    def self.fields_from_h(hash)
      { psalm: hash.fetch("psalm"), verse: hash.fetch("verse"), kjv_verse: hash["kjv_verse"],
        first_half: Inline.from_h(hash.fetch("first_half")), second_half: Inline.from_h(hash.fetch("second_half")),
        mark: hash.fetch("mark") }
    end

    private
      def fields_h
        { "psalm" => psalm, "verse" => verse, "kjv_verse" => kjv_verse, "first_half" => Inline.to_h(first_half),
          "second_half" => Inline.to_h(second_half), "mark" => mark }
      end

      def kind_problems
        found = []
        found << "#{id}: psalm or verse out of range" unless psalm.to_i.between?(1, 150) && verse.to_i >= 1
        found << "#{id}: unknown half-verse mark #{mark}" unless HALF_VERSE_MARKS.key?(mark)
        found << "#{id}: KJV verse given but the same as the book's" if kjv_verse && kjv_verse == verse
        found
      end
  end

  # A canticle the book appoints here, by the id of the same book's text of
  # it, with whatever the book prints at this point.
  CanticleReference = Data.define(:id, :source, :canticle, :printed) do
    include Block
    def inlines = printed
    def plain_text = Inline.plain_text(printed)
    def self.fields_from_h(hash) = { canticle: hash.fetch("canticle"), printed: Inline.from_h(hash.fetch("printed")) }

    private
      def fields_h = { "canticle" => canticle, "printed" => Inline.to_h(printed) }
  end

  # A collect, with its title where the book prints one.
  Collect = Data.define(:id, :source, :title, :text) do
    include Block
    def inlines = Array(title) + text
    def plain_text = [ (Inline.plain_text(title) if title), Inline.plain_text(text) ].compact.join("\n")
    def self.fields_from_h(hash) = { title: Inline.from_h(hash["title"]), text: Inline.from_h(hash.fetch("text")) }

    private
      def fields_h = { "title" => Inline.to_h(title), "text" => Inline.to_h(text) }
  end

  # Choices the book offers ("or this"), each with its own label as printed.
  # Every option comes from the same book (D8).
  Alternatives = Data.define(:id, :source, :options) do
    include Block
    def inlines = options.flat_map { Array(_1.label) + _1.blocks.flat_map(&:inlines) }
    def plain_text = options.flat_map(&:blocks).map(&:plain_text).join("\n")
    def self.fields_from_h(hash) = { options: hash.fetch("options").map { Alternative.from_h(_1) } }

    private
      def fields_h = { "options" => options.map(&:to_h) }

      def kind_problems
        found = []
        found << "#{id}: alternatives need at least two options" if options.size < 2
        options.flat_map(&:blocks).each do |block|
          found << "#{id}: alternative #{block.id} is from another book" if block.source.book != source.book
          found.concat(block.problems)
        end
        found
      end
  end

  # A point where the day's proper or seasonal material goes, with whatever
  # the book prints there.
  SeasonalInsertion = Data.define(:id, :source, :key, :printed) do
    include Block
    def inlines = printed
    def plain_text = Inline.plain_text(printed)
    def self.fields_from_h(hash) = { key: hash.fetch("key"), printed: Inline.from_h(hash.fetch("printed")) }

    private
      def fields_h = { "key" => key, "printed" => Inline.to_h(printed) }
  end

  KINDS = {
    "heading" => Heading, "paragraph" => Paragraph, "rubric" => Rubric, "role_lines" => RoleLines,
    "versicles" => Versicles, "amen" => Amen, "gloria_patri" => GloriaPatri, "psalm_verse" => PsalmVerse,
    "canticle_reference" => CanticleReference, "collect" => Collect, "alternatives" => Alternatives,
    "seasonal_insertion" => SeasonalInsertion
  }.freeze
  KINDS.each { |name, klass| klass.const_set(:KIND, name) }

  def self.from_h(hash)
    hash = hash.to_h.deep_stringify_keys
    kind = KINDS.fetch(hash.fetch("kind")) { raise ArgumentError, "unknown block kind #{hash["kind"]}" }
    kind.new(id: hash.fetch("id"), source: SourceCitation.from_h(hash.fetch("source")), **kind.fields_from_h(hash))
  end
end
