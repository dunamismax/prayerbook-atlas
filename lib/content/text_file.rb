module Content
  # One text file of content/ (docs/content-format.md): front matter, then
  # liturgical blocks, Scripture verses, or original paragraphs according to
  # its kind. Parsing checks the file's own shape; the compiler checks what
  # needs the whole of content/ (sources, books, references, duplicates).
  class TextFile
    LITURGY = %w[office prayer collect psalm canticle litany service].freeze
    ORIGINAL = %w[note guide glossary].freeze
    KINDS = LITURGY + ORIGINAL + %w[scripture quotation].freeze
    KEYS = %w[id kind title source book printing page translation bible_book half_verse_mark work review
              author work_title edition location].freeze
    REVIEWS = %w[pending approved].freeze
    DOCUMENT_ID = /\A[a-z0-9]+(?:[-.][a-z0-9]+)*\z/
    SUFFIX = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

    # Original paragraphs and headings, and the paragraphs of a quotation:
    # not a prayer book's text, so they carry no book, printing, or page.
    Prose = Data.define(:id, :kind, :text) do
      def plain_text = LiturgicalBlock::Inline.plain_text(text)
      def to_h = { "id" => id, "kind" => kind, "text" => LiturgicalBlock::Inline.to_h(text) }
    end

    # One verse of Scripture, numbered as the edition numbers it.
    Verse = Data.define(:chapter, :verse, :text) do
      def plain_text = LiturgicalBlock::Inline.plain_text(text)
    end

    attr_reader :path, :meta, :blocks, :verses, :problems

    def self.load(path, relative_path = path) = new(File.read(path, encoding: "UTF-8"), path: relative_path.to_s)

    def initialize(text, path:)
      @path = path
      @meta = {}
      @blocks = []
      @verses = []
      @problems = []
      @works = {}
      parse(text)
    end

    def id = meta["id"]
    def kind = meta["kind"]
    def liturgy? = kind.in?(LITURGY)
    def original? = kind.in?(ORIGINAL)
    def scripture? = kind == "scripture"
    def quotation? = kind == "quotation"

    # Works named by blocks (work=), by block id.
    def block_works = @works

    # Every block, with the blocks inside alternatives.
    def all_blocks
      blocks.flat_map do |block|
        block.is_a?(LiturgicalBlock::Alternatives) ? [ block ] + block.options.flat_map(&:blocks) : [ block ]
      end
    end

    private
      def parse(text)
        problem "not valid UTF-8" and return unless text.valid_encoding?
        problem "has Windows line ends" if text.include?("\r")
        head, separator, body = text.partition(/^---[ \t]*\n/)
        problem "has no front matter ending in ---" and return if separator.empty?

        parse_front_matter(head)
        check_front_matter
        return if id.nil? || !KINDS.include?(kind)

        @lines = body.lines(chomp: true).each_with_index.map { |line, index| [ line, head.lines.size + 2 + index ] }
        if liturgy? then parse_liturgy
        elsif scripture? then parse_scripture
        else parse_prose
        end
      end

      def parse_front_matter(head)
        head.each_line(chomp: true) do |line|
          next if line.strip.empty?
          key, value = line.split(":", 2).map(&:strip)
          if value.nil? || value.empty? then problem "front matter line without a value: #{line}"
          elsif !KEYS.include?(key) then problem "unknown front matter key #{key}"
          elsif meta.key?(key) then problem "#{key} given twice"
          else meta[key] = value
          end
        end
      end

      def check_front_matter
        required = %w[id kind title source]
        required += %w[book printing page] if liturgy?
        required += %w[translation bible_book] if scripture?
        required += %w[review] if original?
        required += %w[author work_title edition location page] if quotation?
        (required - meta.keys).each { problem "missing #{_1}" }
        problem "unknown kind #{kind}" if kind && !KINDS.include?(kind)
        problem "id #{id} is not lower case with hyphens and dots" if id && !id.match?(DOCUMENT_ID)
        problem "review must be pending or approved" if meta["review"] && !REVIEWS.include?(meta["review"])
        problem "original work must have source: original" if original? && meta["source"] != "original"
        problem "a book's text must have the same printing and source" if liturgy? && meta["printing"] && meta["printing"] != meta["source"]
        if meta["half_verse_mark"] && !LiturgicalBlock::HALF_VERSE_MARKS.key?(meta["half_verse_mark"])
          problem "half_verse_mark must be colon or asterisk"
        end
      end

      # Liturgical blocks: @directives, each followed by its lines.
      def parse_liturgy
        @page = meta["page"]
        @counters = [ 0 ]
        @stack = [ { blocks: @blocks } ]
        @pending = nil
        @lines.each do |line, number|
          @number = number
          if (match = line.match(/\A@([a-z_]+)(?:\s+(.*))?\z/))
            close_pending
            directive(match[1], parse_attributes(match[2].to_s))
          elsif @pending
            @pending[:lines] << line
          elsif !line.strip.empty?
            problem "line #{number}: text outside a block"
          end
        end
        close_pending
        problem "@alternatives without @end" if @stack.size > 1
      end

      DIRECTIVES = %w[heading paragraph rubric amen role_lines versicles gloria_patri canticle_reference collect
                      seasonal_insertion psalm].freeze

      def directive(name, attributes)
        case name
        when "page"
          @page = attributes[:positional].first or problem("line #{@number}: @page needs a page")
        when "alternatives"
          problem "line #{@number}: @alternatives cannot nest" and return if @stack.size > 1
          @stack << { attributes: attributes, options: [], line: @number, page: @page }
        when "option"
          container = @stack.last
          problem "line #{@number}: @option outside @alternatives" and return unless container[:options]
          @counters.pop if container[:options].any?
          container[:options] << { label: attributes[:named]["label"], blocks: [] }
          container[:blocks] = container[:options].last[:blocks]
          @counters << 0
        when "end"
          container = @stack.last
          problem "line #{@number}: @end without @alternatives" and return unless container[:options]
          @stack.pop
          @counters.pop if container[:options].any?
          build_alternatives(container)
        when *DIRECTIVES
          @pending = { name: name, attributes: attributes, lines: [], line: @number, page: @page }
        else
          problem "line #{@number}: unknown directive @#{name}"
        end
      end

      def parse_attributes(string)
        named = {}
        positional = []
        string.scan(/([a-z_]+)=(?:"([^"]*)"|(\S+))|(\S+)/) do |key, quoted, bare, word|
          key ? named[key] = quoted || bare : positional << word
        end
        { named: named, positional: positional }
      end

      def close_pending
        return unless (pending = @pending)
        @pending = nil
        if @stack.last[:options] && @stack.last[:options].empty?
          problem "line #{pending[:line]}: a block inside @alternatives before its first @option"
          return
        end
        if pending[:name] == "psalm"
          psalm_verses(pending).each { add_block(_1) }
        else
          block = build_block(pending)
          add_block(block) if block
        end
      end

      def add_block(block)
        @stack.last[:blocks] << block
        breaks = block.inlines.grep(LiturgicalBlock::Inline::PageBreak)
        @page = breaks.last.page if breaks.any?
      end

      ALLOWED_ATTRIBUTES = {
        "heading" => %w[level], "gloria_patri" => %w[full], "canticle_reference" => %w[canticle],
        "collect" => %w[title], "seasonal_insertion" => %w[key]
      }.freeze

      def build_block(pending)
        name, named = pending[:name], pending[:attributes][:named]
        unknown = named.keys - %w[id work] - ALLOWED_ATTRIBUTES.fetch(name, [])
        problem "line #{pending[:line]}: @#{name} does not take #{unknown.join(", ")}" if unknown.any?
        problem "line #{pending[:line]}: @#{name} takes no positional words" if pending[:attributes][:positional].any?
        id = block_id(named["id"], pending[:line])
        source = SourceCitation.new(book: meta["book"], printing: meta["printing"], page: pending[:page].to_s)
        @works[id] = named["work"] if named["work"]

        case name
        when "heading"
          LiturgicalBlock::Heading.new(id: id, source: source, level: named.fetch("level", "1").to_i, text: paragraph(pending))
        when "paragraph" then LiturgicalBlock::Paragraph.new(id: id, source: source, text: paragraph(pending))
        when "rubric" then LiturgicalBlock::Rubric.new(id: id, source: source, text: paragraph(pending))
        when "amen" then LiturgicalBlock::Amen.new(id: id, source: source, text: paragraph(pending))
        when "role_lines", "versicles"
          klass = name == "role_lines" ? LiturgicalBlock::RoleLines : LiturgicalBlock::Versicles
          klass.new(id: id, source: source, lines: role_lines(pending))
        when "gloria_patri"
          LiturgicalBlock::GloriaPatri.new(id: id, source: source, printed: paragraph(pending), full_text: named["full"])
        when "canticle_reference"
          problem "line #{pending[:line]}: @canticle_reference needs canticle=" unless named["canticle"]
          LiturgicalBlock::CanticleReference.new(id: id, source: source, canticle: named["canticle"], printed: paragraph(pending))
        when "collect"
          title = named["title"] && inlines(named["title"], pending[:line])
          LiturgicalBlock::Collect.new(id: id, source: source, title: title, text: paragraph(pending))
        when "seasonal_insertion"
          problem "line #{pending[:line]}: @seasonal_insertion needs key=" unless named["key"]
          LiturgicalBlock::SeasonalInsertion.new(id: id, source: source, key: named["key"], printed: paragraph(pending))
        end
      end

      def build_alternatives(container)
        named = container[:attributes][:named]
        id = block_id(named["id"], container[:line])
        @works[id] = named["work"] if named["work"]
        source = SourceCitation.new(book: meta["book"], printing: meta["printing"], page: container[:page].to_s)
        options = container[:options].each_with_index.map do |option, index|
          label = option[:label] && inlines(option[:label], container[:line])
          blocks = option[:blocks].map { reparent(_1, "#{id}.#{index + 1}") }
          LiturgicalBlock::Alternative.new(label: label, blocks: blocks)
        end
        @stack.last[:blocks] << LiturgicalBlock::Alternatives.new(id: id, source: source, options: options)
      end

      # Blocks inside an option were numbered within it; their ids take the
      # alternatives' id as their prefix.
      def reparent(block, prefix)
        new_id = block.id.sub(/\A#{Regexp.escape(id)}\.__option\./, "#{prefix}.")
        @works[new_id] = @works.delete(block.id) if @works.key?(block.id)
        block.with(id: new_id)
      end

      def block_id(suffix, line)
        prefix = @stack.size > 1 ? "#{id}.__option" : id
        if suffix
          problem "line #{line}: block id #{suffix} is not lower case with hyphens" unless suffix.match?(SUFFIX)
          "#{prefix}.#{suffix}"
        else
          @counters[-1] += 1
          "#{prefix}.#{@counters[-1]}"
        end
      end

      def paragraph(pending)
        joined = pending[:lines].map(&:strip).reject(&:empty?).join(" ").gsub(/\s*\{br\}\s*/, "{br}")
        inlines(joined, pending[:line])
      end

      def role_lines(pending)
        pending[:lines].reject { _1.strip.empty? }.map do |line|
          role, text = line.strip.match(/\A([^|{}]+?) \| (.*)\z/)&.captures || [ "", line.strip ]
          LiturgicalBlock::RoleLine.new(role: role, text: inlines(text, pending[:line]))
        end
      end

      def psalm_verses(pending)
        psalm = pending[:attributes][:positional].first.to_i
        mark = meta["half_verse_mark"]
        problem "line #{pending[:line]}: @psalm needs its number" unless psalm.positive?
        problem "line #{pending[:line]}: a psalm needs half_verse_mark in the front matter" and return [] unless mark
        separator = " #{LiturgicalBlock::HALF_VERSE_MARKS.fetch(mark)} "
        pending[:lines].reject { _1.strip.empty? }.filter_map do |line|
          number, kjv, text = line.strip.match(/\A(\d+)(?:\s+\[kjv (\d+)\])?\s+(.*)\z/)&.captures
          problem "line #{pending[:line]}: psalm verse without its number: #{line}" and next unless number
          halves = text.split(separator)
          problem "psalm #{psalm}:#{number}: needs exactly one #{separator.strip.inspect} between its halves" and next unless halves.size == 2
          source = SourceCitation.new(book: meta["book"], printing: meta["printing"], page: @page.to_s)
          LiturgicalBlock::PsalmVerse.new(id: "#{id}.p#{psalm}.#{number}", source: source, psalm: psalm, verse: number.to_i,
            kjv_verse: kjv&.to_i, first_half: inlines(halves[0], pending[:line]), second_half: inlines(halves[1], pending[:line]), mark: mark)
        end
      end

      def parse_scripture
        @lines.each do |line, number|
          next if line.strip.empty?
          chapter, verse, text = line.strip.match(/\A(\d+):(\d+)\s+(.*)\z/)&.captures
          problem "line #{number}: a verse must begin chapter:verse" and next unless chapter
          @verses << Verse.new(chapter: chapter.to_i, verse: verse.to_i, text: inlines(text, number))
        end
        problem "no verses" if @verses.empty?
      end

      # Paragraphs separated by blank lines; "# " begins a heading.
      def parse_prose
        paragraphs = @lines.chunk_while { |(a, _), (b, _)| !a.strip.empty? && !b.strip.empty? }
        paragraphs.each do |chunk|
          text = chunk.map(&:first).map(&:strip).reject(&:empty?)
          next if text.empty?
          kind = text.first.start_with?("# ") ? "heading" : "paragraph"
          text[0] = text[0].delete_prefix("# ") if kind == "heading"
          @blocks << Prose.new(id: "#{id}.#{@blocks.size + 1}", kind: kind, text: inlines(text.join(" "), chunk.first.last))
        end
        problem "no paragraphs" if @blocks.empty?
      end

      def inlines(string, line)
        result, found = Inlines.parse(string)
        found.each { problem "line #{line}: #{_1}" }
        result
      end

      def problem(message)
        @problems << "#{path}: #{message}"
      end
  end
end
