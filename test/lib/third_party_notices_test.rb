require "test_helper"

# Every file that ports The Daily Office 2019's code carries the header
# docs/dailyoffice2019.md §2 prescribes and is listed in THIRD_PARTY_NOTICES.md,
# which keeps the MIT notice (BUILD.md P2A.3).
class ThirdPartyNoticesTest < ActiveSupport::TestCase
  NOTICES = Rails.root.join("THIRD_PARTY_NOTICES.md")
  HEADER = /Adapted from The Daily Office 2019 \(MIT\), (?<source>\S+(?:, \S+)*) at (?<commit>\h{7,40})\./
  SEARCHED = %w[app bin config db deploy lib script test].freeze

  test "the notices keep the MIT copyright and permission notice" do
    text = NOTICES.read
    assert_includes text, "Copyright 2020 Benjamin Locher"
    assert_includes text, "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."
  end

  test "every file with the header is listed, and every listed file has it" do
    assert_equal files_with_header.keys.sort, listed_files.keys.sort
  end

  test "each listing names the same source and commit as the file's header" do
    expected = files_with_header.transform_values { "#{it[:source]} at #{it[:commit]}" }
    assert_equal expected, listed_files.slice(*expected.keys)
  end

  private
    def files_with_header
      SEARCHED.flat_map { Dir.glob(Rails.root.join(it, "**", "*")) }
        .select { File.file?(it) && File.extname(it).in?(%w[.rb .erb .js .css .rake .yml]) }
        .reject { it == __FILE__ }
        .filter_map do |file|
          header = File.foreach(file).first(5).join[HEADER]
          [ Pathname(file).relative_path_from(Rails.root).to_s, header.match(HEADER) ] if header
        end.to_h
    end

    # Lines of the form "- `path`: source file(s) at commit." under "Ported files".
    def listed_files
      NOTICES.read.scan(/^- `([^`]+)`: (.+?)\.$/).to_h
    end
end
