# Decision log

A numbered, append-only record of engineering and product decisions. Add a new
entry at the end; never renumber or delete one. To reverse a decision, add a
new entry that supersedes it and mark the old one **Superseded by N**.

Each entry gives the date, the status, what was decided, and why. Owner
decisions (D1–D29) live in [BUILD.md](../BUILD.md#owner-decisions). An entry
that rests on an open owner decision says so and has the status **Working
default**: it follows that decision's recommendation until the owner answers
(AGENTS.md §4), and is built so that it is easy to change.

Entries 1–20 were made while Prayerbook Atlas was a native iPhone app.
On 2026-10-29 the owner made it a website built with Ruby on Rails (entry
21); entries 21–31 record the web foundations, and the iPhone entries they
replace are marked superseded. The retired app's code is at the Git tag
`ios-archive`.

---

## 1. Generate the Xcode project with XcodeGen

- **Date:** 2026-10-28 · **Status:** Superseded by 21
- **Decision:** The Xcode project is generated from `project.yml` by
  [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`make generate`). The
  `.xcodeproj` is gitignored and never hand-edited. Local packages are listed
  under `packages:` with a `path` and linked with `- package: Name`, as
  XcodeGen's current ProjectSpec documents (checked 2026-10-28, XcodeGen
  2.46.0).
- **Why:** A generated project cannot drift or produce merge conflicts, and
  every build setting is reviewable in one text file.

## 2. SwiftUI with Observation

- **Date:** 2026-10-28 · **Status:** Superseded by 21
- **Decision:** The interface is SwiftUI. Shared state uses the Observation
  framework (`@Observable`). UIKit appears only in small wrappers, each with a
  comment explaining why SwiftUI could not do the job.
- **Why:** SwiftUI is Apple's current interface framework and carries
  Dynamic Type, VoiceOver, and Liquid Glass with the least code.

## 3. SwiftData for user data

- **Date:** 2026-10-28 · **Status:** Superseded by 28
- **Decision:** User data (favorites, intercessions, the rule of life,
  journals, reading-plan progress, and the like) lives in SwiftData, with a
  `VersionedSchema`, a migration plan, and CloudKit-compatible models
  (optional or defaulted properties, no unique constraints). Liturgical
  content never goes in SwiftData. Confession notes are never synced.
- **Why:** SwiftData gives optional iCloud private sync without a server, and
  a versioned schema keeps upgrades safe from the first release. The current
  SwiftData documentation is checked again when the first model is written.

## 4. A bundled, read-only SQLite content database

- **Date:** 2026-10-28 · **Status:** Superseded by 26
- **Decision:** `Tools/ContentCompiler` validates `content/` and writes a
  deterministic `Content.sqlite` (system `SQLite3`, FTS5), which the app
  bundles read-only. The compiler refuses content whose source is not
  `cleared` in `content/SOURCES.md`.
- **Why:** The offices, the calendar, and the Bible must work offline, search
  must be fast, and the rights check must be enforced by the build, not by
  memory.

## 5. Pure logic in local Swift packages

- **Date:** 2026-10-28 · **Status:** Superseded by 22
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

- **Date:** 2026-10-28 · **Status:** Superseded by 29
- **Decision:** The app links no third-party code unless a later entry here
  justifies it. Approved build-time tools: XcodeGen and Apple's bundled
  `swift format`.
- **Why:** Every dependency is a supply-chain, privacy, and maintenance risk
  for an app that will be maintained for years by agents and one owner.

## 7. Swift Testing, with XCTest for UI tests

- **Date:** 2026-10-28 · **Status:** Superseded by 29
- **Decision:** Packages and app unit tests use Swift Testing (`@Test`,
  `#expect`, `#require`, `arguments:` for table-driven cases). UI tests use
  XCTest, which Swift Testing does not replace. Every calendar, collect, and
  lectionary rule has a test citing its book and page.
- **Why:** Parameterized tests report exactly which year or date failed, which
  is what table-driven calendar tests need. Checked against the
  swift-testing documentation on 2026-10-28.

## 8. Civil dates, not `Date`

