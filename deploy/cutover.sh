#!/usr/bin/env bash
# Activate a candidate built by deploy/build.sh (docs/deploy.md). Run by
# bin/deploy as root, inside the server's shared deploy lock:
#
#   with-deploy-lock bash CANDIDATE/deploy/cutover.sh COMMIT CANDIDATE
#
# It moves the candidate into releases/, links the shared storage, migrates,
# boots the release on a spare port and checks it, installs this commit's
# systemd unit and Caddy site if they changed, switches `current`, restarts
# the service, and checks the live site. If any step fails it puts back the
# previous release, unit, and Caddy site, and exits non-zero.
set -Eeuo pipefail

# Returns rather than exits, so that after the trap is set a failure restores.
fail() { echo "cutover: $*" >&2; return 1; }

test "$(id -u)" = 0 || fail "run as root"
test "$(readlink /proc/$$/fd/9 2>/dev/null)" = /run/astro-deploy/lock || fail "run under /usr/local/sbin/with-deploy-lock"
flock -n 9

commit=${1:?usage: cutover.sh COMMIT CANDIDATE}
candidate=${2:?usage: cutover.sh COMMIT CANDIDATE}
[[ "$commit" =~ ^[0-9a-f]{40}$ ]] || fail "a full commit hash is required"

name=prayerbookatlas
service=$name.service
base=/srv/www/prayerbookatlas.com
shared=$base/shared
release=$base/releases/$commit
site=/etc/caddy/sites/$name.caddy
unit=/etc/systemd/system/$service
caddy=/usr/local/lib/caddy/caddy
port=4315
check_port=4395

test -f "$shared/env" || fail "$shared/env is missing (docs/deploy.md §2)"
test "$(stat -c '%U %a' "$shared/env")" = "root 600" || fail "$shared/env must be owned by root with mode 600"

# Provisioning that is safe to repeat.
id "$name" >/dev/null 2>&1 || useradd --system --user-group --home-dir /nonexistent --shell /usr/sbin/nologin "$name"
install -d -o root -g root -m 0755 "$base" "$base/releases" "$shared"
install -d -o "$name" -g "$name" -m 0750 "$shared/storage" "$shared/tmp"

previous=$(readlink -f "$base/current" 2>/dev/null || true)
if test "$previous" = "$release"; then
  rm -rf "$candidate"
  echo "cutover: ${commit:0:12} is already live"
  exit 0
fi

# Private copies of everything this transaction may change.
rollback=$(mktemp -d "/root/$name-rollback.XXXXXXXX")
chmod 0700 "$rollback"
printf '%s\n' "$previous" > "$rollback/previous"
cp -a /etc/caddy/Caddyfile "$rollback/Caddyfile"
if test -f "$site"; then cp -a "$site" "$rollback/site.caddy"; fi
if test -f "$unit"; then cp -a "$unit" "$rollback/app.service"; fi

fresh=0
check_unit=$name-release-check

recover() {
  local status=$?
  trap - ERR
  set +e
  echo "cutover: failed; restoring the previous state from $rollback" >&2
  systemctl stop "$check_unit" 2>/dev/null
  if test -f "$rollback/site.caddy"; then install -m 0644 "$rollback/site.caddy" "$site"; else rm -f "$site"; fi
  if test -f "$rollback/app.service"; then install -m 0644 "$rollback/app.service" "$unit"; else rm -f "$unit"; fi
  systemctl daemon-reload
  if test -n "$previous"; then
    ln -sfn "$previous" "$base/current.next" && mv -Tf "$base/current.next" "$base/current"
    systemctl restart "$service"
  else
    rm -f "$base/current"
    systemctl disable --now "$service" 2>/dev/null
  fi
  if runuser -u caddy -- "$caddy" validate --config /etc/caddy/Caddyfile >/dev/null 2>&1; then
    systemctl reload caddy
  else
    echo "cutover: the restored Caddy configuration does not validate; needs attention" >&2
  fi
  if test "$fresh" = 1; then rm -rf "$release"; fi
  echo "cutover: restored $(readlink -f "$base/current" 2>/dev/null || echo 'no release')" >&2
  exit "$status"
}
trap recover ERR

