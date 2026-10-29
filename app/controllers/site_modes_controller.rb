# The footer's "Use the phone site" and "Use the full site" buttons. A plain
# form post, so it works without JavaScript.
class SiteModesController < ApplicationController
  def update
    mode = params[:mode]

    if mode.in?(SiteMode::MODES)
      cookies.permanent[SiteMode::COOKIE] = { value: mode, httponly: true, same_site: :lax }
    else
      cookies.delete(SiteMode::COOKIE)
    end

    redirect_back_or_to root_path, status: :see_other
  end
end
