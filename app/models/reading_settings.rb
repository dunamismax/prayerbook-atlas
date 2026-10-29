# The person's reading settings (BUILD.md P2.10): text size, line spacing,
# rubrics in colour or in italic, rubrics shown or hidden, page numbers shown
# or hidden, keeping the screen awake while praying, and original or
# modernized spelling for the historic books. They live in one preference
# cookie and the server writes them as data attributes on <html>, so they
# work without script and never flash. Only choices that differ from the
# defaults are stored or written.
class ReadingSettings
  # The first value of each is the default.
  OPTIONS = {
    "text_size" => %w[standard smaller larger largest],
    "line_spacing" => %w[standard compact relaxed],
    "rubrics" => %w[colour italic],
    "show_rubrics" => %w[yes no],
    "page_numbers" => %w[shown hidden],
    "keep_awake" => %w[no yes],
    "spelling" => %w[original modernized]
  }.freeze

  DEFAULTS = OPTIONS.transform_values(&:first).freeze

  # The cookie holds "key:value" pairs joined by commas, e.g.
  # "text_size:larger,rubrics:italic".
  def self.from_cookie(value)
    new(value.to_s.split(",").filter_map { _1.split(":", 2) if _1.include?(":") }.to_h)
  end

  def initialize(values = {})
    @values = DEFAULTS.merge(values.to_h.stringify_keys.select { |key, value| OPTIONS[key]&.include?(value) })
  end

  def [](key)
    @values.fetch(key.to_s)
  end

  def changed
    @values.reject { |key, value| DEFAULTS[key] == value }
  end

  def to_cookie
    changed.map { |key, value| "#{key}:#{value}" }.join(",")
  end

  # The data attributes for <html>: { text_size: "larger" } becomes data-text-size.
  def html_data
    changed.transform_keys(&:to_sym)
  end
end
