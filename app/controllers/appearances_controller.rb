# Settings' Appearance form. A plain form post, so it works without
# JavaScript; it returns the person to the page they came from.
class AppearancesController < ApplicationController
  def update
    choice = params[:appearance]

    if choice.in?(%w[day night])
      cookies.permanent[AppearancePreference::COOKIE] = { value: choice, httponly: true, same_site: :lax }
    else
      cookies.delete(AppearancePreference::COOKIE)
    end

    redirect_back_or_to settings_path, status: :see_other
  end
end
