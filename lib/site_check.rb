require "net/http"
require "openssl"
require "json"

# The post-deploy check of the live site (BUILD.md P5.6, docs/deploy.md §8):
# status codes, both modes, the redirects from every other name, TLS, the
# security headers, cached assets, and that no page loads anything from
# another host. `bin/rails site:check_live` runs it; bin/deploy runs it after
# every deploy. The network is reached only through `fetch` and `tls`, so the
# tests can stand in for it.
class SiteCheck
  CANONICAL = "prayerbookatlas.com"
  ALIASES = %w[www.prayerbookatlas.com prayerbook-atlas.com www.prayerbook-atlas.com prayerbookatlas.org www.prayerbookatlas.org].freeze
  PAGES = %w[/ /pray /bible /kalendar /atlas /about /sources /settings /search?q=grace].freeze
  PHONE = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1"
  DESKTOP = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"
  CERTIFICATE_MARGIN = 14 * 24 * 60 * 60 # seconds: renewals are due long before

  Response = Data.define(:status, :headers, :body) do
    def [](name) = headers[name.downcase]
  end
  Tls = Data.define(:version, :not_after)
  Result = Data.define(:check, :ok, :detail)

  attr_reader :results

  def initialize(fetch: method(:http_fetch), tls: method(:tls_info), now: Time.now)
    @fetch = fetch
    @tls = tls
    @now = now
    @results = []
  end

  def run
    check_up
    check_pages
    check_headers
    check_redirects
    check_tls
    check_assets
    self
  end

  def ok? = results.all?(&:ok)
  def failures = results.reject(&:ok)

  private
    def record(check, ok, detail) = @results << Result.new(check: check, ok: ok ? true : false, detail: detail)

    def get(url, user_agent: DESKTOP) = @fetch.call(url, { "User-Agent" => user_agent })
    def canonical(path) = "https://#{CANONICAL}#{path}"

    def check_up
      response = get(canonical("/up"))
      record "/up", response.status == 200, "answers #{response.status}"
    end

    # Every page answers in both modes, and none loads anything from elsewhere.
    def check_pages
      PAGES.each do |path|
        { "full" => DESKTOP, "phone" => PHONE }.each do |mode, user_agent|
          response = get(canonical(path), user_agent: user_agent)
          record "#{path} (#{mode})", response.status == 200 && response.body.include?("site--#{mode}"),
            "answers #{response.status}#{" as the #{mode} site" if response.body.include?("site--#{mode}")}"
          next unless mode == "full" && response.status == 200

          foreign = foreign_loads(response.body)
          record "#{path} loads only from #{CANONICAL}", foreign.empty?, foreign.empty? ? "nothing from elsewhere" : foreign.join(", ")
        end
      end
    end

    def check_headers
      response = get(canonical("/"))
      csp = response["content-security-policy"].to_s
      directives = csp.split(";").to_h { |part| name, *values = part.split; [ name, values ] }
      record "Content-Security-Policy", directives["default-src"] == [ "'self'" ] && directives["frame-ancestors"] == [ "'none'" ] &&
        directives["object-src"] == [ "'none'" ] && !csp.match?(%r{https?:|\*|'unsafe-(inline|eval)'}), csp.presence || "missing"

      hsts = response["strict-transport-security"].to_s
      age = hsts[/max-age=(\d+)/, 1].to_i
      record "Strict-Transport-Security", age >= 31_536_000 && hsts.include?("includeSubDomains"), hsts.presence || "missing"
      record "X-Content-Type-Options", response["x-content-type-options"] == "nosniff", response["x-content-type-options"] || "missing"
      record "Referrer-Policy", response["referrer-policy"].present?, response["referrer-policy"] || "missing"
      policy = response["permissions-policy"] || response["feature-policy"]
      record "Permissions policy", policy.to_s.include?("camera 'none'") || policy.to_s.include?("camera=()"), policy || "missing"
      vary = response["vary"].to_s.split(",").map(&:strip)
      record "Vary", (%w[Sec-CH-UA-Mobile User-Agent Cookie] - vary).empty?, response["vary"] || "missing"
      record "No Server header", response["server"].nil?, response["server"] || "none sent"
      cookie = response["set-cookie"].to_s
      record "Cookies are secure", cookie.empty? || (cookie.include?("secure") && cookie.include?("httponly")),
        cookie.empty? ? "none set" : cookie.split(";").drop(1).map(&:strip).join("; ")
    end

    # Every other name, and plain HTTP, redirect permanently to the same path
    # and query on the canonical name.
    def check_redirects
      path = "/kalendar?check=1"
      ALIASES.each do |host|
        response = get("https://#{host}#{path}")
        record "https://#{host}", response.status == 308 && response["location"] == canonical(path),
          "#{response.status} to #{response["location"] || "nowhere"}"
      end
      ([ CANONICAL ] + ALIASES).each do |host|
        response = get("http://#{host}#{path}")
        record "http://#{host}", response.status == 308 && response["location"].in?([ "https://#{host}#{path}", canonical(path) ]),
          "#{response.status} to #{response["location"] || "nowhere"}"
      end
    end

    def check_tls
      ([ CANONICAL ] + ALIASES).each do |host|
        info = @tls.call(host)
        days = ((info.not_after - @now) / 86_400).floor
        record "TLS for #{host}", info.version.in?(%w[TLSv1.2 TLSv1.3]) && info.not_after - @now > CERTIFICATE_MARGIN,
          "#{info.version}, certificate valid for #{days} more days"
      rescue OpenSSL::SSL::SSLError, SystemCallError, SocketError => error
        record "TLS for #{host}", false, error.message
      end
    end

    # Fingerprinted assets are cached for good, and their stylesheets load
    # nothing from elsewhere either.
    def check_assets
      page = get(canonical("/"))
      stylesheets = Nokogiri::HTML(page.body).css("link[rel=stylesheet]").map { _1["href"] }
      record "Stylesheets found", stylesheets.any?, "#{stylesheets.size} on the home page"
      stylesheets.each do |href|
        response = get(canonical(href))
        record "#{href} is cached", response.status == 200 && response["cache-control"].to_s.include?("immutable"),
          "#{response.status}, #{response["cache-control"] || "no Cache-Control"}"
        foreign = response.body.scan(/url\(\s*['"]?([^'")]+)/).flatten.select { foreign_url?(_1) }
        record "#{href} loads only from #{CANONICAL}", foreign.empty?, foreign.empty? ? "nothing from elsewhere" : foreign.join(", ")
      end
    end

    LOADING = {
      "script" => %w[src], "link" => %w[href], "img" => %w[src srcset], "iframe" => %w[src], "frame" => %w[src],
      "source" => %w[src srcset], "audio" => %w[src], "video" => %w[src poster], "track" => %w[src],
      "object" => %w[data], "embed" => %w[src], "form" => %w[action], "use" => %w[href xlink:href], "image" => %w[href xlink:href]
    }.freeze

    # What a page would make the browser fetch from another host: element
    # sources, the import map, and inline style url()s. Links people follow
    # (<a href>) are not loads and may go anywhere.
    def foreign_loads(html)
      document = Nokogiri::HTML(html)
      urls = LOADING.flat_map do |element, attributes|
        document.css(element).flat_map { |node| attributes.flat_map { node[_1].to_s.split(",").map { it.strip.split.first } } }
      end
      document.css("script[type=importmap]").each do |node|
        JSON.parse(node.text).values.each { urls.concat(_1.is_a?(Hash) ? _1.values.grep(String) : []) }
      end
      urls.concat(html.scan(/url\(\s*['"]?([^'")]+)/).flatten)
      urls.compact.uniq.select { foreign_url?(_1) }
    end

    def foreign_url?(url)
      return true if url.start_with?("//")
      return false unless url.match?(%r{\A[a-z][a-z0-9+.-]*:}i)
      return false if url.start_with?("data:")

      URI.parse(url).host != CANONICAL
    rescue URI::InvalidURIError
      true
    end

    def http_fetch(url, headers)
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 10, read_timeout: 20) do |http|
        response = http.get(uri.request_uri, headers)
        Response.new(status: response.code.to_i, headers: response.each_header.to_h, body: response.body.to_s)
      end
    end

    def tls_info(host)
      context = OpenSSL::SSL::SSLContext.new
      context.set_params(verify_mode: OpenSSL::SSL::VERIFY_PEER)
      socket = TCPSocket.new(host, 443)
      ssl = OpenSSL::SSL::SSLSocket.new(socket, context)
      ssl.hostname = host
      ssl.sync_close = true
      ssl.connect
      ssl.post_connection_check(host)
      Tls.new(version: ssl.ssl_version, not_after: ssl.peer_cert.not_after)
    ensure
      ssl&.close || socket&.close
    end
end
