#!/usr/bin/env bash
# Restore drill (BUILD.md P5.5, docs/deploy.md §7): restore a backup into a
# scratch copy of the live release and boot it there, never touching the live
# databases. Run as root inside the server's shared deploy lock:
#
#   with-deploy-lock bash /srv/www/prayerbookatlas.com/current/deploy/restore_drill.sh [ARCHIVE]
#
# ARCHIVE defaults to the newest in /var/backups/prayerbookatlas; a copy
# decrypted from the ubuntu-vm-backup repository works the same way. It checks
# the archive's checksum (when its .sha256 is beside it), extracts it, checks
# every database against the manifest (integrity, SHA-256, row counts), boots
# the release on port 4396 with the restored databases, checks /up and three
# pages, and removes everything it made.
set -Eeuo pipefail
umask 077

test "$(id -u)" = 0 || { echo "drill: run as root" >&2; exit 1; }
test "$(readlink /proc/$$/fd/9 2>/dev/null)" = /run/astro-deploy/lock || { echo "drill: run under /usr/local/sbin/with-deploy-lock" >&2; exit 1; }
flock -n 9

name=prayerbookatlas
base=/srv/www/prayerbookatlas.com
release=$(readlink -f "$base/current")
archive=${1:-$(find /var/backups/$name -maxdepth 1 -name "$name-*.tar.gz" | sort | tail -n1)}
test -f "$archive" || { echo "drill: no archive to restore" >&2; exit 1; }
if test -f "$archive.sha256"; then (cd "$(dirname "$archive")" && sha256sum --quiet -c "$(basename "$archive").sha256"); fi
ruby_version=$(tr -d '[:space:]' < "$release/.ruby-version")
ruby_bin=/opt/mise/installs/ruby/${ruby_version#ruby-}/bin
port=4396
unit=$name-restore-drill

scratch=$(mktemp -d "$base/shared/tmp/restore-drill.XXXXXXXX")
cleanup() { systemctl stop "$unit" 2>/dev/null || true; rm -rf -- "$scratch"; }
trap cleanup EXIT
tar -xzf "$archive" -C "$scratch"
mkdir "$scratch/tmp"
chown -R "$name:$name" "$scratch"
echo "drill: $(basename "$archive"), taken from commit $(cut -c1-12 "$scratch/revision.txt")"

as_service() {
  systemd-run --quiet --collect --uid="$name" --gid="$name" \
    --property=EnvironmentFile="$base/shared/env" --property=UMask=0077 --property=NoNewPrivileges=true \
    --property=PrivateTmp=true --property=ProtectSystem=strict --property=ProtectHome=true \
    --property=ReadWritePaths="$scratch $base/shared/tmp" \
    --setenv=PATH="$ruby_bin:/usr/bin:/bin" --setenv=BUNDLE_USER_HOME="$base/shared/tmp/bundle" "$@"
}

# The databases as the manifest says they were.
as_service --wait --pipe --property=WorkingDirectory="$release" \
  "$ruby_bin/bundle" exec ruby deploy/backup_databases.rb verify "$scratch/databases" "$scratch/manifest.txt"

# The live release's files, with storage and tmp pointing into the scratch.
cp -a "$release" "$scratch/release"
rm "$scratch/release/storage" "$scratch/release/tmp"
ln -s "$scratch/databases" "$scratch/release/storage"
ln -s "$scratch/tmp" "$scratch/release/tmp"

as_service --unit="$unit" --property=WorkingDirectory="$scratch/release" \
  --setenv=RAILS_ENV=production --setenv=PORT="$port" "$ruby_bin/bundle" exec puma -C config/puma.rb
for path in /up / /settings /sources; do
  for _ in {1..60}; do
    if curl -fs -o /dev/null --max-time 5 -H "Host: prayerbookatlas.com" "http://127.0.0.1:$port$path"; then continue 2; fi
    sleep 0.5
  done
  echo "drill: the restored release did not answer $path" >&2
  exit 1
done
echo "drill: passed: the databases match the manifest, and the release booted on them and answered /up, /, /settings, and /sources"
