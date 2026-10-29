# One block of a document. A prayer book's block comes back as the
# LiturgicalBlock it was compiled from, with its book, printing, and page.
class Content::Block < ContentRecord
  self.table_name = "blocks"

  belongs_to :document, class_name: "Content::Document", inverse_of: :blocks

  scope :top_level, -> { where(parent_id: nil) }

  def data = JSON.parse(data_json)

  def liturgical_block
    LiturgicalBlock.from_h(data) if book
  end
end
