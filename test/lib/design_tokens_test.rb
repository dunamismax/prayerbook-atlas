require "test_helper"

class DesignTokensTest < ActiveSupport::TestCase
  test "tokens.css is in step with design/tokens.json" do
    assert DesignTokens.current?, "Run bin/rails design:tokens and commit app/assets/stylesheets/tokens.css"
  end

  test "colours appear for both appearances" do
    css = DesignTokens.new.css
    assert_includes css, "--paper: #f3f1ea;"
    assert_includes css, "--paper: #0e131a;"
    assert_includes css, "--on-rubric: #f8f7f2;"
  end

  test "point sizes become rem at a 16-pixel root" do
    css = DesignTokens.new.css
    assert_includes css, "--type-reading-size: 1.25rem;"
    assert_includes css, "--space-reading-measure: 40rem;"
  end

  test "no stylesheet but tokens.css writes a raw colour" do
    Rails.root.glob("app/assets/stylesheets/*.css").each do |file|
      next if file == DesignTokens::OUTPUT

      assert_no_match(/#\h{3,8}\b|rgba?\(|hsla?\(/, file.read, "#{file.basename} has a raw colour; use a token")
    end
  end
end
