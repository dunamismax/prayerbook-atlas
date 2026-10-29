# One text file of content/ as compiled: an office, a prayer, a psalm, a
# chapter of Scripture, a note (docs/content-format.md §4).
class Content::Document < ContentRecord
  self.table_name = "documents"

  belongs_to :source, class_name: "Content::Source", inverse_of: :documents
  has_many :blocks, -> { order(:position) }, class_name: "Content::Block", inverse_of: :document

  def meta = JSON.parse(meta_json)
  def prayer_book = book && PrayerBook.find(book)
end
