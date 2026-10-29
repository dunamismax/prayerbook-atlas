require "test_helper"

# Every interface string goes through Rails I18n (BUILD.md P2.13). This finds
# literal words left in the views: text between tags, words in labelling
# attributes, and capitalized or labelling string literals inside ERB. The
# development aids (/dev) and the generated PWA files are exempt: they are
# not the site's interface.
class UntranslatedTextTest < ActiveSupport::TestCase
  EXEMPT = %r{\Aapp/views/(dev|pwa)/|\Aapp/views/layouts/mailer}
  LABELLING = /\b(aria-label|title|alt|placeholder|content)="([^"<]*[A-Za-z][^"<]*)"/
  ALLOWED_ATTRIBUTES = [ "width=device-width,initial-scale=1,viewport-fit=cover", "light dark", "noindex, nofollow" ].freeze
  ERB_LITERALS = [
    /(?:\A|[\s(,])"([A-Z][^"#]*\s[^"#]*|[A-Z][a-z]+)"/, # "Save", "Go home"
    /(?:eyebrow\s*\(?\s*|label:\s*)"([^"#]+)"/ # eyebrow "welcome", label: "planned"
  ].freeze

  def views
    Rails.root.glob("app/views/**/*.erb").map { _1.relative_path_from(Rails.root).to_s }.grep_v(EXEMPT)
  end

  test "views hold no literal text between tags" do
    views.each do |path|
      markup = Rails.root.join(path).read.gsub(/<%#.*?%>/m, "").gsub(/<%.*?%>/m, "")
      text = markup.gsub(/<[^>]+>/m, " ").gsub(/&[a-z]+;|&#\d+;/, " ")
      assert_no_match(/[A-Za-z]{2,}/, text, "#{path} has literal text: #{text[/\S.{0,40}[A-Za-z]{2,}.{0,20}/]}")
    end
  end

  test "views hold no literal words in labelling attributes" do
    views.each do |path|
      Rails.root.join(path).read.gsub(/<%.*?%>/m, "").scan(LABELLING).each do |attribute, value|
        next if value.in?(ALLOWED_ATTRIBUTES)

        flunk "#{path} has a literal #{attribute}: #{value}"
      end
    end
  end

  test "views pass no literal words to helpers" do
    views.each do |path|
      Rails.root.join(path).read.scan(/<%=?(.*?)%>/m).flatten.each do |code|
        ERB_LITERALS.flat_map { code.scan(_1).flatten }.each { |literal| flunk "#{path} passes a literal string: #{literal}" }
      end
    end
  end

  test "every key the views name exists" do
    views.each do |path|
      scope = path.delete_prefix("app/views/").sub(/\..*\z/, "").sub(%r{(\A|/)_}, "\\1").tr("/", ".")
      Rails.root.join(path).read.scan(/\bt\("([a-z_.]+)"/).flatten.each do |key|
        key = "#{scope}#{key}" if key.start_with?(".")
        assert I18n.exists?(key, :en), "#{path} names a missing key #{key}"
      end
    end
  end
end
