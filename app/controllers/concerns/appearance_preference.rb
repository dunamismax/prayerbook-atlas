# The person's choice of appearance (docs/design.md §9): Automatic follows
# the system, Day and Night hold one appearance. The server writes the choice
# on <html data-appearance> so a chosen appearance never flashes the other
# first, and no script is needed. The choice is a first-party cookie holding
# the word "day" or "night" and nothing else; Automatic deletes it.
module AppearancePreference
  extend ActiveSupport::Concern

  CHOICES = %w[automatic day night].freeze
  COOKIE = :appearance

  included do
    helper_method :appearance
  end

  private
    # "automatic", "day", or "night".
    def appearance
      cookies[COOKIE].presence_in(CHOICES - %w[automatic]) || "automatic"
    end
end
