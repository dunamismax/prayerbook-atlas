# Deploying prayerbookatlas.com

How the site is served from the owner's Ubuntu server, `ubuntu-vm` (BUILD.md D28,
docs/decisions.md entry 27). The owner approved the provisioning and the first deploy on
2026-10-29 (BUILD.md P5.3, P5.4). Changes to the server beyond `bin/deploy` (DNS, Caddy's main
file, other sites) are still the owner's to approve (AGENTS.md §4).

**The everyday loop:** run `bin/ci`, commit, `git push origin main`, then `bin/deploy`, and try
the change at <https://prayerbookatlas.com>.

## 1. The shape

```
Internet ─ Caddy (TLS, compression, redirects; the server's shared Caddy)
             │  prayerbookatlas.com  (/etc/caddy/sites/prayerbookatlas.caddy)
             ▼
           Puma on 127.0.0.1:4315  (systemd: prayerbookatlas.service, user prayerbookatlas)
             │  Rails 8.1, RAILS_ENV=production, Solid Queue inside Puma
             ├─ /srv/www/prayerbookatlas.com/shared/storage/   the app's SQLite databases
             └─ db/content.sqlite3 in each release              rebuilt from content/ (P3.3)
```

- **One canonical name**: `https://prayerbookatlas.com`. These redirect to it permanently
  (308, keeping the path): `www.prayerbookatlas.com`, `prayerbook-atlas.com`,
  `www.prayerbook-atlas.com`, `prayerbookatlas.org`, and `www.prayerbookatlas.org` (D12).
- **DNS** is at Cloudflare and is the owner's. Every name is an A record for the server's
  public address, **not proxied** (DNS only), like the owner's other sites; Caddy obtains the
  certificates itself. The server's Cloudflare DDNS job keeps every A record in the account
  pointed at the server, so these names follow it automatically.
- **Only a built release is served.** The clone, the repository, and `research/` are never a
  web root.

## 2. Where everything lives

The server already hosts the owner's other sites; this one follows their conventions (see
`/home/sawyer/github/AGENTS.md` and `ubuntu-vm-backup/docs/astro-migration.md` on the server).

