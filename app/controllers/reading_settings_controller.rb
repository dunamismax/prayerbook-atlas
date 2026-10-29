# Settings' Reading form. A plain form post that keeps only the choices that
# differ from the defaults, and returns the person where they were.
class ReadingSettingsController < ApplicationController
  def update
    settings = ReadingSettings.new(params.permit(*ReadingSettings::OPTIONS.keys).to_h)

    if settings.changed.any?
      cookies.permanent[ReadingPreference::COOKIE] = { value: settings.to_cookie, httponly: true, same_site: :lax }
    else
      cookies.delete(ReadingPreference::COOKIE)
    end

    redirect_back_or_to settings_path, status: :see_other
  end
end
