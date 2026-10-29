# The first-visit card's and Settings' choice of prayer book, and Settings'
# choices of another book for particular offices. Plain form posts; an
# unknown book or office changes nothing. Returns the person where they were.
class BookPreferencesController < ApplicationController
  def update
    if params[:book].in?(PrayerBook.ids)
      cookies.permanent[BookPreference::COOKIE] = { value: params[:book], httponly: true, same_site: :lax }
    end

    if params[:office_books].respond_to?(:to_unsafe_h)
      overrides = self.class.parse_office_books(params[:office_books].permit(*Office::SLUGS).to_h.map { _1.join(":") }.join(","))
      if overrides.any?
        cookies.permanent[BookPreference::OFFICE_COOKIE] = { value: overrides.map { _1.join(":") }.join(","), httponly: true, same_site: :lax }
      else
        cookies.delete(BookPreference::OFFICE_COOKIE)
      end
    end

    redirect_back_or_to root_path, status: :see_other
  end
end