- **Date:** 2026-10-28 · **Status:** Accepted; restated for Ruby by 30
- **Decision:** Church-calendar logic uses a pure `CivilDate` value (year,
  month, day). `Date` and time zones appear only at the interface edge.
- **Why:** A holy day is a calendar day, not an instant; mixing in time zones
  produces off-by-one-day errors near midnight and across travel.

## 9. Our own simple content formats

- **Date:** 2026-10-28 · **Status:** Accepted (still holds on the web)
- **Decision:** Content files are UTF-8 text with `key: value` front matter,
  parsed by our own code (no YAML library); tables are JSON.
- **Why:** Keeps entry 6, and keeps the formats small enough to document
  completely in `docs/content-format.md` (P3.2).

## 10. A debug date override

- **Date:** 2026-10-28 · **Status:** Superseded by 30 (a date in the URL)
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

- **Date:** 2026-10-28 · **Status:** Superseded by 25
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

- **Date:** 2026-10-28 · **Status:** Accepted; the app-specific lines are restated for the web by 31
- **Decision:** No analytics, advertising, tracking, crash-reporting,
  affiliate, or remote-font SDKs, in the app or on the website. The app's
  privacy manifest and App Store privacy label declare no data collected.
  The network is used only for sync, audio downloads, the Grace & Footnotes
  feed, and (later) the AI assistant.
- **Why:** Privacy is pastoral care (AGENTS.md §3). People pray, list the
  sick, and prepare for confession in this app.

## 16. Reuse from Beautiful Corner

- **Date:** 2026-10-28 · **Status:** Accepted for history; since 21 the Swift code no longer applies (see D10)
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

- **Date:** 2026-10-28 · **Status:** Superseded by 24
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

## 18. Design direction: Engraved Plate, set in Cardo

- **Date:** 2026-10-29 · **Status:** Accepted (owner for the direction;
  agent for the face, at the owner's direction)
- **Decision:** The owner chose **B · Engraved Plate** (D15) over Ribbon and
  Quiet Page in the design session (P2.2a): chart paper, iron-blue ink,
  double-rule frames on cards, small-capital labels, square corners, and one
  cartographer's blue for rubrics and actions. The book face is **Cardo**
  (SIL OFL 1.1, David J. Perry). The owner first chose Libre Caslon Text;
  fontTools showed it lacks ℣ ℟ ✠, Greek, and small caps, and the owner asked
  an agent to find a fuller face. Of eight OFL candidates checked (Cardo,
  Libertinus Serif from Google Fonts and upstream v7.051, Libre Caslon Text,
  Baskervville, Cormorant Garamond, Alegreya, Crimson Pro, Sorts Mill Goudy),
  only Cardo has ℣ ℟, polytonic Greek, true small caps (`smcp`), and
  old-style figures (`onum`). None has ✠ (U+2720); it falls back to the
  system's symbol font. EB Garamond stays avoided (Beautiful Corner's face).
  The placeholder icon is redrawn in B's palette as original vector art.
- **Why:** The owner preferred the atlas character throughout. The face must
  carry the marks the prayer books print (AGENTS.md, BUILD.md P2.4) without
  silent fallbacks; Cardo is an old-style face close to the Caslon look the
  owner chose.

## 19. Trademark knockout search for "Prayerbook Atlas"

- **Date:** 2026-10-29 · **Status:** Recorded (agent, at the owner's request;
  not legal advice and not a clearance opinion)
- **Searched:** USPTO's public trademark search (tmsearch.uspto.gov), all
  statuses, in the built-in browser, read-only.
  - `prayerbookatlas`: no results.
  - `prayerbook`: one result, SINGERSIDDUR (serial 78512747, IC 016,
    customized prayer books), dead, cancelled 2012-10-19; "prayerbook"
    appears only as its translation.
  - `prayer atlas` and `"prayer book"` (the engine matches either word):
    thousands of PRAYER and ATLAS marks. No live mark combines PRAYER or
    PRAYER BOOK with ATLAS. ATLAS alone is heavily registered, including live
    Class 9 and 42 software marks (for example serials 90431298, 90563097,
    97330725), so ATLAS by itself would be weak; the app's name is the
    composite.
