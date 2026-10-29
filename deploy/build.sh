#!/usr/bin/env bash
# Build a release candidate of one commit, unprivileged, outside the server's
# deploy lock (docs/deploy.md). Run by bin/deploy as the owner's login user
# from the server's clone, which must already be at the commit:
#
#   deploy/build.sh COMMIT
#
# Prints the candidate's path on its last line. The candidate holds the
# commit's files from `git archive` (never the checkout), REVISION, the gems
# in deployment mode, the precompiled assets, and the content database. It
# needs no secret: the master key is used only by cutover.sh, as the service
# user.
set -Eeuo pipefail

commit=${1:?usage: deploy/build.sh COMMIT}
[[ "$commit" =~ ^[0-9a-f]{40}$ ]] || { echo "build: a full commit hash is required" >&2; exit 64; }

clone=$(cd "$(dirname "$0")/.." && pwd)
test "$(git -C "$clone" rev-parse HEAD)" = "$commit" || { echo "build: the clone is not at $commit" >&2; exit 1; }

ruby_version=$(git -C "$clone" show "$commit:.ruby-version" | tr -d '[:space:]')
ruby_bin=/opt/mise/installs/ruby/${ruby_version#ruby-}/bin
test -x "$ruby_bin/ruby" || { echo "build: $ruby_version is not installed in /opt/mise" >&2; exit 1; }
export PATH="$ruby_bin:/usr/bin:/bin"

builds="$HOME/prayerbookatlas-build"
candidate="$builds/$commit"
mkdir -p "$builds"
rm -rf "$candidate"
mkdir "$candidate"
git -C "$clone" archive --format=tar "$commit" | tar -x -C "$candidate"
printf '%s\n' "$commit" > "$candidate/REVISION"

# Start from the live release's gems so only changed gems are installed.
current=/srv/www/prayerbookatlas.com/current
if test -d "$current/vendor/bundle"; then
  mkdir -p "$candidate/vendor"
  cp -a "$current/vendor/bundle" "$candidate/vendor/bundle"
fi

cd "$candidate"
export RAILS_ENV=production
bundle config set --local deployment true >/dev/null
bundle config set --local without "development test" >/dev/null
bundle config set --local path vendor/bundle >/dev/null
bundle install --quiet --jobs 4
bundle clean >/dev/null
SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile >/dev/null
# The read-only content database, with release checks: any uncleared source
# fails the build (BUILD.md P3.8, docs/content-format.md).
SECRET_KEY_BASE_DUMMY=1 bin/rails content:compile
# The release keeps no state: storage/ and tmp/ become links to shared/.
rm -rf storage tmp log
printf '%s\n' "$candidate"
