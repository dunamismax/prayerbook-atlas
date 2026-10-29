#!/usr/bin/env bash
# Switch the live site back to an earlier release (docs/deploy.md). Run by
# `bin/deploy --rollback [COMMIT]` as root, inside the server's deploy lock:
#
#   with-deploy-lock bash /srv/www/prayerbookatlas.com/current/deploy/rollback.sh [COMMIT]
#
# Without a commit it switches to the release recorded in `previous`. It
# changes only the code that runs: migrations are not undone, and the
# installed systemd unit and Caddy site stay as they are. If the earlier
# release does not answer, it switches forward again.
set -Eeuo pipefail

fail() { echo "rollback: $*" >&2; exit 1; }

test "$(id -u)" = 0 || fail "run as root"
test "$(readlink /proc/$$/fd/9 2>/dev/null)" = /run/astro-deploy/lock || fail "run under /usr/local/sbin/with-deploy-lock"
flock -n 9

base=/srv/www/prayerbookatlas.com
service=prayerbookatlas.service
port=4315

current=$(readlink -f "$base/current")
if test -n "${1:-}"; then
  [[ "$1" =~ ^[0-9a-f]{40}$ ]] || fail "a full commit hash is required"
  target=$base/releases/$1
else
  test -s "$base/previous" || fail "no previous release is recorded"
  target=$(cat "$base/previous")
fi
test -d "$target" || fail "$target does not exist"
test "$target" != "$current" || fail "$(basename "$target" | cut -c1-12) is already live"

switch_to() {
  ln -sfn "$1" "$base/current.next"
  mv -Tf "$base/current.next" "$base/current"
  systemctl restart "$service"
  for _ in {1..60}; do
    if curl -fsS -o /dev/null --max-time 5 "http://127.0.0.1:$port/up" 2>/dev/null &&
      curl -fsS -o /dev/null --max-time 5 --resolve prayerbookatlas.com:443:127.0.0.1 https://prayerbookatlas.com/ 2>/dev/null; then
      return 0
    fi
    sleep 0.5
  done
  return 1
}

if switch_to "$target"; then
  printf '%s\n' "$current" > "$base/previous"
  echo "rollback: $(basename "$target" | cut -c1-12) is live (previous: $(basename "$current" | cut -c1-12))"
else
  echo "rollback: $(basename "$target" | cut -c1-12) did not answer; switching back" >&2
  switch_to "$current" || fail "$(basename "$current" | cut -c1-12) did not answer either; needs attention"
  exit 1
fi