| What | Where |
|---|---|
| The owner's clone (fast-forwarded by `bin/deploy`) | `/home/sawyer/github/prayerbook-atlas` (remote `git@github.com-dunamismax:…`) |
| Build candidates (owner's login user, no secrets) | `/home/sawyer/prayerbookatlas-build/<commit>` |
| Releases, one per commit, root-owned, read-only | `/srv/www/prayerbookatlas.com/releases/<commit>` |
| The live release | `/srv/www/prayerbookatlas.com/current` (a link) |
| The release to roll back to | `/srv/www/prayerbookatlas.com/previous` (a file naming it) |
| The app's databases (`storage/` in each release links here) | `/srv/www/prayerbookatlas.com/shared/storage` |
| Bootsnap and other scratch files (`tmp/` links here) | `/srv/www/prayerbookatlas.com/shared/tmp` |
| The secret: `RAILS_MASTER_KEY` only, root, mode 600 | `/srv/www/prayerbookatlas.com/shared/env` |
| Ruby (`.ruby-version`), installed by mise | `/opt/mise/installs/ruby/<version>`; mise is `/usr/local/bin/mise` |
| The service (from `deploy/prayerbookatlas.service`) | `/etc/systemd/system/prayerbookatlas.service` |
| The Caddy site (from `deploy/prayerbookatlas.caddy`) | `/etc/caddy/sites/prayerbookatlas.caddy`, imported by `/etc/caddy/Caddyfile` |
| Access log | `/var/log/caddy/prayerbookatlas-access.log` |
| Application log | the journal: `journalctl -u prayerbookatlas` |
| Rollback copies of the unit, the Caddy site, and the Caddyfile (last three) | `/root/prayerbookatlas-rollback.*` |

The unit and the Caddy site live in this repository under `deploy/` and are installed by each
deploy when they change; edit them here, never on the server. Ports 4311–4314 belong to the
owner's other sites; this site uses **4315**, and the release check during a deploy uses 4395.
The service runs as the system user `prayerbookatlas` (no login, no home) with systemd's
filesystem protections; it can write only `shared/storage` and `shared/tmp`.

## 3. Deploying: `bin/deploy`

From the Mac, after `bin/ci` passes and `main` is pushed:

```bash
bin/deploy
```

It deploys `origin/main` (it warns if the Mac's checkout differs, since only what is pushed is
deployed). Over `ssh root@ubuntu-vm` (Tailscale) it:

1. **Fast-forwards the clone** as `sawyer` (cloning it the first time) and checks that it is at
   the same commit.
2. **Installs Ruby** with mise if `.ruby-version` names one the server does not have yet.
3. **Builds a candidate** as `sawyer`, outside the lock (`deploy/build.sh`): the commit's files
   from `git archive`, `REVISION` (Settings shows it), `bundle install` in deployment mode
   (starting from the live release's gems), `assets:precompile`, and `content:compile`. It needs
   no secret.
4. **Activates it** as root inside the server's shared deploy lock,
   `/usr/local/sbin/with-deploy-lock` (`deploy/cutover.sh`): moves the candidate into
   `releases/`, links `storage/` and `tmp/`, runs `bin/rails db:prepare` as the service user,
   boots the release on port 4395 and checks `/up`, `/`, `/settings`, `/pray`, and `/about`,
   installs the unit and Caddy site if they changed (`caddy validate` first, every time),
   switches `current`, restarts the service, reloads Caddy if its site changed, and checks
   `https://prayerbookatlas.com/up` and `/`.
5. **Rolls back on failure.** If any step of the activation fails, it puts back the previous
   release, unit, and Caddy site, restarts, and exits non-zero. A failed release is removed.

It keeps the newest five releases (and always the previous one). Deploying a commit that is
already live changes nothing; deploying one whose release is still kept switches back to it.

**Rollback by hand:**

```bash
bin/deploy --rollback
```

switches to the release named in `previous` (or `bin/deploy --rollback <full commit>` to a kept
one), restarts, checks the site, and switches forward again if the older release does not
answer. It changes only the code that runs: migrations are not undone, and the installed unit
and Caddy site stay as they are, so a migration that an older release cannot run with needs a
forward fix instead. Run `bin/deploy` to return to `origin/main`.

**Content.** The build runs `bin/rails content:compile` with release checks (P3.8): a source
that is not `cleared` for the served territories fails the build, so it never reaches the
server. Each release carries its own read-only `db/content.sqlite3`, and the app refuses to boot
without it.

## 4. Provisioning (done 2026-10-29)

`deploy/cutover.sh` creates the `prayerbookatlas` user and the directories itself, so a fresh
server needs only these, as root:

- **Ruby through mise**, system-wide: mise from its official installer
  (`curl -fsSL https://mise.run`, run with `MISE_INSTALL_PATH=/usr/local/bin/mise`), then
  `bin/deploy` installs the pinned Ruby into `/opt/mise`. Precompiled Ruby needs no build
  tools; the gems' native extensions use `build-essential`, already installed.
- **The environment file**, from the owner's `config/master.key` (gitignored, on the Mac only),
  never printed, pasted, or committed:

  ```bash
  tr -d '\n' < config/master.key | ssh root@ubuntu-vm 'umask 077; key=$(cat); printf "RAILS_MASTER_KEY=%s\n" "$key" > /srv/www/prayerbookatlas.com/shared/env'
  ```

  Everything else the service needs (`RAILS_ENV`, `PORT`, `SOLID_QUEUE_IN_PUMA`,
  `RAILS_LOG_LEVEL`) is set in the unit, so the file holds only the secret.
- **DNS**: the six names as A records for the server, DNS only (§1).

Before the first install, `/etc/caddy` was archived to
`/root/caddy-backup-20261029-153016-before-prayerbookatlas.tar.gz`. The main Caddyfile was not
changed: it already imports every file in `/etc/caddy/sites/`.

## 5. Headers

Rails sends HSTS (`config.force_ssl`), the Content Security Policy, the permissions policy (under
its older name, `Feature-Policy`, as Rails 8.1 sends it), and
the other security headers; Caddy removes its `Server` header and adds `nosniff` and a year's
immutable caching to the fingerprinted files under `/assets/`, which it serves straight from
the release. Until launch (P5.7, P22), `robots.txt` disallows everything and every page carries
`<meta name="robots" content="noindex, nofollow">` and a line saying the site is in development.

## 6. Serving the backup domain directly

If `prayerbookatlas.com` cannot be used, in `deploy/prayerbookatlas.caddy` move
`prayerbookatlas.org` from the redirect block to the first site block's address
(`prayerbookatlas.org {`), redirect the others to it instead, change the checks in
`deploy/cutover.sh` and `deploy/rollback.sh` to the `.org` name, and deploy. Rails accepts both
names already. Move it back when `.com` returns.

## 7. Backups

The app's own databases are the files in `/srv/www/prayerbookatlas.com/shared/storage/`. Back
them up nightly with SQLite's online backup (`sqlite3 <db> ".backup '<copy>'"`), encrypt the
copies, and keep them off the server on owner-controlled storage; run a restore drill once and
then quarterly (P5.5, P27.1). The server's own `ubuntu-vm-backup` job does not cover this site
yet. The content database is never backed up: it is rebuilt from the repository on every
deploy. Personal data (intercessions, journals, confession notes) is never on the server at all
(D29).

## 8. After each deploy

`bin/deploy` checks `/up` and the home page itself. By hand:

- `https://prayerbookatlas.com/up` answers 200.
- Each redirecting name answers 308 to the same path on `.com`.
- The home page sends `Content-Security-Policy`, `Strict-Transport-Security`, `Feature-Policy`,
  and `Vary: Sec-CH-UA-Mobile, User-Agent, Cookie`.
- A phone user agent gets the phone site and a desktop one the full site.
- The owner's other sites still answer as before.

`bin/rails site:check_live` (P5.6) will check all of this in one command.
