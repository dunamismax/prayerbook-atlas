# Prayerbook Atlas

**Every Book of Common Prayer, one daily office.**

Prayerbook Atlas is a native iPhone app, with a public website and a web
app to follow at [prayerbookatlas.com](https://prayerbookatlas.com), for
Anglican and Episcopal common prayer. It gathers the Books of Common Prayer
and their ways of reading Scripture into one quiet, beautiful place: Morning
and Evening Prayer, Noonday Prayer, and Compline with the day's psalms,
lessons, canticles, and collects already in place; every lectionary and
Psalter the books appoint; the Christian year kept by each book's own rules;
and the books themselves, side by side.

The name says what it is for. An atlas is a book of maps; this one maps the
prayer books, from Cranmer's 1549 and 1552 through the 1662 book of the
Church of England, the American books of 1928 and 1979, the ACNA's 2019 book,
and the books of other provinces. Pick the book your church uses and pray
from it as printed. Or open the Atlas and see the same prayer in every book
that has it, with the differences marked and the page number of each.

It is the sister project of [Grace & Footnotes](https://graceandfootnotes.com),
the owner's website. It shares the website's Anglican faith, its plain and
careful voice, and its sources one tap away, and it has a look of its own: an
engraved plate from an old atlas, chart paper and iron-blue ink, double-rule
frames and small capitals, one cartographer's blue, and the season's colour
carried by a ribbon marker.

## Status

**Phase 1: repository and toolchain.** The app builds and launches to a
placeholder Today that shows the date; the three foundation packages, the
Makefile, and `make check` are in place. No liturgical text is in the app
yet. The [image gallery](design/generated/index.html) contains 54 generated
PNG design sources; [its README](design/generated/README.md) records how
they were exported and the remaining work. D15 is decided: Engraved Plate
([docs/design.md](docs/design.md)). This README, [AGENTS.md](AGENTS.md), and
[BUILD.md](BUILD.md) set out the finished app, the owner decisions, the
research behind them, and thirty phases of checklists. The app name (D1) and
the domains and support email (D12) are decided; the other decisions carry
recommendations awaiting the owner (BUILD.md P0.1). BUILD.md's **Build
status** table and **Handoff notes** always give the current state.

| File | What it is |
| --- | --- |
| [BUILD.md](BUILD.md) | The master plan: the finished app, owner decisions, research, phases, checklists, and handoff notes |
| [AGENTS.md](AGENTS.md) | How every coding session works in this repository, and the faith and voice that govern it |
| [SOUL.md](SOUL.md) | The owner's statement of faith and the app's voice and conduct guide (draft awaiting the owner's approval, P0.11) |
| [docs/decisions.md](docs/decisions.md) | The numbered, append-only decision log |
| [design/image-prompts.md](design/image-prompts.md) | One image-generation prompt per icon, symbol, drawing, ornament, and plate the plan needs |
| [design/generated/](design/generated/README.md) | 54 generated PNG design sources and a local review gallery |
| [design/image-registry.json](design/image-registry.json) | Image provenance, exact prompts, hashes, alpha checks, dimensions, and review limits |
| [content/SOURCES.md](content/SOURCES.md) | Source register, initially covering the generated visual assets |

## Facts at a glance

| | |
| --- | --- |
| App name | Prayerbook Atlas (D1) |
| Website | [prayerbookatlas.com](https://prayerbookatlas.com); prayerbook-atlas.com and prayerbookatlas.org, also held, will redirect to it (D12, P19.2) |
| Support email | support@prayerbookatlas.com (Cloudflare Email Routing, catch-all to the owner's inbox) |
| Repository | `github.com/dunamismax/prayerbook-atlas` (public as of 2026-10-28; visibility is D11) |
| Bundle ID | `com.prayerbookatlas.app` (working default, D1) |
| Platforms | iPhone first, then iPad, Apple Watch, and widgets; the website and a web app; Android if chosen (D25) |
| Minimum iOS | iOS 26 (working default, D2) |
| Prayer books at launch | 1662 (England), 1928 (US), and 1979 (US), the three that are public domain in the US (D3) |
| By permission | The ACNA's 2019 book, Canada's 1962, Common Worship, the Revised Common Lectionary, and more (D6, Phase 16) |
| Scripture | Each book's own Psalter in the offices; the KJV with the Apocrypha and the World English Bible in the reader at launch; licensed translations as permission arrives (D5) |
| Price | Free, donation-supported, no ads or tracking (D7) |

## What it will do

- **Pray the office** from the chosen book for any day, with nothing to
  look up: sentences, psalms, lessons, canticles, the creed, the collects,
  the Litany on its days, and the Athanasian Creed on its feasts.
- **Keep the Christian year** by each book's own rules: Easter and the
  moveable feasts, Septuagesima where the book keeps it, red-letter and
  black-letter days, Ember and Rogation days, fasts and days of abstinence,
  and the collect of the day, tested against the printed tables.
- **Read the Bible the Church's way**: every lectionary the books appoint,
  each book's Psalter in its own cycle, and gentle reading plans with no
  streaks.
- **Explore the Atlas**: compare a prayer across editions, find where any
  prayer appears, read each book's history, and follow the lineage of the
  prayer books on a sourced map.
- **Keep a rule of life privately**: favorites, an intercession list whose
  names appear in the prayers, a personal rule, a journal, and preparation
  for confession that never leaves the device.
- **Learn**: the catechisms, the creeds, the Articles, a glossary, and a
  welcome for anyone new to the prayer book.
- **Work everywhere and offline**: widgets, Siri, Apple Watch, the website,
  and a web app, with prayer never waiting on the network.

## Principles

Each book is shown on its own terms, as printed, with its source and page
one tap away. Nothing is typed from memory or quietly borrowed from another
edition. Every Anglican is welcome, whatever book, province, or
churchmanship. The app serves prayer and never performs it: no badges,
streaks, or pressure, and no paywall on prayer. It is not a priest. What a
person writes stays on the device. AGENTS.md §3 and BUILD.md's Product
principles give the full rules.

## Not an official publication

Prayerbook Atlas is personal lay work. It is not an official publication of
the Church of England, The Episcopal Church, the Anglican Church in North
America, the Anglican Communion, or any other church, diocese, or parish,
and no bishop or priest has endorsed it unless BUILD.md records that. It
uses no church's seal, shield, or logo. Each prayer book's text belongs to
its own church and publisher; the app credits each and uses copyrighted
texts only with permission.

## Stack

As planned (Phase 1 has built the first part): native iOS in Swift 6 and SwiftUI, with pure logic in local Swift packages
(`ChurchYear`, `ContentKit`, `ScriptureKit`, `OfficeKit`, `AtlasKit`),
liturgical texts compiled into a bundled read-only SQLite database whose
compiler refuses any source not cleared, user data in SwiftData with optional
iCloud sync, zero third-party runtime dependencies, and no analytics or
tracking. The public website is a small static site served by Caddy on the
owner's Ubuntu server (D26). Later phases add a Swift server and a
server-rendered web app sharing the same packages (D19). Details and reasons
are in [BUILD.md](BUILD.md#engineering-foundations).

## Prerequisites

Checked on the owner's Mac on 2026-10-28 (macOS 27.2) by running `make check`:

| Tool | Version | Notes |
| --- | --- | --- |
| Xcode | 27.1 (27A9275) | iOS 27 SDK; iOS 27.0 and 27.1 simulator runtimes |
| Swift | 6.4 (swiftlang-6.4.0.34.1) | Ships with Xcode |
| XcodeGen | 2.46.0 | `brew install xcodegen` |
| `swift format` | bundled with the Xcode 27 toolchain | Run as `swift format` |
| iOS simulators | iOS 26.5, 27.0, 27.1 | Any iPhone; `scripts/sim-destination.sh` picks the newest |
| fontTools | 4.68.0 (Homebrew) | `brew install fonttools`; for checking bundled fonts' glyphs and features |
| ImageMagick | 7.1 (Homebrew) | `brew install imagemagick`; for image exports and screenshot checks |
| Colima and Docker | Docker CLI 29.9.2 (Homebrew), Colima | For `make test-linux`, which runs the package tests in the `swift:6.4` container; `brew install colima docker`, then `colima start` |

## Quick start

```sh
brew install xcodegen   # once
make run                # generate the project, build, boot a simulator, install and launch
make check              # lint, package tests, content, app tests, Release build
```

`make help` lists every target. `SIM_DEVICE="iPhone 17 Pro" make run` picks
a simulator by name or UDID, and `make screenshot APPEARANCE=dark
TEXT_SIZE=accessibility-extra-extra-extra-large` saves one to the gitignored
`screenshots/`. Never edit the `.xcodeproj`: it is generated from
`project.yml` and gitignored. To sign for a device, see
`Config/Secrets.xcconfig.example`.

## Layout

```text
App/                     SwiftUI app target (UI and composition only)
App/Resources/           Asset catalog (colours, later the icon)
AppTests/                App unit tests (Swift Testing)
AppUITests/              App UI tests (XCTest)
Config/                  Base.xcconfig; Secrets.xcconfig.example for signing
Packages/ChurchYear      The church year: CivilDate so far; Easter, seasons, holy days, collects to come
Packages/ContentKit      Content models: the prayer-book identifiers so far; the SQLite reader to come
Packages/ScriptureKit    Scripture: the translation identifiers so far; references and Psalters to come
content/                 Sourced texts and tables; SOURCES.md is the rights registry
design/                  Generated image sources, prompts, and their registry
docs/                    The decision log
scripts/                 Simulator picker and the warnings check
project.yml              The XcodeGen project specification
Makefile                 Every build, test, and run command
```

Later phases add `Packages/OfficeKit` (Phase 6), `Packages/AtlasKit`
(Phase 11), `Tools/ContentCompiler` (Phase 3), `Website/` (Phase 19),
`Widgets/` and `Watch/` (Phase 18), `Packages/SharedModels`, and `Server/`.

## Further reading

- [AGENTS.md](AGENTS.md): how work on this repository is done
- [BUILD.md](BUILD.md): the build plan, owner decisions, research, and handoff notes
- [Grace & Footnotes](https://graceandfootnotes.com): the sister website
