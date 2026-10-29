# The sources page (BUILD.md P3.8, P20.5): the register of sources, read from
# the content database it was compiled into.
class SourcesController < ApplicationController
  def index
    @sources = Content::Source.order(:title).group_by(&:status)
      .sort_by { |status, _| Content::Source::STATUS_ORDER.index(status) }
  end
end