- **Conclusion:** no conflicting live US mark was found for "Prayerbook
  Atlas". Trinity Broadcasting Network's "Atlas - Faith Journeys" app
  (Research finding 1) remains the nearest name in the App Store. Filing a
  registration is the owner's choice and has not been done. The domains held
  are prayerbookatlas.com, prayerbook-atlas.com, and prayerbookatlas.org.

## 20. Images come from the owner's generator, never from agents

- **Date:** 2026-10-29 · **Status:** Accepted (owner)
- **Decision:** Agents never draw, redraw, or generate images or icons,
  including vector art written as SVG. When an image is needed, an agent
  writes a prompt in `design/image-prompts.md` and gives it to the owner, who
  generates the image with ChatGPT's native image generation and supplies the
  file. Agents may resize, export, register, and integrate the owner's files
  without changing what they depict. This supersedes entry 18's line that
  the placeholder icon would be redrawn as original vector art.
- **Why:** An agent-drawn Engraved Plate icon was made on 2026-10-29 and the
  owner rejected it; it was reverted the same day, and the owner's generated
  icon (A1–A3) is the placeholder again. The owner then chose to keep all
  the current generated icons (A1–A12) unchanged, so no Engraved Plate
  icon is to be made (owner, 2026-10-29).

## 21. A website only, built with Ruby on Rails

- **Date:** 2026-10-29 · **Status:** Accepted (owner, D27)
- **Decision:** Prayerbook Atlas is no longer a mobile app. It is a website
  at prayerbookatlas.com, built with Ruby on Rails, primarily for desktop
  browsers, with a dedicated mode for small-screen mobile browsers and a
  fuller mode with more features for desktop and full-size windows
  (entry 24). The native iPhone app is retired: its code, the Xcode project
  setup, the Swift packages, and the TestFlight tooling were removed, and the
  last app commit is tagged `ios-archive` (`a9be149`). This supersedes
  entries 1, 2, and 13 outright and replaces 3, 4, 5, 6, 7, 10, and 17 with
  web equivalents (entries 22–31). Entries 8, 9, 11, 12, 14, 15, 18, 19, and
  20 still hold.
- **Why:** The owner's choice. One website serves every computer and phone,
  needs no store review, and can be self-hosted beside the owner's other
  sites. What carries over is everything that was not Swift: the faith and
  voice, the plan's content and rights rules, the Engraved Plate design and
  its tokens, Cardo, the owner's images, and the research.

## 22. Rails 8.1, as `rails new` makes it

- **Date:** 2026-10-29 · **Status:** Accepted (agent, within D27)
- **Decision:** Rails 8.1.4 on Ruby 4.0.9, generated in the repository root
  by `rails _8.1.4_ new prayerbook_atlas --skip-git --skip-kamal
  --skip-thruster --skip-docker --skip-action-mailbox --skip-action-text
  --skip-active-storage --skip-jbuilder --skip-devcontainer`, which keeps
  SQLite, Propshaft, importmap, Turbo, Stimulus, Solid Cache, Solid Queue,
  Solid Cable, Puma, Minitest with Capybara and Selenium, RuboCop
  (rails-omakase), Brakeman, bundler-audit, the local CI (`bin/ci`,
  `config/ci.rb`), and the GitHub workflow. The engines that were Swift
  packages (calendar, offices, Scripture, Atlas) become plain Ruby objects
  under `app/models/`, with no database access of their own.
- **Why:** The default stack is the best-documented and best-maintained path,
  and it needs no Node, no bundler, and no CSS build. Kamal, Thruster, and
  Docker are for deploying containers behind kamal-proxy; the owner's server
  already runs Caddy for other sites (entry 27). Mailbox, Action Text, Active
  Storage, and Jbuilder have no planned use; each can be added with its own
  entry when one appears. The generated Dependabot configuration is removed:
  it opens pull requests, and this repository takes none (AGENTS.md, Git
  rules); bundler-audit and the importmap audit in `bin/ci` flag vulnerable
  versions instead. Checked against the Rails 8.1 guides (Context7,
  2026-10-29): request variants and the `bin/ci` DSL.

