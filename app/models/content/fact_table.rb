# A calendar or lectionary table of facts (D20), as content/calendar/ and
# content/lectionary/ give it.
class Content::FactTable < ContentRecord
  self.table_name = "fact_tables"

  def data = JSON.parse(data_json)
  def entries = data.fetch("entries")
end
