# The read-only content database, compiled from content/ by
# `bin/rails content:compile` (BUILD.md P3.3, P3.7, decision 26). It is opened
# read-only: nothing is ever written to it at runtime, and a missing file is
# an error rather than a new empty database.
class ContentRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :content, reading: :content }

  def self.database_path
    Rails.root.join(ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: "content", include_hidden: true).database)
  end

  def self.present? = database_path.exist?

  def readonly? = true
end