## 23. Ruby through mise, pinned by `.ruby-version`

- **Date:** 2026-10-29 · **Status:** Accepted (agent)
- **Decision:** The project pins Ruby in `.ruby-version` (`ruby-4.0.9`). On
  the owner's Mac, mise (already the owner's runtime manager) provides it,
  set as the global Ruby and set to read `.ruby-version`; Homebrew's Ruby
  stays installed but off the PATH. The server uses mise the same way
  (docs/deploy.md), and GitHub's `ruby/setup-ruby` reads the same file.
- **Why:** One Ruby per machine, chosen by one file in the repository, so the
  Mac, the server, and CI agree. Two Rubies on the PATH had already put gems
  in the wrong place on this Mac.

## 24. Two modes: the full site and the phone site

- **Date:** 2026-10-29 · **Status:** Accepted (owner for the two modes, D27;
  agent for how)
- **Decision:** Each request is drawn in one of two modes. The **phone site**
  is for small-screen mobile browsers: the `Sec-CH-UA-Mobile` client hint
  decides where the browser sends it, and otherwise the user agent (phones,
  not tablets). The **full site** is for everything else. The phone site sets
  `request.variant = :phone`, so Rails renders `application.html+phone.erb`
  and any `+phone` view, falling back to the shared view otherwise. A person
  can choose either mode from every page's footer; the choice is a
  first-party cookie holding only "phone" or "full", and "automatic" deletes
  it. Pages send `Vary: Sec-CH-UA-Mobile, User-Agent, Cookie`. Within each
  mode, CSS adapts to the window: the full site folds its margin and contents
  columns under the text in a narrow window. The phone site's five sections
  sit in a tab bar along the bottom; there is no "More" (this replaces 17).
- **Why:** The owner asked for a dedicated phone experience and a fuller
  desktop one, not one responsive page stretched across both. The server must
  choose before it renders, which only request headers allow; the hint is
  the standard signal, the user agent covers Safari and Firefox, and the
  person's choice overrides both when the guess is wrong. Same URLs in both
  modes keep links shareable.

## 25. Every browser welcome; JavaScript only adds

