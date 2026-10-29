class ApplicationController < ActionController::Base
  include SiteMode
  include AppearancePreference

  # Every browser is welcome: pages are semantic HTML that work without
  # JavaScript, so no browser is turned away (docs/decisions.md entry 25).

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
