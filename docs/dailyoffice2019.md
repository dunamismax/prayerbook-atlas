# The Daily Office 2019: our model and reference

Prayerbook Atlas takes [The Daily Office 2019](https://www.dailyoffice2019.com) as its model and
inspiration (BUILD.md D30, docs/decisions.md entry 32). That site, by Benjamin Locher, makes it
easy to pray the Daily Office from the Anglican Church in North America's *Book of Common
Prayer (2019)* without flipping pages, hunting for readings, or decoding rubrics. Its code is
open source at [github.com/blocher/dailyoffice2019](https://github.com/blocher/dailyoffice2019).

**How the two relate.** The Daily Office 2019 serves the 2019 book, and serves it well.
Prayerbook Atlas does the same for the other Books of Common Prayer: 1662, 1928, 1979, and, as
permission allows, the rest (D3). Each book is shown on its own terms, and the Atlas shows how
they belong together. These alternative prayer books are this site's highlight and focus. We
learn from The Daily Office 2019, take its code where it fits, credit it plainly, and make the
result our own. We never imply that its author or the ACNA endorses this site, and we never
disparage it or the 2019 book.

Phase 2A of BUILD.md did the study first (2026-10-29), so later phases build on it; §5 records it.

## 1. What it is (surveyed 2026-10-29, commit `51e6187`)

- **Stack:** a Django 6 back end (`site/`, Python, PostgreSQL, Memcached) serving a JSON API
  (`/api/v1/…`), and a Vue 3 + Vite front end (`app/`) wrapped by Capacitor for iOS and Android.
  Its calendar, office, and data were first kept in Google Sheets and are imported by management
  commands (`site/churchcal/management/commands/import_*.py`).
- **Apps worth studying:**
  - `site/churchcal/`: the church calendar. Seasons, ranks, commemorations, propers, and
    precedence (`calculations.py`, `models.py`, `utils.py` with Easter and Advent), calendar
    feeds (`calendar_feeds.py`, ICS), and Lesser Feasts and Fasts 2024 (`lff2024.csv`).
  - `site/office/`: assembling each office (`morning_prayer.py`, `evening_prayer.py`,
    `midday_prayer.py`, `compline.py`, the four Family Prayer offices, `canticles.py`,
    `alternate_readings.py`, `offices.py`), the readings and their audio, and many tests.
  - `site/psalter/`: the psalter and its 30- and 60-day cycles, including an import of the 1928
    Psalter (`import_psalms_1928.py`).
  - `site/bible/`: passage lookup from several translations.
  - `app/src/`: the reader (`views/Office.vue`, `components/Office*.vue`), the calendar, the
    settings panel, display preferences, and the design system (`styles/`, `ui/`).
- **Settings it offers** (from its live API, 2026-10-29), a good list of what people who pray
  the office want to choose: language style (contemporary or traditional), psalm and Bible
  translation, psalter cycle (30- or 60-day), reading cycle (one or two years), reading length,
  canticle rotation (traditional, seasonal, daily), alternates for Apocrypha readings, how
  psalms are said (by whole verse, by half verse, in unison), the Sunday and holy-day
  Eucharistic lectionary in place of the office's, the length of the confession's
  introduction, the absolution as said by a priest or by a deacon or lay person, the
  Invitatory at Morning Prayer, national-holiday collects, the Evening Prayer suffrages,
  additional collects (rotating or fixed), the Great Litany (which days, which ending), the
  General Thanksgiving, the Prayer of St. John Chrysostom, the Grace, and the Advent "O"
  Antiphons; and, for Family Prayer, reading length, the collect, the opening sentence, and
  the Apostles' Creed.
- **Other features:** Today, the office for the hour, the Litany, collects by category,
  commemorations with biographies, a month calendar, calendar subscriptions (ICS), psalm and
  readings pages, audio of the offices and podcasts, text size and themes, email sign-up,
  donations, and feedback.

Check every point above against the code before relying on it: the project changes often.

## 2. What we may take

- **Code: yes, under the MIT License.** The repository's `LICENSE` is MIT, "Copyright 2020
  Benjamin Locher". We may copy, port, and adapt its code, including translating Python and
  Vue into Ruby, ERB, CSS, and Stimulus, on one condition: the copyright notice and permission
  notice go with every copy or substantial portion. So:
  - The full MIT notice is kept in `THIRD_PARTY_NOTICES.md` at the repository root (created
    on 2026-10-29, BUILD.md P2A.3), with a list of the ported files that
    `test/lib/third_party_notices_test.rb` checks against the headers.
  - Every file that ports or adapts its code starts with a comment naming the source file and
    the commit, for example `# Adapted from The Daily Office 2019 (MIT),
    site/churchcal/utils.py at 51e6187.` Tests ported from it say so too.
  - The commit that brings the code in names the source file and commit in its body.
- **Ideas and features: yes.** Settings, flows, and page designs may be followed freely; say in
  the BUILD.md item where an idea came from.
- **Calendar and lectionary facts: as one source.** Names, dates, ranks, and references are
  facts, but D20 still applies: each is cited to the book itself and cross-checked against two
  independent sources. The Daily Office 2019's data can be one of the cross-checks, cited by
  file and commit, never the only source.

## 3. What we may not take

The MIT License covers the code that Benjamin Locher wrote. It does not cover the texts the
project carries, which belong to their own publishers:

- **The 2019 Book of Common Prayer** (Anglican House Publishers for the ACNA): its prayers,
  rubrics, psalter, and lectionary text. Its license forbids AI use without written permission
  (AGENTS.md §6), so agents must not read it into their work from this repository either. It
  waits for permission (D6, Phase 17).
- **Bible translations** (ESV, RSV, NRSV, NASB, NAB-RE, NVI, and others) and **hymn texts**:
  D5 governs Scripture.
- **Lesser Feasts and Fasts 2024** (Church Publishing): `lff2024.csv` and the PDF in `site/`.
- **Biographies and summaries** of commemorations, and any text marked as AI-generated: these
  are not sourced texts by our standards (AGENTS.md §6) and are not copied.
- **Audio**: its recordings and synthetic voices are not ours (D22).
- **Its look**: its typeface (Adobe Caslon Pro, a commercial font), icons, logo, and name. Our
  design is our own (D15).

Prayer-book texts, here as everywhere, are transcribed from page images of an identified
printing and proofread twice (AGENTS.md §6). The Daily Office 2019's copies of public-domain
texts are not page images and are not a source for them, though comparing against them can help
proofreading if `content/SOURCES.md` records it.

## 4. What we keep different

- **Rails, not Django and Vue** (D27, decisions 21–31). We port logic into plain Ruby engines
  (`ChurchYear::`, `Office::`, `Scripture::`, `Atlas::`) and server-rendered pages that work
  without JavaScript. We do not add Python, Node, Vue, PostgreSQL, or Memcached.
- **No analytics, crash reporting, or tracking** (decisions 29 and 31). The Daily Office 2019
  uses Firebase Analytics and its own analytics events; we take none of that.
- **No accounts or sign-up flows** before Phase 25, and personal data stays in the person's
  browser (D29).
- **Each book on its own terms** (D8). Its calendar and office logic is written for the 2019
  book. When we port a mechanism (precedence, rotations, cycles), each book's own rules are
  data for it, cited to that book's pages. The 2019 book's rules are never applied to 1662,
  1928, or 1979 unlabeled.
- **Contact.** Agents do not open issues, pull requests, or messages to the project or its
  author; any contact is the owner's (AGENTS.md §4). Linking to the site is fine and is a
  credit, not a claim of partnership.

## 5. The study (BUILD.md P2A.1, 2026-10-29, commit `51e6187`)

Cloned at `51e61877c941705f7fc44d7801642c6e94c8bea4` (2026-10-28) into the gitignored
`research/dailyoffice2019/`, never into the app. Read: `site/churchcal/` (all of it),
`site/office/` (the office modules, `canticles.py`, `alternate_readings.py`, `models.py`, the
tests' scope), `site/psalter/`, `site/bible/`, the import commands, the schema and row counts of
the SQL dumps, and the router and components of `app/src/`. The live site was used on a desktop
window and with phone emulation (375×812): Today, an office, the calendar, and Settings. Office
texts were not read for their content (§3): where the 2019 book's words appeared on screen, they
were not copied, summarized, or used.

### 5a. Feature inventory

*Adopt*: do the same. *Adapt*: do it our way (named). *Later*: worth doing, in a later phase.
*Skip*: not for this site, with the reason.

| Feature (where it lives) | Verdict | Reason and our item |
|---|---|---|
| Today opens the office for the hour (`PrayModeSwitch.vue`, the `/` route) | adapt | Today shows the office for the hour in the chosen book, decided on the server from the person's date (P6.1, P6.2); no script needed. |
| Office tabs: Morning, Midday, Evening, Compline (`/:serviceType/:office/:y/:m/:d`) | adopt | The same four, per book; a book without one says so (P7.1, P7.3). URLs as docs/urls.md. |
| Previous and next day on the office page, and a date picker | adopt | P6.3, on every day and office page. |
| "Continue to the next office" at the end (`OfficeContinue.vue`) | adopt | Morning → Noonday → Evening → Compline → tomorrow's Morning, in the person's book (P7.3). |
| Office contents with the current section marked (`OfficeContents.vue`) | adopt | Already planned for the full site's contents column (P7.3); the phone gets a sections menu. |
| Commemoration line under the day's name, with a "read the life" link | adapt | Names, ranks, and page references from each book's own calendar; no generated biographies (§3; P15.2–P15.4). |
| Sixty-day and thirty-day psalter choice, labeled on the page | adapt | Each book's own cycle as its default, labeled (1662 monthly, 1979 seven-week); any other cycle only where that book permits it (P10.4, P7.2). |
| One- or two-year reading cycle; reading length (full or abbreviated) | adapt | A setting only where a book's lectionary provides it (1979's two-year table; the 1871 and 1922 tables for 1662); never invented abbreviations (P11.1, P7.2). |
| Apocrypha alternates (`alternate_readings.py`) | adapt | Only where a book's own table gives alternates; otherwise the appointed lesson, labeled (P11.1). |
| Canticle rotation: traditional, seasonal, or table (`canticles.py`) | adapt | Each book's own rubric or table (1979's table, BCP 1979 pp. 144–145; 1662's alternatives as printed), as data (P7.2, new P7.2a). |
| Invitatory choices, suffrages A or B, additional collects, the General Thanksgiving, St. Chrysostom, the Grace | adapt | The options each book prints, by its rubrics (P7.2). |
| The Great Litany on its days, with its ending chosen (`GreatLitany`) | adopt | The 1662 rubric (Sundays, Wednesdays, Fridays) and each book's own (P7.1, P7.2). |
| National-holiday collects | adapt | Only the book's own (1928's Independence Day and Thanksgiving Day, 1979's), never another nation's (P4.4). |
| Advent "O" Antiphons named on 16–23 December (`append_o_antiphon_if_needed`) | adapt | Shown only in a book whose calendar has *O Sapientia* (1662 has it on 16 December, as a black-letter day); elsewhere not added (P4.4, P15.4). |
| Septuagesima named in a book without it (`append_seuptuagesima_if_needed`) | skip | It is a 2019 convention. Our 1662 and 1928 calendars keep Septuagesima as their own Sundays; 1979 has none (P4.3). |
| Family Prayer, four short offices (`family_*.py`) | adapt | 1928's Family Prayer and 1979's Daily Devotions for Individuals and Families, as printed (P7.6). |
| Readings page: the day's lessons and the Eucharistic readings | adopt | P6.5 (references), P10.5 (text), P11.5 (comparison across books). |
| Calendar: month grid with a day panel beside it (`Calendar.vue`) | adopt | The full site's Kalendar is a month grid with the day in the margin; the phone a list (P6.4). Red-letter days in words and symbols, never colour alone. |
| Calendar subscriptions in three scopes: major, major and minor, every day (`calendar_feeds.py`, `CalendarSubscriptionWizard.vue`) | adopt | Per book, the same three scopes, generated by our engine (P18.4). |
| Psalms index with search and topics (`Psalms.vue`, `PsalmTopic`) | adapt | Each book's Psalter with search (P10.4); topics only as an original, labeled arrangement or from a sourced list (later). |
| Collects by category (`CollectsNew.vue`) | adapt | Each book's collects in its own order (P8.3, P9.2); categories as the Atlas's works, not a new taxonomy (P12.1). |
| Display panel: text size, font, theme (`DisplayPanel.vue`) | adopt | Done (P2.6, P2.10), applied by the server. |
| Settings search box (Settings page) | later | Useful once Settings is long (P7.2); a plain filter that works without script. |
| "Book view", paginated like a printed book (`BookReader.vue`) | later | A print-like reading mode is close to our print booklet (P18.3); as a screen mode, after M2. |
| Share a link carrying one's settings (`ShareSettings.vue`) | adapt | Our URLs already carry date, book, and office; settings stay in cookies, and a share link never carries personal data (P18.5). |
| Audio: recorded and synthetic voices, podcasts (`readings_audio.py`, `tts.py`, `elevenlabs_dialogue.py`) | later / skip | Read-aloud labeled as synthetic (P23.1); no third-party voice service, recordings only from the owner (D22). |
| Liturgical colours, with alternates (`color`, `alternate_color`) | adapt | As information, labeled as custom where the book prescribes none (P4.8). |
| Fast days computed from rank and season (`fast_day`) | adapt | Each book's own table of fasts and abstinence, in its words, with the priest note; no rule computed from another book (P4.7). |
| Site messages, update notices, donation prompt, email sign-up, feedback form | skip | No pop-ups or promotions on prayer pages; no sign-ups before Phase 25; support by e-mail (SOUL.md §6; P20.2, P26.2). |
| Analytics, Firebase, error-reporting service | skip | Decisions 29 and 31. |
| AI-generated biographies, quotes, legends, foods, and images (`Commemoration.ai_*`) | skip | AGENTS.md §3 and §6: never generated hagiography, never AI images of saints. |
| Spanish and Chinese editions | later | P28.1, with cleared texts. |
| Native apps through Capacitor | skip | D27; the phone site and installable web app instead (P18.1). |

### 5b. Module map: logic worth porting

Sizes are lines at `51e6187`. "Tests" are its own tests of that logic.

| Logic | File (size) | Its tests | Lands in | Notes |
|---|---|---|---|---|
| Easter (Gregorian computus) and Advent Sunday | `site/churchcal/utils.py` (37) | none | `ChurchYear::Easter`, P4.2; `ChurchYear::Moveable`, P4.3 | Port the algorithm (the "anonymous Gregorian" form). We test it 1583–4099 and against 1662's Golden Number tables, which it never was. |
| Weekday-after arithmetic (`weekday_after`) | `utils.py` | none | P4.1 civil-date helpers | Ours in plain `Date`, no `arrow` or `Delorean`. |
| The church year as an ordered map of days, Advent to Advent (`ChurchYear`, `CalendarDate`) | `calculations.py` (887) | `test_calendar_cache.py` (cache only) | `ChurchYear::Year` and `ChurchYear::Day`, P4.10 | The shape is good: build the year once, place every observance, then apply rules day by day. Ours is pure Ruby with no database. |
| Three ways to place an observance: fixed date, days from Easter, a weekday relative to a fixed date (`SanctoraleCommemoration`, `TemporaleCommemoration`, `SanctoraleBasedCommemoration`) and "cannot occur after" | `models.py` (476) | none | content/calendar JSON schema, P4.4; P4.3 | Adopt the three placement kinds as data per book; "cannot occur after" covers Sundays after the Epiphany giving way to Septuagesima or Lent. |
| Ranks with a precedence number and a required flag | `models.py` `CommemorationRank`; data in the dumps | none | P4.6, per book | Precedence is data per book: its 2019 ranks and its 1979 ranks (from the 2020 dumps) are cross-checks for our 1979 table (BCP 1979 pp. 15–18), never applied to 1662 or 1928. |
| Transfers, including a lesser feast that must move (`process_transfers`, `handle_privileged_lesser_feast`) | `calculations.py` | none | P4.6 | Its transfer always moves to the next day and can cascade; each book's rubric decides ours, and 1662's silence is an app convention, labeled. |
| Seasons begun by named observances (`_set_season`) | `calculations.py` | none | P4.3 | Season boundaries as data per book (1662 and 1928 name no "seasons" for every week; we label ours as the book's or as convention). |
| Propers by date range for the Sundays after Pentecost (`Proper`, `_build_proper_lookup`) | `models.py`, `calculations.py` | none | P4.3, P4.9 (1979 only) | 1979's Propers 1–29 by the date ranges BCP 1979 prints; 1662 and 1928 count Sundays after Trinity instead. |
| The collect of the day: own, proper, feria (the preceding Sunday's), saint's common, fallback (`SetNamesAndCollects`) | `calculations.py` | none | P4.9 | The ordered-checks pattern ports well. Ours adds each book's rubrics: the Advent collect daily through Advent (1662), Ash Wednesday's through Lent, and the eve's collect at first Evensong. |
| First Evensong: the next day's feast taken into this evening (`check_previous_evening`) | `calculations.py` | none | P4.9, P4.10 eve flags | Adopt the idea; which days have a first Evensong is each book's rule. |
| Fast days by rank and season (`fast_day`, `fast_day_reasons`) | `calculations.py` | none | P4.7 | Skip the computation; each book's table of fasts is data. |
| Liturgical year letters and the office year (`mass_year`, `office_year`) | `calculations.py` | none | P4.10, P11.1 | Year A/B/C by Advent year mod 3 and the office year by Advent year's parity: re-derived from BCP 1979 p. 934 and p. 888, not taken on trust. |
| Canticle table by weekday and season, with a feast override (`CanticleRules`, `BCP1979CanticleTable`) | `office/canticles.py` (418) | none | `Office::Canticles`, new P7.2a | Port the mechanism. Its "1979" table maps the 2019 book's canticle numbers onto 1979's suggestions; our data comes from BCP 1979 pp. 144–145 directly, in 1979's own numbering. |
| Office assembly as an ordered list of modules (`Office.modules`, `OfficeSection.data`) | `office/offices.py` (467), `morning_prayer.py` (842), `evening_prayer.py` (689), `midday_prayer.py` (143), `compline.py` (190) | `office/tests.py` (376) | `Office::Assembler`, P7.1 | Adopt the section-by-section shape. Ours returns content ids, not text, so the assembler is pure and testable; text comes from the content database. |
| Opening sentence and invitatory antiphon by season (`MPOpeningSentence`, `MPInvitatory.antiphon`) | `morning_prayer.py` | none | P7.1 | Each book's sentences and antiphons by its own seasons. |
| Lessons: main, abbreviated, alternate, and Eucharistic (`Reading` and subclasses) | `offices.py`, `morning_prayer.py` | `test_alternate_readings.py` (505) | P7.1, P11.1 | Port the selection order; never silently swap translations (see §5d). |
| Alternate first lessons without changing the appointed table (`alternate_readings.py`) | 86 | `test_alternate_readings.py` | P11.1 | Port the guard: an alternate is used only if both offices' portions resolve, or not at all. |
| The office lectionary by civil date, with holy-day overrides (`StandardOfficeDay`, `HolyDayOfficeDay`) | `office/models.py` | none | P11.1 | The same model serves 1662/1871 (by civil date, with proper lessons for holy days). |
| Thirty-day psalter (`ThirtyDayPsalterDay`) | `office/models.py` | none | P10.4 | 1662's monthly course is the same idea: thirty days, the thirty-first repeating the thirtieth's, February's rule as 1662 prints it. |
| Psalm citation parsing (`parse_single_psalm`, `normalize_citations`) | `psalter/utils.py` (285) | none | `Scripture::Reference`, P10.1 | Ours handles verse ranges and half-verses as each book cites them. |
| Passage-to-citation formatting (`passage_to_citation`) | `office/utils.py` (409) | none | P10.5 | Each book's own reference style. |
| ICS feeds: a window of four church years, three scopes, a manifest, atomic writes (`calendar_feeds.py`) | 457 | `churchcal/tests.py` (16 tests, mostly feeds) | P18.4 | Port the window and scopes; ours generated per book from `ChurchYear::Day`, with sources in each event. |

### 5c. Data inventory

The calendar and lectionary are kept in Google Sheets (`import_*.py`, sheet ids in
`churchcal_calendar.google_sheet_id`) and arrive in the repository only as SQL dumps.

| Data | Where | Holds | Rights | Our use |
|---|---|---|---|---|
| Calendars | `churchcal_calendar` in `dailyoffice_2020_*.sql` | two calendars: `ACNA_BCP2019`, and `TEC_BCP1979_LFF2006` (1979 with Lesser Feasts and Fasts 2006) | facts | Names the 1979 calendar's existence as a cross-check. |
| Ranks and precedence | `churchcal_commemorationrank` | 15 ranks for 2019, 16 for 1979/LFF 2006 (precedence 1–10) | facts | D20 cross-check for 1979's precedence (P4.6), after BCP 1979 pp. 15–18. |
| Moveable observances | `churchcal_temporalecommemoration` (132 rows, both calendars) | name, days after Easter | facts | D20 cross-check for 1979's moveable days (P4.3). |
| Fixed observances | `churchcal_sanctoralecommemoration` (402 rows) | name, month, day, common | facts; the LFF 2006 names are Church Publishing's selection | Cross-check for 1979's fixed holy days (P4.4) only; LFF commemorations wait for P17.5. |
| Weekday-relative observances | `churchcal_sanctoralebasedcommemoration` (49 rows) | weekday, offset, anchor date | facts | Cross-check (Thanksgiving Day, Ember days). |
| Propers | `churchcal_proper` (29 rows) | number, date range | facts | Cross-check for 1979's Proper date ranges (P4.3). |
| Seasons | `churchcal_season` | name, colour, starting observance | facts and custom | Reference only (P4.8). |
| Eucharistic readings | `churchcal_massreading` | references and full text | references are facts; texts are licensed translations | References only, as a cross-check for 1979's Sunday lectionary (P9.4); never the text. |
| Daily office lectionary | `office_officeday`, `office_standardofficeday` (366), `office_holydayofficeday` | psalms, references, full text | the 2019 lectionary; licensed texts | **Not taken.** It is the 2019 book's lectionary, not any of ours. |
| Thirty-day psalter table | `office_thirtydaypsalterday` (31) | psalm numbers by day | facts | Cross-check for 1662's monthly division (P8.4), after the 1662 book itself. |
| Psalter text | `psalter_psalmverse` | the 2019 New Coverdale Psalter, a "traditional" Coverdale, Spanish, Chinese | the 2019 book's and others'; licensed | **Not taken.** |
| 1928 Psalter import | `psalter/.../import_psalms_1928.py` | scraped from episcopalnet.org | a web transcription, not page images | **Not a source** (AGENTS.md §6). |
| ESV Bible and its cross references | `site/bible/esv/*.xml`, `_crossrefs.cre.*` | the full ESV text and Crossway's cross references | Crossway's copyright | **Not taken** (D5; P10.7 needs a public-domain dataset). |
| Office texts | `site/office/api/texts/*.csv`, `templates/office/` | the 2019 book's prayers, in several languages | Anglican House; no AI use without permission | **Not read and not taken** (§3). |
| Collects | `office_collect` (via `import_collects.py`) | the 2019 book's collects | Anglican House | **Not taken.** |
| Lesser Feasts and Fasts 2024 | `site/churchcal/lff2024.csv`, `site/lesser_feasts_and_fasts_2024_-pages.pdf` | names, dates, and pages | Church Publishing | **Not taken** (P17.5 asks permission). |
| Commemoration biographies and `ai_*` fields | `churchcal_commemoration` (later dumps) | generated prose and images | not sourced texts | **Not taken.** |
| Users, sessions, admin log | `auth_user`, `django_session`, `django_admin_log` in the dumps | other people's account data | personal data | **Never opened or loaded.** The dumps are read only for the calendar tables named above. |
| Hymnal scrape | `site/hymnal/scrape.py` | hymns from the web | various | **Not taken** (Research finding 15). |

### 5d. What we do differently, and why

1. **Every book on its own calendar.** Its engine is general, but its rules are written for 2019
   (`calendar.abbreviation == "ACNA_BCP2019"` in `process_transfers`; Septuagesima and the
   O Antiphons appended by name). Ours keeps every rule as data per book, cited to the book's
   pages, with app conventions labeled (D8, P4.6).
2. **Tests before trust.** The calendar has no table-driven tests: no Easter table, no precedence
   cases, no golden years. Its 16 calendar-app tests cover the ICS feeds and text clean-up. We
   test Easter 1583–4099, every book's year for 2026–2028 and the early and late Easter years,
   and every collect key (P4.2, P4.9, P4.11).
3. **No silent translation fallback.** `OfficeDay.TRANSLATION_FALLBACKS` swaps the ESV for the
   NRSVCE where the ESV lacks a book, and the page does not always say so. Ours names the
   translation of every passage, and a missing passage says it is missing (D5).
4. **Facts, not spreadsheets.** Its calendar lives in Google Sheets, imported with an API key.
   Ours lives in `content/` as reviewed JSON with a source and page for every fact, compiled by
   `bin/rails content:compile` (P3.3, D20).
5. **HTML first.** It is a Vue app over a JSON API; with JavaScript off it shows nothing. Ours
   renders every office on the server, works without script, and enhances with Turbo and
   Stimulus (decision 25).
6. **Pure assembly.** Its office modules mix rules, database queries, and rendering. Ours keeps
   `Office::Assembler` pure (date, book, office, options → content ids), so a day's office can be
   checked against the printed book without a database (P7.1, P7.4).
7. **Quiet pages.** It shows site messages, a "new feature" banner, an audio bar, and donation
   prompts around the office. Ours keeps prayer pages free of them (SOUL.md §6).
8. **No generated hagiography.** Its commemorations carry AI-written lives and images. Ours
   carries facts from each book's calendar and original notes marked for review (P15.2).
9. **Printed pages.** It names the book but not its pages. Every block of ours carries its book,
   printing, and page (decision 11).
10. **Its data stays out of the repository.** Its SQL dumps carry other people's account data;
    ours never holds personal data on the server at all (D29), and the dumps are never copied
    into this repository.
