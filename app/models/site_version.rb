# The running version, shown in Settings (BUILD.md P2.12): the deployed
# commit, which bin/deploy writes to REVISION in each release (P5.2). In
# development and test, where there is no REVISION, it is the checkout's own
# commit; anywhere else without one, "unknown".
module SiteVersion
  REVISION = Rails.root.join("REVISION")

  def self.current
    @current ||= revision_file || checkout_commit || "unknown"
  end

  def self.revision_file
    REVISION.read.strip.presence if REVISION.exist?
  end

  def self.checkout_commit
    return unless Rails.env.local?

    commit = IO.popen([ "git", "-C", Rails.root.to_s, "rev-parse", "--short=12", "HEAD" ], err: File::NULL, &:read).strip
    commit.presence if $?.success?
  rescue SystemCallError
    nil
  end
end