# Wait until a URL answers 2xx; extra arguments go to curl.
wait_for() {
  local url=$1; shift
  for _ in {1..60}; do
    if curl -fsS -o /dev/null --max-time 5 "$@" "$url" 2>/dev/null; then return 0; fi
    sleep 0.5
  done
  echo "cutover: $url did not answer" >&2
  return 1
}

if test -e "$release"; then
  # A release kept from an earlier deploy: switch back to it as it is.
  rm -rf "$candidate"
else
  test "$(cat "$candidate/REVISION")" = "$commit" || fail "the candidate is not $commit"
  mv "$candidate" "$release"
  fresh=1
  chown -R root:root "$release"
  chmod -R go-w "$release"
  ln -s "$shared/storage" "$release/storage"
  ln -s "$shared/tmp" "$release/tmp"
fi

ruby_version=$(tr -d '[:space:]' < "$release/.ruby-version")
ruby_bin=/opt/mise/installs/ruby/${ruby_version#ruby-}/bin
test -x "$ruby_bin/ruby" || fail "$ruby_version is not installed in /opt/mise"

# Run a command in the release as the service user, with only what it needs.
as_service() {
  systemd-run --quiet --collect --uid="$name" --gid="$name" \
    --property=EnvironmentFile="$shared/env" --property=WorkingDirectory="$release" \
    --property=UMask=0077 --property=NoNewPrivileges=true --property=PrivateTmp=true \
    --property=ProtectSystem=strict --property=ProtectHome=true \
    --property=ReadWritePaths="$shared/storage $shared/tmp" \
    --setenv=RAILS_ENV=production --setenv=PATH="$ruby_bin:/usr/bin:/bin" "$@"
}

as_service --wait --pipe bin/rails db:prepare

# Boot the release on a spare port, without Solid Queue, and check it.
systemctl stop "$check_unit" 2>/dev/null || true
as_service --unit="$check_unit" --setenv=PORT="$check_port" "$ruby_bin/bundle" exec puma -C config/puma.rb
wait_for "http://127.0.0.1:$check_port/up"
for path in / /settings /pray /about; do
  wait_for "http://127.0.0.1:$check_port$path" -H "Host: prayerbookatlas.com"
done
systemctl stop "$check_unit"

# This commit's Caddy site and unit, installed only when they changed.
site_changed=0
if ! cmp -s "$release/deploy/$name.caddy" "$site"; then
  install -m 0644 "$release/deploy/$name.caddy" "$site"
  site_changed=1
fi
if ! output=$(runuser -u caddy -- "$caddy" validate --config /etc/caddy/Caddyfile 2>&1); then
  echo "$output" >&2
  fail "caddy validate failed"
fi
if ! cmp -s "$release/deploy/$name.service" "$unit"; then
  install -m 0644 "$release/deploy/$name.service" "$unit"
  systemd-analyze verify "$unit"
  systemctl daemon-reload
fi
systemctl enable --quiet "$service"

# Switch, restart, and check.
ln -sfn "$release" "$base/current.next"
mv -Tf "$base/current.next" "$base/current"
systemctl restart "$service"
wait_for "http://127.0.0.1:$port/up"
if test "$site_changed" = 1; then systemctl reload caddy; fi
wait_for https://prayerbookatlas.com/up --resolve prayerbookatlas.com:443:127.0.0.1
wait_for https://prayerbookatlas.com/ --resolve prayerbookatlas.com:443:127.0.0.1
systemctl is-active --quiet "$service" caddy
trap - ERR

if test -n "$previous"; then printf '%s\n' "$previous" > "$base/previous"; fi

# Keep the newest five releases, and always the previous one.
ls -1t "$base/releases" | tail -n +6 | while read -r old; do
  if test "$base/releases/$old" != "$previous" && test "$base/releases/$old" != "$release"; then rm -rf "${base:?}/releases/$old"; fi
done
# Keep the last three rollback copies.
ls -1dt /root/$name-rollback.* | tail -n +4 | xargs -r rm -rf

echo "cutover: ${commit:0:12} is live (previous: ${previous:+$(basename "$previous" | cut -c1-12)})"
