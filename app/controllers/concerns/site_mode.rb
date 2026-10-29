# Chooses the mode each page is drawn in (docs/product.md §1): the phone site
# for small-screen mobile browsers, and the full site for desktop and tablet
# browsers. The phone site renders the `+phone` variant of a layout or view
# where one exists and the shared template otherwise.
#
# A person may choose either mode from the footer of every page. The choice is
# kept in a first-party cookie that holds the word "phone" or "full" and
# nothing else (no identifier, no tracking); "automatic" deletes it.
module SiteMode
  extend ActiveSupport::Concern

  MODES = %w[phone full].freeze
  COOKIE = :site_mode

  # Phones, not tablets: iPadOS and Android tablets send no "Mobile" token.
  PHONE_USER_AGENT = /iPhone|iPod|Android.+Mobile|Windows Phone|BlackBerry|BB10|Opera Mini|Mobile.+Firefox|webOS/i

  included do
    before_action :choose_site_mode
    after_action :vary_on_site_mode
    helper_method :site_mode, :phone_site?, :site_mode_chosen?
  end

  class_methods do
    def detect_site_mode(user_agent:, mobile_hint:)
      return "phone" if mobile_hint == "?1"
      return "full" if mobile_hint == "?0"

      PHONE_USER_AGENT.match?(user_agent.to_s) ? "phone" : "full"
    end
  end

  private
    def choose_site_mode
      request.variant = :phone if phone_site?
    end

    def site_mode
      @site_mode ||= chosen_site_mode ||
        self.class.detect_site_mode(user_agent: request.user_agent, mobile_hint: request.headers["Sec-CH-UA-Mobile"])
    end

    def phone_site?
      site_mode == "phone"
    end

    def site_mode_chosen?
      chosen_site_mode.present?
    end

    def chosen_site_mode
      cookies[COOKIE].presence_in(MODES)
    end

    def vary_on_site_mode
      vary = response.headers["Vary"].to_s.split(/,\s*/)
      response.headers["Vary"] = (vary | %w[Sec-CH-UA-Mobile User-Agent Cookie]).join(", ")
    end
end
