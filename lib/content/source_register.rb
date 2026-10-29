module Content
  # The register of sources, content/SOURCES.md (BUILD.md P3.1). Each source
  # is a fenced block with the info string "source" holding "key: value"
  # lines; the prose around the blocks is evidence for people and is not
  # read. The schema is documented at the top of SOURCES.md.
  class SourceRegister
    KINDS = %w[printing translation font image dataset quotation original code reference].freeze
    STATUSES = %w[wanted pending cleared reference refused].freeze
    LICENSES = %w[public-domain open permission none not-applicable].freeze
    AI_USES = %w[yes no not-applicable].freeze
    REQUIRED = %w[id kind title obtained_from jurisdiction rights_us rights_uk rights_elsewhere license ai_use status checked].freeze
    OPTIONAL = %w[book translation printing year publisher cleared_in notice verse_limit acknowledge].freeze
    ID = /\A[a-z0-9]+(?:[-.][a-z0-9]+)*\z/

    # One entry. `cleared_in` is a list of territories; "all" clears every one.
    Source = Data.define(:id, :kind, :title, :status, :cleared_in, :fields) do
      def [](key) = fields[key.to_s]
      def book = self[:book]
      def translation = self[:translation]
      def notice = self[:notice]
      def acknowledge? = self[:acknowledge] == "yes"

      def verse_limit
        value = self[:verse_limit]
        value == "none" ? Float::INFINITY : value&.to_i
      end

      def cleared_for?(territories)
        status == "cleared" && (cleared_in.include?("all") || (Array(territories) - cleared_in).empty?)
      end
    end

    attr_reader :sources, :problems

    def self.load(path) = new(File.read(path), path: path.to_s)

    def initialize(text, path: "SOURCES.md")
      @path = path
      @problems = []
      @sources = {}
      parse(text)
    end

    def [](id) = sources[id]
    def each(&) = sources.each_value(&)

    private
      def parse(text)
        text.scan(/^```source\n(.*?)^```$/m).each_with_index do |(body), index|
          fields = {}
          body.each_line(chomp: true) do |line|
            next if line.strip.empty?
            key, value = line.split(":", 2).map(&:strip)
            if value.nil? || value.empty?
              problem "source block #{index + 1}: line without a value: #{line}"
            elsif fields.key?(key)
              problem "source block #{index + 1}: #{key} given twice"
            else
              fields[key] = value
            end
          end
          add(fields, index + 1)
        end
      end

      def add(fields, number)
        label = fields["id"] || "source block #{number}"
        (REQUIRED - fields.keys).each { problem "#{label}: missing #{_1}" }
        (fields.keys - REQUIRED - OPTIONAL).each { problem "#{label}: unknown key #{_1}" }
        return unless fields["id"]

        problem "#{label}: id is not lower case with hyphens" unless fields["id"].match?(ID)
        problem "#{label}: id used twice" if sources.key?(fields["id"])
        problem "#{label}: unknown kind #{fields["kind"]}" unless KINDS.include?(fields["kind"])
        problem "#{label}: unknown status #{fields["status"]}" unless STATUSES.include?(fields["status"])
        problem "#{label}: unknown license #{fields["license"]}" unless LICENSES.include?(fields["license"])
        problem "#{label}: ai_use must begin yes, no, or not-applicable" unless AI_USES.include?(fields["ai_use"].to_s.split(";").first)
        problem "#{label}: a printing names its book" if fields["kind"] == "printing" && fields["book"].nil?
        problem "#{label}: a translation names its translation id" if fields["kind"] == "translation" && fields["translation"].nil?

        cleared_in = fields["cleared_in"].to_s.split(",").map(&:strip).reject(&:empty?)
        if fields["status"] == "cleared"
          problem "#{label}: cleared, but cleared_in names no territory" if cleared_in.empty?
        elsif cleared_in.any?
          problem "#{label}: cleared_in given, but the status is #{fields["status"]}"
        end
        if fields["verse_limit"] && !fields["verse_limit"].match?(/\A(\d+|none)\z/)
          problem "#{label}: verse_limit must be a number or none"
        end

        sources[fields["id"]] = Source.new(id: fields["id"], kind: fields["kind"], title: fields["title"],
          status: fields["status"], cleared_in: cleared_in, fields: fields.freeze)
      end

      def problem(message) = @problems << "#{@path}: #{message}"
  end
end
