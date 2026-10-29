# One verse of a cleared translation, with the notice its license requires
# (D5, BUILD.md P3.5).
class Content::ScriptureVerse < ContentRecord
  self.table_name = "scripture_verses"
  self.primary_key = %i[translation bible_book chapter verse]

  def text = LiturgicalBlock::Inline.from_h(JSON.parse(data_json))
end
