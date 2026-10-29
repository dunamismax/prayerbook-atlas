# An entry of content/SOURCES.md, as compiled (BUILD.md P3.1, P3.7).
class Content::Source < ContentRecord
  self.table_name = "sources"

  STATUS_ORDER = %w[cleared pending reference wanted refused].freeze

  has_many :documents, class_name: "Content::Document", foreign_key: :source_id, inverse_of: :source

  scope :acknowledged, -> { where(acknowledge: 1).order(:title) }

  def fields = JSON.parse(fields_json)
  def territories = cleared_in.split(",")
end
