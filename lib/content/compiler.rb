require "digest"
require "json"
require "sqlite3"

module Content
  # Compiles content/ into the read-only content database (BUILD.md P3.3,
  # decision 26, docs/content-format.md). It reads the source register, every
  # text file, the works, the calendar and lectionary tables, and the image
  # registries; refuses anything docs/content-format.md §9 lists; and writes a
  # deterministic SQLite file: the same inputs give the same bytes.
  #
  # Uncleared sources are refused unless allow_pending is set, which the rake
  # task allows only for ALLOW_PENDING=1 outside production; then they are
  # warnings.
  class Compiler
    SCHEMA_VERSION = 1

    class Failed < StandardError
      attr_reader :problems

      def initialize(problems)
        @problems = problems
        super("the content did not compile:\n" + problems.map { "  - #{_1}" }.join("\n"))
      end
    end

    Result = Data.define(:output, :documents, :blocks, :verses, :sources, :warnings)

    TEXT_FOLDERS = %w[books scripture original quotations].freeze
    TABLE_FOLDERS = %w[calendar lectionary].freeze
    TOP_FILES = %w[SOURCES.md works.json images.json].freeze
    IMAGE_KEYS = %w[id path source creator date holder rights_basis status depicts_sacred_person].freeze

    attr_reader :problems, :warnings

    def initialize(root:, output:, territories:, allow_pending: false, design_registry: nil)
      @root = Pathname(root)
      @output = Pathname(output)
      @territories = Array(territories)
      @allow_pending = allow_pending
      @design_registry = design_registry && Pathname(design_registry)
      @problems = []
      @warnings = []
    end

    def compile!
      read_everything
      check_everything
      raise Failed, problems if problems.any?

      write
      Result.new(output: @output, documents: @files.size, blocks: @files.sum { _1.all_blocks.size },
        verses: @files.sum { _1.verses.size }, sources: @register.sources.size, warnings: warnings)
    end

    private
      # Reading

      def read_everything
        @register = SourceRegister.load(@root.join("SOURCES.md"))
        problems.concat(@register.problems)
        @works = read_json_list("works.json", %w[id title])
        @images = read_json_list("images.json", IMAGE_KEYS)
        @files = []
        @tables = []
        inputs.each do |path|
          relative = path.relative_path_from(@root).to_s
          folder = relative.split("/").first
          if TOP_FILES.include?(relative) || File.basename(relative).start_with?("README")
            next
          elsif TEXT_FOLDERS.include?(folder) && path.extname == ".txt"
            file = TextFile.load(path, relative)
            problems.concat(file.problems)
            @files << file if file.id
          elsif TABLE_FOLDERS.include?(folder) && path.extname == ".json"
            @tables << read_table(path, relative)
          else
            problem "#{relative}: not a place for content (docs/content-format.md §1)"
          end
        end
        @tables.compact!
      end

      def inputs
        @inputs ||= @root.glob("**/*").select(&:file?).sort
      end

      def read_json_list(name, keys)
        path = @root.join(name)
        return [] unless path.exist?

        list = JSON.parse(path.read)
        problem "#{name}: must be a list" and return [] unless list.is_a?(Array)
        list.each_with_index do |entry, index|
          missing = keys - entry.keys
          problem "#{name}: entry #{index + 1} is missing #{missing.join(", ")}" if missing.any?
        end
        duplicates(list.map { _1["id"] }).each { problem "#{name}: id #{_1} used twice" }
        list
      rescue JSON::ParserError => error
        problem "#{name}: #{error.message}"
        []
      end

      def read_table(path, relative)
        table = JSON.parse(path.read)
        missing = %w[id book source entries] - table.keys
        problem "#{relative}: missing #{missing.join(", ")}" and return if missing.any?
        problem "#{relative}: entries must be a list" and return unless table["entries"].is_a?(Array)
        table["entries"].each_with_index do |entry, index|
          problem "#{relative}: entry #{index + 1} has no page" if entry["page"].to_s.strip.empty?
        end
        table.merge("path" => relative)
      rescue JSON::ParserError => error
        problem "#{relative}: #{error.message}"
        nil
      end

      # Checking

      def check_everything
        duplicates(@files.map(&:id) + @tables.map { _1["id"] }).each { problem "document id #{_1} used twice" }
        block_ids = @files.flat_map { |file| file.all_blocks.map(&:id) }
        duplicates(block_ids + @files.map(&:id)).each { problem "block id #{_1} used twice" }
        @block_books = @files.flat_map { |file| file.all_blocks.map { [ _1.id, file.meta["book"] ] } }.to_h
        @document_books = @files.to_h { [ _1.id, _1.meta["book"] ] }
        @work_ids = @works.map { _1["id"] }.to_set

        @files.each { check_file(_1) }
        @tables.each { check_table(_1) }
        check_scripture_limits
        check_images
      end

      def check_file(file)
        label = file.path
        source = check_source(label, file.meta["source"])
        check_work(label, file.meta["work"])
        file.block_works.each_value { check_work(label, _1) }

        if file.liturgy?
          check_book(label, file.meta["book"], source)
          file.blocks.each { |block| block.problems.each { problem "#{label}: #{_1}" } }
          check_references(file)
        elsif file.scripture?
          check_scripture(file, source)
        elsif file.quotation?
          problem "#{label}: a quotation's source must be the quoted book (kind quotation)" if source && source.kind != "quotation"
        end
      end

      # A source must be registered and cleared for every served territory
      # (D14); reference and wanted sources are never served.
      def check_source(label, id)
        source = @register[id]
        return problem("#{label}: unknown source #{id}") && nil unless source
        return source if source.cleared_for?(@territories)

        message = "#{label}: source #{id} is #{source.status}, not cleared for #{@territories.join(", ")}"
        if @allow_pending && source.status.in?(%w[pending cleared])
          warnings << message
        else
          problem message
        end
        source
      end

      # The book guard (P3.4): a text is placed only in the book its printing
      # belongs to.
      def check_book(label, book, source)
        problem "#{label}: unknown prayer book #{book}" unless PrayerBook.ids.include?(book)
        return unless source

        problem "#{label}: source #{source.id} is not a printing" unless source.kind == "printing"
        if source.book && source.book != book
          problem "#{label}: printing #{source.id} belongs to #{source.book}, not #{book}"
        end
      end

      def check_work(label, work)
        problem "#{label}: unknown work #{work}" if work && !@work_ids.include?(work)
      end

      def check_references(file)
        book = file.meta["book"]
        file.all_blocks.each do |block|
          target =
            case block
            when LiturgicalBlock::GloriaPatri then block.full_text
            when LiturgicalBlock::CanticleReference then block.canticle
            end
          next unless target

          target_book = @block_books[target] || @document_books[target]
          if target_book.nil?
            problem "#{file.path}: #{block.id} refers to #{target}, which does not exist"
          elsif target_book != book
            problem "#{file.path}: #{block.id} refers to #{target} in another book (#{target_book})"
          end
        end
      end

      # The Scripture guard (P3.5): every passage names an accepted
      # translation, which its source is an edition of.
      def check_scripture(file, source)
        translation = file.meta["translation"]
        problem "#{file.path}: unknown translation #{translation}" unless Translation.find_by_id(translation)
        return unless source

        problem "#{file.path}: source #{source.id} is not a translation" unless source.kind == "translation"
        if source.translation && source.translation != translation
          problem "#{file.path}: source #{source.id} is the #{source.translation}, not the #{translation}"
        end
        if source["license"] == "permission"
          problem "#{file.path}: licensed source #{source.id} has no verse_limit" unless source.verse_limit
          problem "#{file.path}: licensed source #{source.id} has no notice" unless source.notice
        end
      end

      def check_scripture_limits
        @files.select(&:scripture?).group_by { _1.meta["source"] }.each do |id, files|
          source = @register[id]
          next unless source&.verse_limit

          count = files.sum { _1.verses.size }
          problem "source #{id}: #{count} verses, beyond its license's #{source.verse_limit}" if count > source.verse_limit
        end
      end

      def check_table(table)
        label = table["path"]
        source = check_source(label, table["source"])
        problem "#{label}: unknown prayer book #{table["book"]}" unless PrayerBook.ids.include?(table["book"])
        if source&.book && source.book != table["book"]
          problem "#{label}: source #{source.id} belongs to #{source.book}, not #{table["book"]}"
        end
      end

      # The image registries (P3.6): every image records its rights, and no
      # AI-generated image of Christ, Mary, or a saint is accepted.
      def check_images
        @images.each do |image|
          label = "images.json: #{image["id"]}"
          IMAGE_KEYS.each { problem "#{label}: #{_1} is empty" if image[_1].to_s.strip.empty? }
          check_source(label, image["source"]) if image["source"]
          problem "#{label}: an AI-generated image of a sacred person" if image["depicts_sacred_person"] && image["source_type"].to_s.match?(/AI/i)
        end
        return unless @design_registry&.exist?

        JSON.parse(@design_registry.read).fetch("assets").each do |asset|
          label = "#{@design_registry.basename}: #{asset["id"]}"
          (%w[id path source_type creator date holder rights_basis status depicts_sacred_person] - asset.keys).each do
            problem "#{label}: missing #{_1}"
          end
          if asset["depicts_sacred_person"] != false && asset["source_type"].to_s.match?(/AI/i)
            problem "#{label}: an AI-generated image must not depict a sacred person"
          end
        end
      end

      # Writing

      def write
        @output.dirname.mkpath
        temporary = @output.sub_ext(".tmp#{Process.pid}.sqlite3")
        temporary.delete if temporary.exist?
        database = SQLite3::Database.new(temporary.to_s)
        database.execute("PRAGMA page_size = 4096")
        database.execute("PRAGMA journal_mode = DELETE")
        database.transaction do
          SCHEMA.each { database.execute(_1) }
          write_meta(database)
          write_sources(database)
          write_works(database)
          write_documents(database)
          write_tables(database)
          write_images(database)
        end
        database.execute("INSERT INTO search(search) VALUES ('optimize')")
        database.execute("PRAGMA user_version = #{SCHEMA_VERSION}")
        database.execute("VACUUM")
        database.close
        File.rename(temporary, @output)
      ensure
        temporary&.delete if temporary&.exist?
      end

      SCHEMA = [
        "CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT NOT NULL)",
        "CREATE TABLE sources (id TEXT PRIMARY KEY, kind TEXT NOT NULL, title TEXT NOT NULL, book TEXT, translation TEXT,
          status TEXT NOT NULL, cleared_in TEXT NOT NULL, license TEXT NOT NULL, notice TEXT, acknowledge INTEGER NOT NULL,
          verse_limit TEXT, fields_json TEXT NOT NULL)",
        "CREATE TABLE books (id TEXT PRIMARY KEY, year INTEGER NOT NULL)",
        "CREATE TABLE works (id TEXT PRIMARY KEY, title TEXT NOT NULL)",
        "CREATE TABLE documents (id TEXT PRIMARY KEY, kind TEXT NOT NULL, title TEXT NOT NULL, source_id TEXT NOT NULL,
          book TEXT, printing TEXT, page TEXT, translation TEXT, bible_book TEXT, work TEXT, review TEXT, path TEXT NOT NULL,
          meta_json TEXT NOT NULL)",
        "CREATE TABLE blocks (id TEXT PRIMARY KEY, document_id TEXT NOT NULL, position INTEGER NOT NULL, parent_id TEXT,
          kind TEXT NOT NULL, book TEXT, printing TEXT, page TEXT, work TEXT, plain_text TEXT NOT NULL, data_json TEXT NOT NULL)",
        "CREATE INDEX blocks_by_document ON blocks (document_id, position)",
        "CREATE TABLE scripture_verses (document_id TEXT NOT NULL, translation TEXT NOT NULL, bible_book TEXT NOT NULL,
          chapter INTEGER NOT NULL, verse INTEGER NOT NULL, plain_text TEXT NOT NULL, data_json TEXT NOT NULL, notice TEXT,
          PRIMARY KEY (translation, bible_book, chapter, verse))",
        "CREATE TABLE fact_tables (id TEXT PRIMARY KEY, folder TEXT NOT NULL, book TEXT NOT NULL, source_id TEXT NOT NULL,
          path TEXT NOT NULL, data_json TEXT NOT NULL)",
        "CREATE TABLE images (id TEXT PRIMARY KEY, path TEXT NOT NULL, source_id TEXT NOT NULL, data_json TEXT NOT NULL)",
        "CREATE VIRTUAL TABLE search USING fts5(title, body, target_id UNINDEXED, document_id UNINDEXED,
          book UNINDEXED, kind UNINDEXED, block_kind UNINDEXED, tokenize = 'unicode61 remove_diacritics 2')"
      ].freeze

      def write_meta(database)
        digest = Digest::SHA256.new
        inputs.each { digest << _1.relative_path_from(@root).to_s << "\0" << _1.binread << "\0" }
        { "schema_version" => SCHEMA_VERSION.to_s, "content_digest" => digest.hexdigest,
          "territories" => @territories.join(","), "pending_allowed" => @allow_pending.to_s }.each do |key, value|
          database.execute("INSERT INTO meta VALUES (?, ?)", [ key, value ])
        end
      end

      def write_sources(database)
        @register.sources.values.sort_by(&:id).each do |source|
          database.execute("INSERT INTO sources VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            [ source.id, source.kind, source.title, source.book, source.translation, source.status, source.cleared_in.join(","),
              source["license"], source.notice, source.acknowledge? ? 1 : 0, source["verse_limit"], JSON.generate(source.fields.sort.to_h) ])
        end
        PrayerBook.all.each { database.execute("INSERT INTO books VALUES (?, ?)", [ _1.id, _1.year ]) }
      end

      def write_works(database)
        @works.sort_by { _1["id"] }.each { database.execute("INSERT INTO works VALUES (?, ?)", [ _1["id"], _1["title"] ]) }
      end

      def write_documents(database)
        @files.sort_by(&:id).each do |file|
          meta = file.meta
          database.execute("INSERT INTO documents VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            [ file.id, file.kind, meta["title"], meta["source"], meta["book"], meta["printing"], meta["page"], meta["translation"],
              meta["bible_book"], meta["work"], meta["review"], file.path, JSON.generate(meta.sort.to_h) ])
          write_blocks(database, file)
          write_verses(database, file)
        end
      end

      def write_blocks(database, file)
        position = 0
        file.blocks.each do |block|
          rows = [ [ block, nil ] ]
          rows += block.options.flat_map(&:blocks).map { [ _1, block.id ] } if block.is_a?(LiturgicalBlock::Alternatives)
          rows.each do |each_block, parent|
            position += 1
            source = each_block.respond_to?(:source) ? each_block.source : nil
            database.execute("INSERT INTO blocks VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
              [ each_block.id, file.id, position, parent, each_block.kind, source&.book, source&.printing, source&.page,
                file.block_works[each_block.id], each_block.plain_text, JSON.generate(each_block.to_h) ])
            next if each_block.is_a?(LiturgicalBlock::Alternatives)

            database.execute("INSERT INTO search (title, body, target_id, document_id, book, kind, block_kind) VALUES (?, ?, ?, ?, ?, ?, ?)",
              [ file.meta["title"], each_block.plain_text, each_block.id, file.id, file.meta["book"], file.kind, each_block.kind ])
          end
        end
      end

      def write_verses(database, file)
        return unless file.scripture?

        notice = @register[file.meta["source"]]&.notice
        file.verses.each do |verse|
          database.execute("INSERT INTO scripture_verses VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            [ file.id, file.meta["translation"], file.meta["bible_book"], verse.chapter, verse.verse, verse.plain_text,
              JSON.generate(LiturgicalBlock::Inline.to_h(verse.text)), notice ])
          database.execute("INSERT INTO search (title, body, target_id, document_id, book, kind, block_kind) VALUES (?, ?, ?, ?, ?, ?, ?)",
            [ file.meta["title"], verse.plain_text, "#{file.id}.#{verse.chapter}.#{verse.verse}", file.id, nil, "scripture", "verse" ])
        end
      rescue SQLite3::ConstraintException
        problem "#{file.path}: a verse is given twice"
        raise Failed, problems
      end

      def write_tables(database)
        @tables.sort_by { _1["id"] }.each do |table|
          database.execute("INSERT INTO fact_tables VALUES (?, ?, ?, ?, ?, ?)",
            [ table["id"], table["path"].split("/").first, table["book"], table["source"], table["path"],
              JSON.generate(table.except("path")) ])
        end
      end

      def write_images(database)
        @images.sort_by { _1["id"] }.each do |image|
          database.execute("INSERT INTO images VALUES (?, ?, ?, ?)", [ image["id"], image["path"], image["source"], JSON.generate(image) ])
        end
      end

      def duplicates(list) = list.compact.tally.select { |_, count| count > 1 }.keys

      def problem(message)
        problems << message
        true
      end
  end
end
