require "test_helper"

# The post-deploy check (BUILD.md P5.6), against a stand-in for the network:
# a healthy site passes, and each kind of fault is caught.
class SiteCheckTest < ActiveSupport::TestCase
  HEADERS = {
    "content-security-policy" => "default-src 'self'; frame-ancestors 'none'; object-src 'none'; script-src 'self' 'nonce-x'",
    "strict-transport-security" => "max-age=63072000; includeSubDomains",
    "x-content-type-options" => "nosniff",
    "referrer-policy" => "strict-origin-when-cross-origin",
    "feature-policy" => "camera 'none'",
    "vary" => "Accept, Sec-CH-UA-Mobile, User-Agent, Cookie",
    "set-cookie" => "_session=x; path=/; secure; httponly; samesite=lax"
  }.freeze

  def page(mode, extra = "")
    %(<html><head><link rel="stylesheet" href="/assets/a-1.css"><script type="importmap">{"imports":{"app":"/assets/app-1.js"}}</script>#{extra}</head>) +
      %(<body class="site site--#{mode}"><a href="https://graceandfootnotes.com">a link out is fine</a></body></html>)
  end

  # A healthy site; `faults` replaces responses by URL.
  def site(faults = {}, page_extra: "")
    lambda do |url, headers|
      next faults[url] if faults.key?(url)

      uri = URI(url)
      mode = headers["User-Agent"] == SiteCheck::PHONE ? "phone" : "full"
      if uri.host != SiteCheck::CANONICAL
        SiteCheck::Response.new(status: 308, headers: { "location" => "https://#{SiteCheck::CANONICAL}#{uri.request_uri}" }, body: "")
      elsif uri.scheme == "http"
        SiteCheck::Response.new(status: 308, headers: { "location" => "https://#{uri.host}#{uri.request_uri}" }, body: "")
      elsif uri.path.start_with?("/assets/")
        SiteCheck::Response.new(status: 200, headers: { "cache-control" => "public, max-age=31536000, immutable" }, body: "body { background: url(/assets/paper-1.png) }")
      else
        SiteCheck::Response.new(status: 200, headers: HEADERS, body: page(mode, page_extra))
      end
    end
  end

  def tls(version: "TLSv1.3", days: 60)
    ->(_host) { SiteCheck::Tls.new(version: version, not_after: Time.utc(2026, 10, 29) + days * 86_400) }
  end

  def run_check(fetch: site, tls: self.tls) = SiteCheck.new(fetch: fetch, tls: tls, now: Time.utc(2026, 10, 29)).run

  test "a healthy site passes every check" do
    check = run_check
    assert check.ok?, check.failures.map { "#{_1.check}: #{_1.detail}" }.join("\n")
    assert_operator check.results.size, :>, 50
  end

  test "a remote script, stylesheet, font, or import is caught" do
    [ %(<script src="https://cdn.example.com/x.js"></script>), %(<link rel="stylesheet" href="//fonts.example.com/f.css">),
      %(<style>body{background:url("https://images.example.com/p.png")}</style>), %(<img srcset="/a.png 1x, https://x.example/b.png 2x">) ].each do |extra|
      check = run_check(fetch: site(page_extra: extra))
      assert_includes check.failures.map(&:check), "/ loads only from prayerbookatlas.com", extra
    end
  end

  test "a weakened header is caught" do
    weak = HEADERS.merge("content-security-policy" => "default-src 'self' https:; frame-ancestors 'none'; object-src 'none'")
    check = run_check(fetch: site({ "https://prayerbookatlas.com/" => SiteCheck::Response.new(status: 200, headers: weak, body: page("full")) }))
    assert_includes check.failures.map(&:check), "Content-Security-Policy"
    no_hsts = HEADERS.except("strict-transport-security")
    check = run_check(fetch: site({ "https://prayerbookatlas.com/" => SiteCheck::Response.new(status: 200, headers: no_hsts, body: page("full")) }))
    assert_includes check.failures.map(&:check), "Strict-Transport-Security"
  end

  test "a redirect that drops the path or is not permanent is caught" do
    check = run_check(fetch: site({ "https://prayerbookatlas.org/kalendar?check=1" =>
      SiteCheck::Response.new(status: 302, headers: { "location" => "https://prayerbookatlas.com/" }, body: "") }))
    assert_equal [ "https://prayerbookatlas.org" ], check.failures.map(&:check)
  end

  test "the wrong mode, a failing page, or a down site is caught" do
    check = run_check(fetch: site({ "https://prayerbookatlas.com/up" => SiteCheck::Response.new(status: 503, headers: {}, body: ""),
      "https://prayerbookatlas.com/pray" => SiteCheck::Response.new(status: 500, headers: {}, body: "") }))
    assert_includes check.failures.map(&:check), "/up"
    assert_includes check.failures.map(&:check), "/pray (full)"
  end

  test "an old TLS version or a certificate near expiry is caught" do
    assert_not run_check(tls: tls(version: "TLSv1.1")).ok?
    assert_not run_check(tls: tls(days: 5)).ok?
  end

  test "an asset without long-lived caching is caught" do
    check = run_check(fetch: site({ "https://prayerbookatlas.com/assets/a-1.css" => SiteCheck::Response.new(status: 200, headers: {}, body: "") }))
    assert_includes check.failures.map(&:check), "/assets/a-1.css is cached"
  end
end
