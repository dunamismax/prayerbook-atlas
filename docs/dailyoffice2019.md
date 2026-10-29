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

Phase 2A of BUILD.md does the study first, so later phases build on it.

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
    with the first port, BUILD.md P2A.3).
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
