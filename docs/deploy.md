# Deploying prayerbookatlas.com

How the site is served from the owner's Ubuntu server (BUILD.md D28, docs/decisions.md
entry 27). **Every step on the server, in Caddy, or in DNS is the owner's to approve**
(AGENTS.md §4): agents prepare the files and commands here, the owner runs or confirms them.
Nothing below has been done yet; BUILD.md Phase 5 tracks it.

## 1. The shape

```
Internet ─ Caddy (TLS, compression, redirects; the server's existing Caddy)
             │  prayerbookatlas.com
             ▼
           Puma on 127.0.0.1:<port>  (systemd: prayerbookatlas.service)
             │  Rails 8.1, RAILS_ENV=production, Solid Queue inside Puma
             ├─ /srv/prayerbookatlas/shared/storage/   the app's SQLite databases
             └─ db/content.sqlite3 in each release      rebuilt from content/ on deploy
```

- **One canonical name**: `https://prayerbookatlas.com`. These redirect to it permanently
  (308, keeping the path): `www.prayerbookatlas.com`, `prayerbook-atlas.com`,
  `www.prayerbook-atlas.com`, `prayerbookatlas.org`, and `www.prayerbookatlas.org` (D12).
- **The backup domain**: Rails already accepts `prayerbookatlas.org` as a host
  (`config/environments/production.rb`), so if `.com` ever cannot be used, Caddy can serve the
  site at `.org` directly (§4).
- **Only a built release is served.** The checkout, the repository, and `research/` are never a
  web root.

## 2. On the server (once) [OWNER]

Run as an administrator. Choose a free local port first (`ss -ltnp`); the examples use 3100.

1. A user and directories:

   ```bash
   sudo adduser --system --group --home /home/prayerbookatlas --shell /bin/bash prayerbookatlas
   ```

   ```bash
   sudo mkdir -p /srv/prayerbookatlas/releases /srv/prayerbookatlas/shared/storage
   ```

   ```bash
   sudo chown -R prayerbookatlas:prayerbookatlas /srv/prayerbookatlas
   ```

