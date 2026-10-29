# Makes the person's ReadingSettings available to every page and view.
module ReadingPreference
  extend ActiveSupport::Concern

  COOKIE = :reading

  included do
    helper_method :reading_settings
  end

  private
    def reading_settings
      @reading_settings ||= ReadingSettings.from_cookie(cookies[COOKIE])
    end
end
