# Prayerbook Atlas

A website for Anglican and Episcopal common prayer across the Books of Common
Prayer, at [prayerbookatlas.com](https://prayerbookatlas.com): the Daily
Office for any day from the book you pray with, the Christian year kept by
each book's own rules, and an atlas of how the books compare and descend from
one another, every text with its book, printing, and page.

It is built with Ruby on Rails, desktop first, with a dedicated phone site
for small-screen mobile browsers. It is personal lay work, the sister project
of [Grace & Footnotes](https://graceandfootnotes.com), and not an official
publication of any church.

**Status:** in development; nothing is ready for prayer yet. The work in
progress is live at <https://prayerbookatlas.com>, marked as in development
and kept out of search indexes. [BUILD.md](BUILD.md) is the plan and its current state.
[AGENTS.md](AGENTS.md) and [SOUL.md](SOUL.md) govern how the work is done.
The project began as an iPhone app, retired on 2026-10-29 (Git tag
`ios-archive`).

## Prerequisites

Confirmed on the owner's Mac (macOS 27.2, Apple silicon) on 2026-10-29:

- **Ruby 4.0.9**, through [mise](https://mise.jdx.dev) (2026.10.18), which
  reads `.ruby-version`. With mise installed:

  ```bash
  mise settings add idiomatic_version_file_enable_tools ruby
  ```

  ```bash
  mise install ruby@4.0.9
  ```

- **Bundler 4.0.23** and **Rails 8.1.4** (the Gemfile pins Rails; `gem
  install rails -v 8.1.4` gives you the `rails` command outside the project).
- **Google Chrome**, for system tests (headless).
- **fontTools** (`brew install fonttools`), only to convert a font to WOFF2,
  and **ImageMagick** (`brew install imagemagick`), only to resize the
  owner's images.
- For checking pages in other engines, optionally: **Firefox** (`brew install
  --cask firefox`), whose `--headless --screenshot` mode can run with
  JavaScript off through a profile's `user.js`, and the **Swift** compiler
  from Xcode, for `script/webkit_snapshot.swift` (WebKit, Safari's engine).

SQLite needs nothing installed: the sqlite3 gem bundles SQLite 3.54.1 with
FTS5. No Node, no CSS build, and no Docker.

## Quick start

From a clean checkout:

```bash
bin/setup
```

That installs the gems, prepares the databases, and starts the server at
<http://localhost:3000>. Afterwards, start it with:

```bash
bin/dev
```

The site draws itself in one of two modes: the **full site** for desktop and
tablet browsers and the **phone site** for phones. To see the phone site on a
computer, use the browser's device emulation (which sends a phone user agent)
or the "Use the phone site" button in any page's footer.

## Checks

Before every commit:

```bash
bin/ci
```

It runs setup, RuboCop, bundler-audit, the importmap audit, Brakeman, the
tests, the system tests, and the seeds (`config/ci.rb`). Separately:

```bash
bin/rails test
```

```bash
bin/rails test:system
```

```bash
bin/rubocop -a
```

```bash
bin/rails design:tokens
```

The system tests drive headless Chrome through every section twice: as a
desktop window on the full site, and as a phone (Chrome's mobile emulation,
which sends a phone user agent and the mobile client hint) on the phone site.
Their screenshots go to `tmp/screenshots/`, which is never committed.

`bin/rails design:tokens` regenerates `app/assets/stylesheets/tokens.css` from
`design/tokens.json`; a test fails if you forget.

The GitHub workflow (`.github/workflows/ci.yml`) runs the same checks on
GitHub's Linux runners, by manual dispatch.

## Layout

| Path | What it holds |
|---|---|
| `app/controllers/concerns/site_mode.rb` | Chooses the phone site or the full site for each request |
| `app/views/layouts/application.html.erb` | The full site: masthead, contents, reading column, margin |
| `app/views/layouts/application.html+phone.erb` | The phone site: phone bar, one column, tab bar |
| `app/views/sections/` | The five sections: Today, Pray, Bible, Kalendar, Atlas |
| `app/models/` | `SiteSection`, `PrayerBook`, `Translation`, `Office`, and later the plain-Ruby engines (`ChurchYear::`, `Office::`, `Scripture::`, `Atlas::`) |
| `app/assets/stylesheets/` | Vanilla CSS; `tokens.css` is generated |
| `app/assets/fonts/` | Cardo (SIL OFL 1.1), self-hosted as WOFF2 |
| `lib/design_tokens.rb`, `lib/tasks/design.rake` | The tokens-to-CSS generator |
| `content/` | Sourced texts and tables, and `SOURCES.md`, the rights register |
| `design/` | `tokens.json`, the owner's generated images and their prompts and registry |
| `docs/` | Product rules, design, URLs, decisions, and deployment |
| `config/ci.rb` | The local CI steps `bin/ci` runs |
| `bin/deploy`, `deploy/` | Deploys to the server: build, cutover, rollback, the systemd unit, and the Caddy site |
| `script/webkit_snapshot.swift` | Snapshots a page with WebKit (Safari's engine) for browser checks |
| `research/` | Gitignored downloads for rights research; never served |

## Deployment

Self-hosted on the owner's Ubuntu server (`ubuntu-vm`) behind its shared
Caddy, at <https://prayerbookatlas.com>; www, prayerbookatlas.org (the backup
domain), and prayerbook-atlas.com redirect to it. After `bin/ci` passes and
`main` is pushed:

```bash
bin/deploy
```

builds a release of `origin/main` on the server from `git archive`, migrates,
checks it, switches to it, and rolls back if anything fails;
`bin/deploy --rollback` returns to the previous release. It needs SSH as root
to `ubuntu-vm` over Tailscale. [docs/deploy.md](docs/deploy.md) describes the
server and where everything lives.

## License

All rights reserved; see [LICENSE](LICENSE). Texts, Scripture, fonts, and
images keep their own rights, recorded in `content/SOURCES.md`.
