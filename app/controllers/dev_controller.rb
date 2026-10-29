# Development aids, routed only in development and test (config/routes.rb).
# The type specimen shows Cardo's features and the marks the prayer books
# use (BUILD.md P2.4); the component gallery shows every shared component
# (P2.5); the block sample sets every kind of LiturgicalBlock (P2.9). All are
# for checking in each browser and mode. Neither holds
# prayer-book text: every sample is the site's own words or a bracketed
# placeholder.
class DevController < ApplicationController
  def type
  end

  def components
  end

  # Every kind of LiturgicalBlock, in bracketed placeholders, across a page
  # break, for checking the renderer (P2.9).
  def liturgy
    @blocks = SampleBlocks.all
  end
end
