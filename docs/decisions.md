# Decision log

A numbered, append-only record of engineering and product decisions. Add a new
entry at the end; never renumber or delete one. To reverse a decision, add a
new entry that supersedes it and mark the old one **Superseded by N**.

Each entry gives the date, the status, what was decided, and why. Owner
decisions (D1–D26) live in [BUILD.md](../BUILD.md#owner-decisions). An entry
that rests on an open owner decision says so and has the status **Working
default**: it follows that decision's recommendation until the owner answers
(AGENTS.md §4), and is built so that it is easy to change.

Entries 1–12 record BUILD.md's
[Engineering foundations](../BUILD.md#engineering-foundations), adapted from
Beautiful Corner's decision log (entry 16 below).

---

## 1. Generate the Xcode project with XcodeGen

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** The Xcode project is generated from `project.yml` by
  [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`make generate`). The
  `.xcodeproj` is gitignored and never hand-edited. Local packages are listed
  under `packages:` with a `path` and linked with `- package: Name`, as
  XcodeGen's current ProjectSpec documents (checked 2026-10-28, XcodeGen
  2.46.0).
- **Why:** A generated project cannot drift or produce merge conflicts, and
  every build setting is reviewable in one text file.

## 2. SwiftUI with Observation

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** The interface is SwiftUI. Shared state uses the Observation
  framework (`@Observable`). UIKit appears only in small wrappers, each with a
  comment explaining why SwiftUI could not do the job.
- **Why:** SwiftUI is Apple's current interface framework and carries
  Dynamic Type, VoiceOver, and Liquid Glass with the least code.

## 3. SwiftData for user data

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** User data (favorites, intercessions, the rule of life,
  journals, reading-plan progress, and the like) lives in SwiftData, with a
  `VersionedSchema`, a migration plan, and CloudKit-compatible models
  (optional or defaulted properties, no unique constraints). Liturgical
  content never goes in SwiftData. Confession notes are never synced.
- **Why:** SwiftData gives optional iCloud private sync without a server, and
  a versioned schema keeps upgrades safe from the first release. The current
  SwiftData documentation is checked again when the first model is written.

## 4. A bundled, read-only SQLite content database

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** `Tools/ContentCompiler` validates `content/` and writes a
  deterministic `Content.sqlite` (system `SQLite3`, FTS5), which the app
  bundles read-only. The compiler refuses content whose source is not
  `cleared` in `content/SOURCES.md`.
- **Why:** The offices, the calendar, and the Bible must work offline, search
  must be fast, and the rights check must be enforced by the build, not by
  memory.

## 5. Pure logic in local Swift packages

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** Calendar, content, Scripture, office, and Atlas logic live in
  local packages under `Packages/` (`ChurchYear`, `ContentKit`,
  `ScriptureKit`, later `OfficeKit`, `AtlasKit`, and `SharedModels`). They
  use only Foundation APIs available on Linux, import no Apple-only
  frameworks, and are tested with `swift test` on macOS and in the
  `swift:6.4` container (`make test-linux`). The app target holds the
  interface and composition only.
- **Why:** The same engine must later serve the website, the web app, and
  any Android port (D19, D25), and logic outside the app tests in seconds
  without a simulator.

## 6. Zero third-party runtime dependencies

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** The app links no third-party code unless a later entry here
  justifies it. Approved build-time tools: XcodeGen and Apple's bundled
  `swift format`.
- **Why:** Every dependency is a supply-chain, privacy, and maintenance risk
  for an app that will be maintained for years by agents and one owner.

## 7. Swift Testing, with XCTest for UI tests

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** Packages and app unit tests use Swift Testing (`@Test`,
  `#expect`, `#require`, `arguments:` for table-driven cases). UI tests use
  XCTest, which Swift Testing does not replace. Every calendar, collect, and
  lectionary rule has a test citing its book and page.
- **Why:** Parameterized tests report exactly which year or date failed, which
  is what table-driven calendar tests need. Checked against the
  swift-testing documentation on 2026-10-28.

## 8. Civil dates, not `Date`

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** Church-calendar logic uses a pure `CivilDate` value (year,
  month, day). `Date` and time zones appear only at the interface edge.
- **Why:** A holy day is a calendar day, not an instant; mixing in time zones
  produces off-by-one-day errors near midnight and across travel.

## 9. Our own simple content formats

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** Content files are UTF-8 text with `key: value` front matter,
  parsed by our own code (no YAML library); tables are JSON.
- **Why:** Keeps entry 6, and keeps the formats small enough to document
  completely in `docs/content-format.md` (P3.2).

## 10. A debug date override

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** Debug builds accept the launch argument `-today YYYY-MM-DD`,
  which pins the app's idea of today. Release builds ignore it.
- **Why:** UI tests and screenshots must be able to open Easter, Ash
  Wednesday, or an Ember Day on demand.

## 11. Book, printing, and page on everything

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** Every liturgical block knows the book it belongs to, the
  printing it was transcribed from, and its printed page. Texts are never
  shared between books by reference, even when identical: each book's
  witness is its own transcription.
- **Why:** The app must agree with the pew book, and many Anglican texts
  differ by a word between editions (AGENTS.md §6).

## 12. Works and witnesses

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** The Atlas links each book's text of a prayer (a *witness*)
  to the abstract prayer (a *work*), so comparison across books is a query,
  not a copy.
- **Why:** Entry 11 forbids sharing texts between books; the work–witness
  link lets the Atlas compare them without breaking that rule.

## 13. Deployment target: iOS 26

- **Date:** 2026-10-28 · **Status:** Working default (D2 open)
- **Decision:** The app's deployment target is iOS 26.0, built with the
  iOS 27 SDK in Xcode 27. It is set once, in `project.yml`
  (`options.deploymentTarget`), and the packages declare `.iOS(.v26)`.
- **Why:** D2's recommendation, matching Beautiful Corner. iOS 26 brought
  Liquid Glass and the current SwiftUI and SwiftData APIs; supporting it as
  well as iOS 27 reaches people who have not updated yet. An iOS 26.5
  simulator runtime is installed for checking it.

## 14. Scripture policy

- **Date:** 2026-10-28 · **Status:** Working default (D5 open)
- **Decision:** Each office uses its own book's Psalter and canticles. The
  Bible reader and the lessons launch with the King James Version with the
  Apocrypha and the World English Bible, each labeled. Licensed translations
  (RSV, ESV, NRSV) are added only with a license recorded in
  `content/SOURCES.md`. Every passage names its translation, translations
  are never mixed unlabeled, and generated text is never shown as Scripture.
- **Why:** The two launch translations are public domain in the US and
  include the deuterocanonical books the lectionaries appoint; the books'
  own Psalters are part of each book's witness (entry 11). The guard is
  P3.5.

## 15. No analytics, advertising, or tracking

- **Date:** 2026-10-28 · **Status:** Accepted
- **Decision:** No analytics, advertising, tracking, crash-reporting,
  affiliate, or remote-font SDKs, in the app or on the website. The app's
  privacy manifest and App Store privacy label declare no data collected.
  The network is used only for sync, audio downloads, the Grace & Footnotes
  feed, and (later) the AI assistant.
- **Why:** Privacy is pastoral care (AGENTS.md §3). People pray, list the
  sick, and prepare for confession in this app.

## 16. Reuse from Beautiful Corner

- **Date:** 2026-10-28 · **Status:** Working default (D10 open)
- **Decision:** Generic engineering is copied from the owner's
  `beautiful-corner` repository and adapted, never changed there. The source
  is its commit `6f8bc4b` ("Add standing git rules to AGENTS.md"). Phase 1
  adapts `.gitignore`, `.swift-format`, the Makefile's shape,
  `scripts/sim-destination.sh`, `scripts/check-warnings.sh`,
  `scripts/check-package-imports.sh`, the `project.yml` layout, the
  `Config/` files, and the CI workflow. Later candidates: `CivilDate`, the
  content compiler, and the SQLite reader (Phase 3 and P4.1). No Orthodox
  content is copied. The retired `anglican-catholic-app` is consulted for
  lessons only; any text from it passes this repository's rights and
  proofreading rules as if new.
- **Why:** The two apps share a stack; reinventing tested tooling wastes
  time and invites new bugs. Naming the source commit lets a later agent
  compare and carry fixes across.

## 17. On iPhone, Search is a toolbar button

- **Date:** 2026-10-28 · **Status:** Accepted (agent, found in testing; the
  owner may revisit it)
- **Decision:** On regular widths (iPad), Search is the system search tab
  beside the five content tabs. On compact widths (iPhone), the tab bar holds
  the five content tabs (Today, Pray, Bible, Kalendar, Atlas), and Search is a
  toolbar button beside Settings on every tab's root, pushing Search onto the
  current tab. Deep links and restored state that name the search tab do the
  same on iPhone.
- **Why:** In the iOS 27 simulator, SwiftUI counts the search tab toward the
  iPhone's five-item limit, so six tabs collapse into the system "More" list,
  hiding Atlas and Search (seen on iPhone 17 Pro, 2026-10-28; Beautiful
  Corner met the same, its decision 16). Keeping all five content tabs
  visible mattered more than a dedicated search tab. Alternatives, if the
  owner prefers: four tabs plus search (Atlas inside another tab), or Search
  under a sixth "More" tab.
