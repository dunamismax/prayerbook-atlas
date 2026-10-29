#!/usr/bin/env bash
# Nightly backup of the app's databases (BUILD.md P5.5, docs/deploy.md §7).
# Run by prayerbookatlas-backup.service as root, inside the server's shared
# deploy lock, from the live release:
#
#   with-deploy-lock bash /srv/www/prayerbookatlas.com/current/deploy/backup.sh
#
# Copies every database in shared/storage with SQLite's online backup (as the
# service user, so nothing in storage changes owner), checks each copy, and
# writes a manifest and the live commit beside them. The archive is kept in
# /var/backups/prayerbookatlas for 30 days, readable by root and the owner's
# group only, like the other sites' archives; the server's ubuntu-vm-backup job carries the newest one off the
# server each morning, encrypted, to its private repository. The content
# database is not backed up: every deploy rebuilds it from this repository.
set -Eeuo pipefail
umask 077

test "$(id -u)" = 0 || { echo "backup: run as root" >&2; exit 1; }
test "$(readlink /proc/$$/fd/9 2>/dev/null)" = /run/astro-deploy/lock || { echo "backup: run under /usr/local/sbin/with-deploy-lock" >&2; exit 1; }
flock -n 9

name=prayerbookatlas
base=/srv/www/prayerbookatlas.com
release=$(readlink -f "$base/current")
destination=/var/backups/$name
ruby_version=$(tr -d '[:space:]' < "$release/.ruby-version")
ruby_bin=/opt/mise/installs/ruby/${ruby_version#ruby-}/bin

install -d -o root -g sawyer -m 0750 "$destination"
# The copies are made in the service user's scratch space, which it can write
# and nobody else can read, and removed when the archive is made.
work=$(mktemp -d "$base/shared/tmp/backup.XXXXXXXX")
trap 'rm -rf -- "$work"' EXIT
chown "$name:$name" "$work"
install -d -o "$name" -g "$name" -m 0700 "$work/databases"

stamp=$(date -u +%Y%m%dT%H%M%SZ)
runuser -u "$name" -- env -i PATH="$ruby_bin:/usr/bin:/bin" HOME=/nonexistent \
  BUNDLE_GEMFILE="$release/Gemfile" BUNDLE_USER_HOME="$base/shared/tmp/bundle" \
  "$ruby_bin/bundle" exec ruby "$release/deploy/backup_databases.rb" copy "$base/shared/storage" "$work/databases" \
  > "$work/manifest.txt"
printf '%s\n' "$(cat "$release/REVISION")" > "$work/revision.txt"

archive=$name-$stamp.tar.gz
tar -czf "$destination/.$archive.partial" -C "$work" manifest.txt revision.txt databases
mv "$destination/.$archive.partial" "$destination/$archive"
cd "$destination"
sha256sum "$archive" > "$archive.sha256"
chown root:sawyer "$archive" "$archive.sha256"
chmod 0640 "$archive" "$archive.sha256"
find "$destination" -maxdepth 1 -type f -name "$name-*.tar.gz*" -mtime +30 -delete
printf 'backup: %s/%s (%s databases)\n' "$destination" "$archive" "$(wc -l < "$work/manifest.txt")"
