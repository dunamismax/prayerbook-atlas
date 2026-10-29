require "test_helper"

# The server files in deploy/ agree with the app and with each other
# (docs/deploy.md, BUILD.md P5.2).
class DeployFilesTest < ActiveSupport::TestCase
  DEPLOY = Rails.root.join("deploy")

  test "the service runs the Ruby that .ruby-version pins" do
    version = Rails.root.join(".ruby-version").read.strip.delete_prefix("ruby-")
    paths = DEPLOY.join("prayerbookatlas.service").read.scan(%r{/opt/mise/installs/ruby/([^/]+)/bin})
    assert_equal [ version ], paths.flatten.uniq
  end

  test "Caddy proxies to the port the service and cutover use" do
    port = DEPLOY.join("prayerbookatlas.service").read[/PORT=(\d+)/, 1]
    assert_equal port, DEPLOY.join("prayerbookatlas.caddy").read[/reverse_proxy 127\.0\.0\.1:(\d+)/, 1]
    assert_equal port, DEPLOY.join("cutover.sh").read[/^port=(\d+)/, 1]
    assert_equal port, DEPLOY.join("rollback.sh").read[/^port=(\d+)/, 1]
  end

  test "every other name redirects permanently to prayerbookatlas.com" do
    caddy = DEPLOY.join("prayerbookatlas.caddy").read
    redirects = caddy[/^(.+) \{\n\theader -Server\n\tredir https:\/\/prayerbookatlas\.com\{uri\} 308/, 1].split(", ")
    assert_equal %w[www.prayerbookatlas.com prayerbook-atlas.com www.prayerbook-atlas.com prayerbookatlas.org www.prayerbookatlas.org], redirects
  end

  test "production accepts the names Caddy may serve directly" do
    production = Rails.root.join("config/environments/production.rb").read
    assert_match(/config\.hosts = %w\[\s*prayerbookatlas\.com .*prayerbookatlas\.org /m, production)
  end
end
