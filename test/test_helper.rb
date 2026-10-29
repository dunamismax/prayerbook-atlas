ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# The pages read a content database compiled from fixture content: invented
# sources and bracketed placeholder words, never a real text (BUILD.md P3.7).
Content::Compiler.new(
  root: Rails.root.join("test/fixtures/files/content"),
  output: ContentRecord.database_path,
  territories: Rails.application.config_for(:content).fetch(:territories)
).compile!

# Browsers as the server sees them, for tests of both modes (SiteMode).
module UserAgents
  IPHONE = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 " \
    "(KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1"
  ANDROID_PHONE = "Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 " \
    "(KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36"
  ANDROID_TABLET = "Mozilla/5.0 (Linux; Android 15; SM-X910) AppleWebKit/537.36 " \
    "(KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"
  IPAD = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 " \
    "(KHTML, like Gecko) Version/18.6 Safari/605.1.15"
  DESKTOP_CHROME = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 " \
    "(KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Each worker's databases get a numbered name; the content database is
    # never rebuilt from a schema, so give each worker a copy of the compiled
    # fixture database.
    COMPILED_CONTENT = ContentRecord.database_path
    parallelize_setup { FileUtils.cp(COMPILED_CONTENT, ContentRecord.database_path) }

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