2. Ruby 4.0.9 through mise, as the `prayerbookatlas` user (the same version `.ruby-version`
   pins; decision 23). Install mise from its official instructions (<https://mise.jdx.dev>),
   then:

   ```bash
   mise settings add idiomatic_version_file_enable_tools ruby
   ```

   ```bash
   mise use --global ruby@4.0.9
   ```

   Precompiled Ruby needs no build tools; gems with native extensions (Puma, bootsnap's msgpack)
   need `build-essential` installed once.

3. The environment file, `/srv/prayerbookatlas/shared/env`, owned by `prayerbookatlas` with
   mode `600`:

   ```
   RAILS_ENV=production
   RAILS_MASTER_KEY=<the contents of the owner's config/master.key>
   PORT=3100
   SOLID_QUEUE_IN_PUMA=true
   RAILS_LOG_LEVEL=info
   ```

   `config/master.key` exists only on the owner's Mac (it is gitignored). Copy its contents by
   hand; never commit it, paste it into a chat, or print it in a log.

4. The service, `/etc/systemd/system/prayerbookatlas.service`:

   ```ini
   [Unit]
   Description=Prayerbook Atlas (Rails on Puma)
   After=network.target

   [Service]
   Type=simple
   User=prayerbookatlas
   Group=prayerbookatlas
   WorkingDirectory=/srv/prayerbookatlas/current
   EnvironmentFile=/srv/prayerbookatlas/shared/env
   ExecStart=/home/prayerbookatlas/.local/bin/mise exec -- bundle exec puma -C config/puma.rb
   Restart=always
   RestartSec=2
   TimeoutStopSec=30
   NoNewPrivileges=true
   PrivateTmp=true
   ProtectSystem=strict
   ProtectHome=read-only
   ReadWritePaths=/srv/prayerbookatlas

   [Install]
   WantedBy=multi-user.target
   ```

   Then `sudo systemctl daemon-reload` and, after the first release exists,
   `sudo systemctl enable --now prayerbookatlas`. Logs go to the journal
   (`journalctl -u prayerbookatlas`), because production Rails logs to standard output.

5. The Caddy site, added **beside** the server's existing sites (for example as
   `/etc/caddy/sites/prayerbookatlas.caddy`, imported from the main Caddyfile), never replacing
   another site's configuration:

   ```caddy
   prayerbookatlas.com {
   	encode zstd gzip

   	# Fingerprinted assets straight from the release; Rails serves everything else.
   	@assets path /assets/*
   	handle @assets {
   		root * /srv/prayerbookatlas/current/public
   		header Cache-Control "public, max-age=31536000, immutable"
   		file_server
   	}

   	handle {
   		reverse_proxy 127.0.0.1:3100
   	}

   	log {
   		output file /var/log/caddy/prayerbookatlas.log {
   			roll_size 50MiB
   			roll_keep 10
   		}
   	}
   }

   www.prayerbookatlas.com, prayerbook-atlas.com, www.prayerbook-atlas.com, prayerbookatlas.org, www.prayerbookatlas.org {
   	redir https://prayerbookatlas.com{uri} 308
   }
   ```

   Check with `caddy validate --config /etc/caddy/Caddyfile`, then `sudo systemctl reload caddy`.
   Rails itself sends HSTS (`config.force_ssl`), the Content Security Policy, the Permissions
   Policy, and the other security headers, so Caddy does not repeat them. Caddy obtains the
   certificates; DNS at Cloudflare must point every name above at the server (if a record is
   proxied by Cloudflare, its SSL mode must be Full (strict)).

## 3. A release

Until `bin/deploy` exists (BUILD.md P5.2), a release is made by hand like this; `bin/deploy`
will do the same and roll back on failure.

1. On the Mac, from a clean, pushed `main` that passes `bin/ci`:

   ```bash
   git archive --format=tar.gz --prefix=release/ -o /tmp/prayerbookatlas.tar.gz main
   ```

2. On the server, as `prayerbookatlas`, unpack it into a new directory named for the commit
   and time, for example `/srv/prayerbookatlas/releases/20261029-1200-a1b2c3d/`, and link the
   shared storage into it (`ln -s /srv/prayerbookatlas/shared/storage storage`).
3. In the release directory, with the environment file loaded:

   ```bash
   bundle config set --local deployment true
   ```

   ```bash
   bundle config set --local without "development test"
   ```

   ```bash
   bundle install
   ```

   ```bash
   bin/rails assets:precompile
   ```

   ```bash
   bin/rails db:prepare
   ```

   and, once the content compiler exists (P3.3), `bin/rails content:compile` with release
   checks.
4. Point `current` at the new release (`ln -sfn <release> /srv/prayerbookatlas/current`),
   restart (`sudo systemctl restart prayerbookatlas`), and check
   `curl -fsS https://prayerbookatlas.com/up`.
5. **Rollback**: point `current` back at the previous release and restart. Keep the last five
   releases.

## 4. Serving the backup domain directly

If `prayerbookatlas.com` cannot be used, move `prayerbookatlas.org` from the redirect block to
the first site block's address (`prayerbookatlas.org {`), redirect the others to it instead,
and reload Caddy. Rails accepts both names already. Move it back when `.com` returns.

## 5. Backups

The app's own databases are the files in `/srv/prayerbookatlas/shared/storage/`. Back them up
nightly with SQLite's online backup (`sqlite3 <db> ".backup '<copy>'"`), encrypt the copies,
and keep them off the server on owner-controlled storage; run a restore drill once and then
quarterly (P5.5, P27.1). The content database is never backed up: it is rebuilt from the
repository on every deploy. Personal data (intercessions, journals, confession notes) is never
on the server at all (D29).

## 6. After each deploy

- `https://prayerbookatlas.com/up` answers 200.
- Each redirecting name answers 308 to the same path on `.com`.
- The home page sends `Content-Security-Policy`, `Strict-Transport-Security`,
  `Permissions-Policy`, and `Vary: Sec-CH-UA-Mobile, User-Agent, Cookie`.
- A phone user agent gets the phone site and a desktop one the full site.

`bin/rails site:check_live` (P5.6) will check all of this in one command.
