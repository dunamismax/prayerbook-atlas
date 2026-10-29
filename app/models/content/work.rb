# A work of the Atlas: the abstract prayer whose texts in each book are its
# witnesses (decision 12, BUILD.md P12.1).
class Content::Work < ContentRecord
  self.table_name = "works"

  has_many :documents, class_name: "Content::Document", foreign_key: :work, inverse_of: false
end