- **Date:** 2026-10-29 · **Status:** Accepted (agent)
- **Decision:** Every page that sets out prayer, Scripture, or the calendar
  is semantic HTML that works without JavaScript and in old browsers. Rails'
  default `allow_browser versions: :modern` is removed, so no browser is
  turned away. Turbo and Stimulus enhance (keyboard, swipes, offline, the
  person's local data); features that need a modern browser say so plainly
  where they are missing. Enhancements are tested in the current and
  previous major versions of Safari, Chrome, Firefox, and Edge (D2).
- **Why:** People pray on old phones and borrowed computers; a prayer page
  that refuses a browser fails them. Plain HTML is also the most accessible,
  the fastest, and the easiest to print.

## 26. SQLite for everything, and a read-only content database

- **Date:** 2026-10-29 · **Status:** Accepted (agent); replaces 4
- **Decision:** The site's own data (and Solid Cache, Queue, and Cable) use
  SQLite in `storage/`, as Rails 8 sets up. Liturgical content is a separate
  database, `db/content.sqlite3`, compiled deterministically from `content/`
  by `bin/rails content:compile`, read-only at runtime through an abstract
  `ContentRecord`, with FTS5 for search. The compiler refuses content whose
  source is not `cleared` (development may allow `pending` with a warning).
  The compiled file is gitignored and rebuilt on every deploy.
- **Why:** One server, modest traffic, and mostly read-only text: SQLite is
  fast, needs no service, and backs up as a file. Keeping content apart from
  user data means content is always rebuilt from the repository's sourced
  files, never edited in production. The sqlite3 gem bundles SQLite 3.54.1
  with FTS5 (checked 2026-10-29).

## 27. Hosting: Puma under systemd behind the existing Caddy

- **Date:** 2026-10-29 · **Status:** Accepted (owner for self-hosting, D28;
  agent for the process model)
- **Decision:** The site runs on the owner's Ubuntu server as a `systemd`
  service (Puma, with Solid Queue running inside Puma), listening on a local
  port. The existing Caddy terminates TLS for prayerbookatlas.com and
  proxies to it; www, prayerbook-atlas.com, prayerbookatlas.org, and their
  www names redirect permanently to prayerbookatlas.com, and .org can be
  switched to serve the site directly as the backup domain. Deploys copy a
  built release from a clean `git archive`, never the checkout, into
  `/srv/www/prayerbookatlas.com/releases/` with a shared `storage/`, following
  the server's conventions for the owner's other sites
  (docs/deploy.md). No Docker, Kamal, or Thruster.
- **Why:** Caddy already serves the owner's other sites on that machine, and
  kamal-proxy would want ports 80 and 443 for itself. A systemd unit is the
  smallest thing that restarts on failure and logs to the journal.

## 28. Personal data stays in the person's browser

- **Date:** 2026-10-29 · **Status:** Accepted (agent, D29); replaces 3
- **Decision:** Favorites, intercessions, the rule of life, the journal,
  plan progress, and preparation for confession are kept in the person's
  own browser (IndexedDB), with export and import. The server never receives
  them unless the person later turns on account sync (BUILD.md Phase 25),
  and confession notes never leave the browser at all. Preferences the
  server needs to draw a page (book, reading settings, appearance, mode) are
  strictly necessary first-party cookies holding only those choices.
- **Why:** Privacy is pastoral care (AGENTS.md §3). Keeping the names of the
  sick and a person's self-examination off the server means there is nothing
  to leak, subpoena, or back up by mistake.

## 29. Few dependencies; Minitest and system tests

- **Date:** 2026-10-29 · **Status:** Accepted (agent); replaces 6 and 7
- **Decision:** The Gemfile holds what `rails new` put there. Every other gem,
  JavaScript package pinned by importmap, or external service needs its own
  entry here, saying why Rails cannot do the job. Never analytics,
  advertising, tracking, crash-reporting, affiliate, remote-font, or CDN
  code. Tests are Minitest (`bin/rails test`): table-driven model tests for
  every calendar, collect, and lectionary rule, each citing its book and
  page; integration tests for both modes; and system tests (Capybara with
  headless Chrome) for flows in a phone-sized and a desktop-sized window.
- **Why:** Every dependency is a supply-chain, privacy, and upgrade cost on a
  site maintained for years by agents and one owner. Rails' own test stack
  covers what the site needs.

## 30. Dates are Ruby `Date`s; the date travels in the URL

- **Date:** 2026-10-29 · **Status:** Accepted (agent); restates 8, replaces 10
- **Decision:** Church-calendar logic uses Ruby's `Date` (a civil date,
  proleptic Gregorian), never `Time`, `DateTime`, or a time zone. The
  person's local date is settled once per request: from a date in the URL,
  else from the browser's time zone (a preference cookie a small script
  sets), else from the owner's default zone, and the page says which date it
  shows. Any page can be pinned to a date with `?date=YYYY-MM-DD`, which is
  how tests, screenshots, and shared links reach Easter or an Ember Day.
- **Why:** A holy day is a calendar day, not an instant. The server cannot
  know the reader's midnight without being told, so it is told once, at the
  edge, and every engine below works on plain dates.

## 31. Nothing from anywhere else

- **Date:** 2026-10-29 · **Status:** Accepted (agent); restates 15 for the web
- **Decision:** The site loads nothing from another host: fonts, scripts,
  styles, and images are its own. A strict Content Security Policy enforces
  it (`default-src 'self'`, `object-src 'none'`, `frame-ancestors 'none'`,
  `base-uri` and `form-action` 'self', a fresh nonce per request for
  importmap's inline script and Turbo's style), with a Permissions Policy
  that asks for no device features. Tests fail if a page links a remote
  asset or the policy allows another host.
- **Why:** No third party learns who prays, when, or what. It also keeps the
  site working when other services do not.
