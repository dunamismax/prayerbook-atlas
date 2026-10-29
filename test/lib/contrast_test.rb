require "test_helper"

# Every text pair docs/design.md §3 lists meets WCAG 2 AA (4.5:1) in both
# appearances, recomputed from design/tokens.json with the WCAG relative
# luminance formula.
class ContrastTest < ActiveSupport::TestCase
  TEXT_PAIRS = [
    %w[ink paper], %w[ink card], %w[ink wash],
    %w[muted paper], %w[muted card], %w[muted wash],
    %w[rubric paper], %w[rubric card], %w[rubric wash],
    %w[onRubric rubric]
  ].freeze

  COLORS = JSON.parse(DesignTokens::SOURCE.read).fetch("color")

  %w[day night].each do |appearance|
    TEXT_PAIRS.each do |text, ground|
      test "#{text} on #{ground} by #{appearance} meets AA" do
        ratio = contrast(COLORS.dig(text, appearance), COLORS.dig(ground, appearance))
        assert_operator ratio, :>=, 4.5, "#{text} on #{ground} (#{appearance}) is #{ratio.round(2)}:1"
      end
    end
  end

  test "the ratios recorded in tokens.json match the colours" do
    recorded = JSON.parse(DesignTokens::SOURCE.read).fetch("contrast")
    %w[day night].each do |appearance|
      recorded.fetch(appearance).each do |pair, ratio|
        text, ground = pair.split("/")
        computed = contrast(COLORS.dig(text, appearance), COLORS.dig(ground, appearance))
        assert_in_delta ratio, computed, 0.01, "#{pair} (#{appearance})"
      end
    end
  end

  private
    def contrast(foreground, background)
      lighter, darker = [ luminance(foreground), luminance(background) ].sort.reverse
      (lighter + 0.05) / (darker + 0.05)
    end

    def luminance(hex)
      red, green, blue = hex.delete_prefix("#").scan(/../).map do |pair|
        channel = pair.to_i(16) / 255.0
        channel <= 0.04045 ? channel / 12.92 : ((channel + 0.055) / 1.055)**2.4
      end
      0.2126 * red + 0.7152 * green + 0.0722 * blue
    end
end
