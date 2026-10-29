# The five sections (SiteSection). Each is a placeholder until the phases that
# build it (BUILD.md): it says plainly what will be there and that nothing is
# ready for prayer yet.
class SectionsController < ApplicationController
  before_action { @section = SiteSection.find(action_name) }

  def today
  end

  def pray
  end

  def bible
  end

  def kalendar
  end

  def atlas
  end
end
