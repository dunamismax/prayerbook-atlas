# Search (BUILD.md P3.9). A plain GET form that works without JavaScript; on
# the full site the field is also in the masthead and the filters sit in the
# contents column, and on the phone the filters fold under the field.
class SearchesController < ApplicationController
  def show
    @search = Content::Search.new(query: params[:q], book: params[:book], kind: params[:kind])
  end
end
