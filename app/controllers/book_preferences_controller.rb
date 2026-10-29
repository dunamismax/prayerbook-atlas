# The first-visit card's and Settings' choice of prayer book. A plain form
# post; an unknown book changes nothing. Returns the person where they were.
class BookPreferencesController < ApplicationController
  def update
    if params[:book].in?(PrayerBook.ids)
      cookies.permanent[BookPreference::COOKIE] = { value: params[:book], httponly: true, same_site: :lax }
    end

    redirect_back_or_to root_path, status: :see_other
  end
end
