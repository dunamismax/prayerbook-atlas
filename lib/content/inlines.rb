module Content
  # The inline marks of the content format (docs/content-format.md §5):
  # {i|…}, {sc|…}, {name|N.} and the other insertion points, {br},
  # {page|5}, and {{ }} for literal braces. Parses a string into
  # LiturgicalBlock::Inline values; marks do not nest.
  module Inlines
    TOKEN = /\{\{|\}\}|\{([a-z]+)(?:\|([^{}]*))?\}|[^{}]+|[{}]/

    # Returns [inlines, problems].
    def self.parse(string)
      inlines = []
      problems = []
      string.scan(TOKEN) do
        token = Regexp.last_match[0]
        tag, value = Regexp.last_match[1], Regexp.last_match[2]
        inline =
          if token == "{{" then LiturgicalBlock::Inline::Text.new(text: "{")
          elsif token == "}}" then LiturgicalBlock::Inline::Text.new(text: "}")
          elsif token.in?(%w[{ }]) then problems << "unmatched brace in #{string.inspect}" and next
          elsif tag.nil? then LiturgicalBlock::Inline::Text.new(text: token)
          else mark(tag, value, string, problems)
          end
        append(inlines, inline) if inline
      end
      [ inlines, problems ]
    end

    def self.mark(tag, value, string, problems)
      case tag
      when "i" then LiturgicalBlock::Inline::Italic.new(text: value.to_s)
      when "sc" then LiturgicalBlock::Inline::SmallCaps.new(text: value.to_s)
      when "br" then LiturgicalBlock::Inline::LineBreak.new
      when "page" then LiturgicalBlock::Inline::PageBreak.new(page: value.to_s)
      when *LiturgicalBlock::INSERTION_KINDS then LiturgicalBlock::Inline::Insertion.new(kind: tag, printed: value.to_s)
      else problems << "unknown mark {#{tag}} in #{string.inspect}" and nil
      end.tap do |inline|
        problems << "empty mark {#{tag}} in #{string.inspect}" if inline && tag != "br" && value.to_s.empty?
      end
    end

    # Adjacent plain words join into one run.
    def self.append(inlines, inline)
      if inline.is_a?(LiturgicalBlock::Inline::Text) && inlines.last.is_a?(LiturgicalBlock::Inline::Text)
        inlines[-1] = LiturgicalBlock::Inline::Text.new(text: inlines.last.text + inline.text)
      else
        inlines << inline
      end
    end
    private_class_method :mark, :append
  end
end
