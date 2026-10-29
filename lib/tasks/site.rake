namespace :site do
  desc "Check the live site: status, both modes, redirects, TLS, headers, assets, no loads from elsewhere (BUILD.md P5.6)"
  task check_live: :environment do
    check = SiteCheck.new.run
    # QUIET=1 (bin/deploy) prints only what failed.
    (ENV["QUIET"] ? check.failures : check.results).each { puts "#{_1.ok ? "ok  " : "FAIL"} #{_1.check}: #{_1.detail}" }
    puts check.ok? ? "The live site passed all #{check.results.size} checks." : "#{check.failures.size} of #{check.results.size} checks failed."
    exit 1 unless check.ok?
  end
end
