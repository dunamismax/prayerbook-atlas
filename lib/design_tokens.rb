require "json"

# Turns design/tokens.json into the CSS custom properties every stylesheet
# uses (docs/design.md). The generated file is committed so the site needs no
# build step; `bin/rails design:tokens` rewrites it, and DesignTokensTest fails
# when it no longer matches the tokens.
class DesignTokens
  SOURCE = Rails.root.join("design/tokens.json")
  OUTPUT = Rails.root.join("app/assets/stylesheets/tokens.css")
  ROOT_PX = 16.0

  def self.write
    OUTPUT.write(new.css)
  end

  def self.current?
    OUTPUT.exist? && OUTPUT.read == new.css
  end

  def initialize(tokens = JSON.parse(SOURCE.read))
    @tokens = tokens
  end

  def css
    <<~CSS
      /*
       * Generated from design/tokens.json by `bin/rails design:tokens`.
       * Do not edit by hand: change the tokens, regenerate, and commit both.
       */

      :root {
        color-scheme: light dark;
      #{declarations(:day)}

      #{type_declarations}

      #{length_declarations("space")}
      }

      @media (prefers-color-scheme: dark) {
        :root:not([data-appearance="day"]) {
      #{declarations(:night, indent: 4)}
        }
      }

      :root[data-appearance="day"] {
        color-scheme: light;
      }

      :root[data-appearance="night"] {
        color-scheme: dark;
      #{declarations(:night)}
      }
    CSS
  end

  private
    def declarations(appearance, indent: 2)
      colors = @tokens.fetch("color").map { |name, value| [ name, value.fetch(appearance.to_s) ] }
      ribbons = @tokens.fetch("ribbon").filter_map do |name, value|
        [ "ribbon-#{name}", value.fetch(appearance.to_s) ] if value.is_a?(Hash)
      end
      (colors + ribbons).map { |name, value| "#{" " * indent}--#{kebab(name)}: #{value.downcase};" }.join("\n")
    end

    def type_declarations
      @tokens.fetch("type").flat_map do |style, spec|
        lines = []
        lines << "  --type-#{kebab(style)}-size: #{rem(spec["size"])};" if spec["size"]
        lines << "  --type-#{kebab(style)}-leading: #{spec["leading"]};" if spec["leading"]
        lines << "  --type-#{kebab(style)}-tracking: #{spec["tracking"]};" if spec["tracking"]
        lines
      end.join("\n")
    end

    def length_declarations(group)
      @tokens.fetch(group).filter_map do |name, px|
        "  --#{group}-#{kebab(name)}: #{rem(px)};" if px.is_a?(Numeric)
      end.join("\n")
    end

    def rem(px)
      value = (px / ROOT_PX).round(4)
      "#{value.to_s.delete_suffix(".0")}rem"
    end

    def kebab(name)
      name.to_s.gsub(/([a-z])([A-Z])/, '\1-\2').downcase
    end
end
