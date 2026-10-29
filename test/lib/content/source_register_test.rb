require "test_helper"

# content/SOURCES.md's schema (BUILD.md P3.1).
class Content::SourceRegisterTest < ActiveSupport::TestCase
  ENTRY = <<~SOURCE
    id: a-source
    kind: printing
    book: bcp1662
    title: [A]
    obtained_from: x
    jurisdiction: x
    rights_us: x
    rights_uk: x
    rights_elsewhere: x
    license: public-domain
    ai_use: yes; x
    status: cleared
    cleared_in: US
    checked: x
  SOURCE

  test "the repository's register has no problems" do
    register = Content::SourceRegister.load(Rails.root.join("content/SOURCES.md"))
    assert_empty register.problems
    assert register["cardo"].cleared_for?(%w[US UK])
    assert_not register["bcp1662-candidate"].cleared_for?(%w[US])
  end

  test "an entry is read, and clearance is per territory" do
    source = register(ENTRY)["a-source"]
    assert source.cleared_for?(%w[US])
    assert_not source.cleared_for?(%w[US UK])
  end

  test "missing and unknown keys, bad values, and duplicates are problems" do
    assert_match(/missing checked/, register(ENTRY.sub("checked: x\n", "")).problems.join)
    assert_match(/unknown key colour/, register(ENTRY + "colour: red\n").problems.join)
    assert_match(/unknown status maybe/, register(ENTRY.sub("status: cleared", "status: maybe")).problems.join)
    assert_match(/names no territory/, register(ENTRY.sub("cleared_in: US\n", "")).problems.join)
    assert_match(/a printing names its book/, register(ENTRY.sub("book: bcp1662\n", "")).problems.join)
    assert_match(/id used twice/, Content::SourceRegister.new("```source\n#{ENTRY}```\n```source\n#{ENTRY}```\n").problems.join)
  end

  private
    def register(entry) = Content::SourceRegister.new("```source\n#{entry}```\n")
end
