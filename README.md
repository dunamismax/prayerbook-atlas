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

**Status:** in development; nothing is ready for prayer yet and nothing is
deployed. [BUILD.md](BUILD.md) is the plan and its current state.
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
tests, and the seeds (`config/ci.rb`). Separately:

```bash
bin/rails test
```

```bash
bin/rubocop -a
```

```bash
bin/rails design:tokens
```

The last regenerates `app/assets/stylesheets/tokens.css` from
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
| `app/models/` | `SiteSection`, and later the plain-Ruby engines (`ChurchYear::`, `Office::`, `Scripture::`, `Atlas::`) |
| `app/assets/stylesheets/` | Vanilla CSS; `tokens.css` is generated |
| `app/assets/fonts/` | Cardo (SIL OFL 1.1), self-hosted as WOFF2 |
| `lib/design_tokens.rb`, `lib/tasks/design.rake` | The tokens-to-CSS generator |
| `content/` | Sourced texts and tables, and `SOURCES.md`, the rights register |
| `design/` | `tokens.json`, the owner's generated images and their prompts and registry |
| `docs/` | Product rules, design, decisions, and deployment |
| `config/ci.rb` | The local CI steps `bin/ci` runs |
| `research/` | Gitignored downloads for rights research; never served |

## Deployment

Self-hosted on the owner's Ubuntu server behind Caddy, at
prayerbookatlas.com, with prayerbookatlas.org as the backup domain and
prayerbook-atlas.com redirecting to it. [docs/deploy.md](docs/deploy.md)
describes the server; every server change waits for the owner.

## License

All rights reserved; see [LICENSE](LICENSE). Texts, Scripture, fonts, and
images keep their own rights, recorded in `content/SOURCES.md`.
