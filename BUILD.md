# BUILD.md: The Build Plan

This is the master plan for **Prayerbook Atlas**, a native iPhone app first,
then a web app, and perhaps one day an Android app, for Anglican and
Episcopal common prayer. It is built step by step by AI agent sessions
working under [AGENTS.md](AGENTS.md), within the faith and voice set out
there (and in SOUL.md once P1.3 writes it).

**Name:** **Prayerbook Atlas** (owner decision D1): a way to navigate the
Books of Common Prayer and their reading traditions, warm and recognizably
liturgical. Domain [prayerbookatlas.com](https://prayerbookatlas.com), with
prayerbook-atlas.com also held; support email
**support@prayerbookatlas.com** (D12). Repository
`dunamismax/prayerbook-atlas`. The app is a sister project of
[Grace & Footnotes](https://graceandfootnotes.com), the owner's website, and
shares its faith and its plain, careful voice; its visual design is its own
(D15).

The product is personal lay work, not an official publication of the Church
of England, The Episcopal Church, the Anglican Church in North America, the
Anglican Communion, or any other church, diocese, or parish.

**Origins:** the owner created this repository on 2026-10-28 and named the
app the same day. Two earlier projects of the owner's bear on it: the
retired Anglican Catholic app "Word & Altar" (repository
`anglican-catholic-app`, tag `anglican-archive`, retired 2026-09-30) and the
Orthodox app Beautiful Corner (repository `beautiful-corner`), whose
engineering foundations this plan adapts. Prayerbook Atlas starts empty;
D10 governs what may be reused from either.

---

## How agents use this file

1. Read AGENTS.md first (and SOUL.md once it exists). Then read this whole
   file once per session.
2. Work the **first open `- [ ]` item in the earliest incomplete phase**,
   skipping items whose gate is still closed (AGENTS.md §4). Items marked
   *(parallel-safe)* may be done in any order within their phase.
3. Inspect the code before trusting a checkbox. Fix drift in either direction.
4. Tick a box only when AGENTS.md §7 (definition of done) is met. Commit the
   tick with the work, using the step id in the subject (e.g. `P4.2: ...`).
5. Complete as many items as possible per session. Before stopping, run
   `make check` (once it exists), update the **Build status** table, push,
   and replace the **Handoff notes** at the bottom.
6. If an item is wrong, too large, or out of order, do not silently skip or
   delete it. Split it into sub-items (`P7.4a`, `P7.4b`), rewrite it, or add
   a note under it, and say what you changed in the Handoff notes.
7. Record history where the next agent will look for it: a dated *Note* or
   *Result* line under the item it concerns, the decision in the Owner
   decisions table or `docs/decisions.md`, the evidence in
   `content/SOURCES.md`, and the current state in the Handoff notes. Git
   keeps the rest.

Markers describe the kind of work: **[OWNER]** accounts, legal, money,
publishing, and outside contact · **[GATE Dn]** depends on an owner
decision · **[RIGHTS]** needs cleared entries in `content/SOURCES.md` ·
**[REVIEW]** theological or pastoral content · **[GATE DEMO]** begins when the
app is usable, demoable, and shareable (M2 complete and a TestFlight build),
when the requests for copyrighted texts go out (D6). D9 decides how far
agents may act on each; AGENTS.md §4 gives the working rule until it does.

---

## Build status

Update the **Done** column whenever you tick or untick a box. "Items" counts
top-level items (sub-items roll up into their parent).

| Phase | Name | Milestone | Items | Done |
|---|---|---|---|---|
| 0 | Owner foundations | — | 14 | 2 |
| 1 | Repository and toolchain | M1 Foundation | 14 | 0 |
| 2 | Design system and app shell | M1 Foundation | 14 | 0 |
| 3 | Content pipeline and rights registry | M1 Foundation | 11 | 0 |
| 4 | Church year engine | M1 Foundation | 13 | 0 |
| 5 | Today and the Kalendar | M2 The Daily Office | 6 | 0 |
| 6 | The Daily Office engine | M2 The Daily Office | 6 | 0 |
| 7 | The 1662 Book of Common Prayer | M2 The Daily Office | 10 | 0 |
| 8 | The American prayer books: 1928 and 1979 | M2 The Daily Office | 7 | 0 |
| 9 | Holy Scripture and the Psalter | M3 Word and Atlas | 8 | 0 |
| 10 | Lectionaries and reading plans | M3 Word and Atlas | 6 | 0 |
| 11 | The Atlas | M3 Word and Atlas | 7 | 0 |
| 12 | Holy Communion and the pastoral offices | M3 Word and Atlas | 5 | 0 |
| 13 | Personal life of prayer | M4 Rule of life | 13 | 0 |
| 14 | Holy days and the saints | M4 Rule of life | 6 | 0 |
| 15 | Learn: the Anglican way | M4 Rule of life | 11 | 0 |
| 16 | More prayer books, by permission | M5 Version 1.0 | 7 | 0 |
| 17 | Grace & Footnotes, sharing, and finding a church | M5 Version 1.0 | 5 | 0 |
| 18 | System integration and Apple Watch | M5 Version 1.0 | 8 | 0 |
| 19 | The public website (prayerbookatlas.com) | M5 Version 1.0 | 10 | 0 |
| 20 | Quality hardening | M5 Version 1.0 | 9 | 0 |
| 21 | Version 1.0 release | M5 Version 1.0 | 11 | 0 |
| 22 | Audio | M6 Voice | 6 | 0 |
| 23 | AI study assistant | M6 Voice | 8 | 0 |
| 24 | Server foundation | M7 Web | 6 | 0 |
| 25 | Web app | M7 Web | 8 | 0 |
| 26 | Accounts and web sync | M7 Web | 4 | 0 |
| 27 | Donations and sustainability | M8 Everywhere | 4 | 0 |
| 28 | Operations and annual maintenance | M8 Everywhere | 7 | 0 |
| 29 | Android and future platforms | M8 Everywhere | 9 | 0 |

**Current state (2026-10-28, image exports):** planning plus 54 generated
PNG design sources in `design/generated/`, with a local gallery, prompts,
and image/source registers. The owner requested this image work ahead of
Phase 1; D15 remains open. Every image is now at its requested size and the
tinted icon's mask is rebuilt, which finishes P2.2c (P2.2 stays open).
There is no code, Makefile, or app target. D1 and D12 are decided; the other
decisions retain their recommendations. Next app work remains P0.1, then
Phase 1 on the working defaults (AGENTS.md §4).

---

## The finished app

This section defines what "complete" means. Every phase below builds toward
it. When the whole plan is done, the app is:

**Every prayer book, one daily office.** A person opens the app and the
right office for the hour is ready: Morning or Evening Prayer (Mattins or
Evensong), Noonday Prayer, or Compline, with the day's sentences, psalms,
lessons, canticles, and collects already in place, from the prayer book they
choose: the Church of England's 1662, the American 1928 or 1979, and, as
permission allows, the ACNA's 2019, Canada's 1962, Common Worship, and
others. No ribbons to set, no tables to decode.

**An atlas of the prayer books.** Any prayer can be seen in every book that
has it, side by side, with the differences marked: the General Confession
from 1552 to 2019, the Prayer of Humble Access, the Te Deum, the Collect for
Purity. Each book has a page that says who authorized it, where it is used,
and which printing the app follows. A sourced map shows how the books
descend from Cranmer's 1549 and 1552. Nothing in one book is quietly filled
in from another.

**The whole Bible, and the Church's way of reading it.** Every lectionary
the books appoint (the 1662 table of lessons and its 1871 and 1922
revisions, the 1928 tables, the 1979 Daily Office Lectionary, and, by
permission, the Revised Common Lectionary and the 2019 tables), each book's
own Psalter in its own cycle, and gentle reading plans: the 1662 pattern of
the Old Testament once and the New Testament three times a year, the Psalter
monthly, M'Cheyne's plan, and others.

**Footnoted.** The Grace & Footnotes signature: every text, rule, reading,
and quotation carries its source one tap away, with the printed page number
of the book it came from, so the app and the pew book agree. Nothing is typed
from memory. Nothing is misattributed.

**The Christian year, kept accurately.** Easter and the moveable feasts,
Advent to the Sunday next before Advent, Septuagesima where a book keeps it,
red-letter and black-letter days, Ember and Rogation days, vigils, fasts, and
days of abstinence, and the collect of the day by each book's own rubrics,
tested against the printed tables.

**A rule of life, kept privately.** Favorites, an intercession list whose
names appear in the prayers, a personal rule, a journal, preparation for
confession that never leaves the device, and gentle reminders. No streaks,
no guilt (D16).

**Offline, private, and free.** Prayer never waits on the network. No
analytics, advertising, affiliate links, or tracking. No paywall on prayer
(D7).

**Beautiful because it is careful.** The look of a well-kept prayer book:
India paper, lamp-black ink, one rubric red, a gilt edge, and the season's
colour carried by a ribbon marker (D15). Quiet on prayer screens.

**A welcome for the newcomer.** Plain explanations of Mattins, Evensong,
collects, rubrics, and the seasons; how to follow along in church with a
printed book; and a pointer toward a parish and a priest, never toward the
app as a substitute.

**Everywhere the owner chooses.** iPhone first, then iPad, Apple Watch, and
widgets; a public website at prayerbookatlas.com; a web app on the same
engine; and Android if the owner chooses (D25).

### Feature map: what other apps offer, and our answer

From the App Store listings checked on 2026-10-28 (Research finding 1).

| Seen in | What it offers | Our answer (phase) |
|---|---|---|
| The Daily Office (2019 BCP) | Each office on one page, readings resolved, family prayer, searchable Psalter, collects, the Great Litany, calendar | The same ease for every book, with 2019 by permission (P6, P16) |
| Venite.app | 1979 Rite I and II, Enriching Our Worship, three psalters, read-aloud audio, bulletins, Word export | Read-aloud audio, printable office booklets, every psalter labeled (P6.5, P9.4, P22) |
| electronic Common Prayer (Church Publishing) | The 1979 book with lectionaries, Lesser Feasts and Fasts, indices, in-app purchases | The 1979 book free and complete; Lesser Feasts and Fasts by permission (P8, P16.5) |
| Daily Prayer (Church of England, Hymns Ancient & Modern) | Common Worship and BCP offices in full, NRSV readings, podcast audio | 1662 offices complete; Common Worship by permission (P7, P16.3) |
| Book of Common Prayer - BCP | The 1979 book, WEB and KJV, notes and bookmarks with iCloud backup | The same, plus every other book and the Atlas (P8, P13) |
| Common Prayer App | 1979 Rite II offices, fasting, KJV offline, licensed modern translations | Fasts and abstinence per book as information, never as a rule (P4.7) |
| The Book of Common Prayer (1789 text) | A historic American book with a KJV reader | The historic books as an honest study layer (P11.6) |

**What none of them does:** every major prayer book in one app, honest
sourcing with printed page numbers, side-by-side comparison of the same
prayer across editions, and the history of the books as a map.

### Beyond them: what the finished app adds

- **The Atlas**: compare any prayer across books, "where is this prayer?",
  book pages, and the lineage map (P11).
- **Collects resolved by each book's own rubrics**, including first Evensong
  of holy days and the Advent and Lent collects said daily (P4.9).
- **The BCP's own Easter tables** (Golden Number and Sunday Letter) as a
  second, independent computation and a teaching screen (P4.2, P5.5).
- **Printed page numbers** on every block, so the app can follow a pew book
  (P2.8).
- **An intercession list** whose names appear in the prayers where a book
  provides for them (P13.3).
- **A personal rule of life** shown on Today and never graded (P13.4).
- **Printable office booklets** with their sources (P6.5).
- **From Grace & Footnotes**: the website's writing, readable offline (P17).
- **A citation-bound AI study assistant** that knows it is not a priest (P23).
- **A public website and a web app** on the same engine (P19, P25).

---

## Product principles

`docs/product.md` (P2.1) expands these into rules for every screen.

1. **Serve prayer.** Quiet screens while praying; no interruptions.
2. **Each book on its own terms.** Show a book's text, rubrics, calendar, and
   lectionary as printed. Never fill a gap in one book with another's text
   unlabeled, and never "correct" a text toward a more familiar edition.
3. **Sources one tap away.** Every text shows its book, printing, and page.
4. **Every Anglican welcome.** Users of every book, province, and
   churchmanship are treated with equal respect; differences are described,
   not ranked (D8).
5. **Not a priest.** No absolution, dispensation, or direction; point to the
   parish priest for personal questions.
6. **No guilt mechanics.** No shaming, badges, points, or pressure (D16).
7. **Private by design.** Intentions, names, journals, and confession notes
   stay on the device unless synced by choice; confession notes never leave.
8. **Offline first.** The complete prayer, calendar, and reading experience
   works in airplane mode.
9. **Free.** No paywall on prayer, no ads, no affiliate links (D7).
10. **Welcome the newcomer.** Explain terms; never assume.

### Information architecture (proposal for P2.1)

Five tabs, each with its own navigation stack, plus the iOS search tab:

| Tab | Holds |
|---|---|
| **Today** | The day's name in the chosen book, the season's ribbon, holy days, fasts, the office for the hour, the collect, the psalms and lessons, my rule, the reading-plan portion, the next holy day |
| **Pray** | The offices, the Litany, prayers and thanksgivings, Holy Communion, the pastoral offices, devotions, my prayers, intercessions, confession preparation |
| **Bible** | The Bible reader, the day's lessons, each book's Psalter, lectionaries, reading plans |
| **Kalendar** | Month and year views, holy days and commemorations, fasts, the Easter tables |
| **Atlas** | The books and their pages, compare, "where is this prayer?", the lineage map, Learn |

Settings opens from a toolbar button. P2.1 may adjust this if testing shows
a better shape.

---

## Design system: Ribbon (proposal for D15)

D15 is open; this is the recommended direction, to be settled in a design
session that also shows two alternatives. `docs/design.md` and
`design/tokens.json` (P2.2) become the authority once written.

The materials come from a well-kept prayer book: India paper, lamp-black ink,
a single rubric red for rubrics, red-letter days, red initials, source marks,
and the one primary action; a gilt edge drawn only as a hairline; and ribbon
markers in the colours of the Church's year, the one place the season's
colour appears. The Atlas screens borrow the engraved plate of an old atlas:
double-rule frames, small-capital labels, fine hairlines. At night the page
turns to warm soot. It should feel like a fine prayer book by lamplight, not
a game, a poster, or a stained-glass gradient.

| Token | Day | Night | Use |
|---|---|---|---|
| `paper` | `#F6F2E9` | `#13110E` | Page background |
| `card` | `#FBF9F3` | `#1B1814` | Raised surfaces and sheets |
| `wash` | `#ECE6D8` | `#231F1A` | Grouped backgrounds, chips, wells |
| `line` | `#DCD3C1` | `#36302A` | Hairlines and borders |
| `ink` | `#1D1A17` | `#EDE7DB` | Body text and headings |
| `muted` | `#675F55` | `#A69E91` | Secondary text, captions, sources |
| `rubric` | `#A42A1E` | `#E2765F` | Rubrics, initials, red-letter days, source marks, primary actions |
| `onRubric` | `#FBF9F3` | `#13110E` | Text on rubric |
| `gilt` | `#A3803A` | `#CFAE63` | Ornament only; never text |

Computed contrast (WCAG 2, 2026-10-28): `ink` on `paper`, `card`, and `wash`
is at least 13.3:1 in both modes; `muted` at least 5.05:1; `rubric` at least
5.45:1; `onRubric` on `rubric` 6.27:1 or better. P2.3 turns this into a test.

**Ribbons** (season markers, always with words, never colour alone): violet,
white (ivory with a gilt edge), green, red, rose, and black, with optional
Sarum blue for Advent and unbleached Lenten array. Most prayer books do not
prescribe colours; the app labels them as custom (P4.8).

**Type.** One bundled, OFL-licensed book face for liturgical text, Scripture,
and titles, with SF for the interface; every style scales with Dynamic Type
to AX5. Candidates: Libre Caslon Text and Baskervville (John Baskerville
printed the Book of Common Prayer at Cambridge; verify the edition and date
before telling that story). EB Garamond is Beautiful Corner's face and is
avoided so the two apps stay distinct. The face must have, or P2.4 must
supply faithfully, small capitals (the 1979 Psalter's LORD), ℣ and ℟, ✠,
†, ¶, and the old-style figures used for page references.

**Motifs.** The red initial, the rubric in red (or italic, by setting), the
source mark and source sheet, the printed page number in the margin, the
ribbon marker, role labels (Minister, People, Officiant, Answer, each as the
book prints it), the colon or asterisk at the Psalter's half-verse as each
book prints it, the gilt hairline, red-letter days in the Kalendar, and the
atlas plate. Liquid Glass only on the navigation layer.

**App icon (proposal).** A closed prayer book seen at an angle, a small gilt
cross on the cover, one ribbon marker trailing from the fore-edge. Optional
seasonal icons (a different ribbon) are chosen by the user in Settings,
never switched automatically. **No compass rose:** the compass rose is the
emblem of the Anglican Communion (Research finding 11), so the obvious
"atlas" symbol would imply an endorsement the app does not have.

---

## Research findings that shape this plan

Checked 2026-10-28 unless noted. Agents must re-verify anything they depend
on and record what they checked.

1. **Other Anglican apps** (US App Store, via Apple's public lookup API).
   [The Daily Office](https://apps.apple.com/us/app/id1513851259) (The Daily
   Office, LLC; the ACNA's 2019 book; 4.9 stars from 314 ratings; version
   4.0.0 released 2026-10-28) is the strongest single-book app.
   [Venite.app](https://apps.apple.com/us/app/venite-app/id1502034358)
   (Gregory Johnston; 1979 Rite I and II, Enriching Our Worship, audio,
   bulletins; a separate
   [Common Prayer Canada](https://apps.apple.com/us/app/id1533693577) app).
   [electronic Common Prayer](https://apps.apple.com/us/app/id552932612)
   (Church Publishing; 1979 with Lesser Feasts and Fasts; 2.4 stars).
   [Daily Prayer](https://apps.apple.com/us/app/id818491760) (Hymns Ancient
   and Modern; the Church of England's official Common Worship and BCP
   offices, NRSV). [Book of Common Prayer - BCP](https://apps.apple.com/us/app/id6756549582)
   (1979, WEB and KJV). [Common Prayer App](https://apps.apple.com/us/app/id6767042681)
   (1979 Rite II, fasting). [The Book of Common Prayer](https://apps.apple.com/us/app/id1570678346)
   (a 1789 text; 1.8 stars). Each serves one book or one church. None spans
   1662, 1928, 1979, and 2019 together, compares editions, or cites printed
   pages. Trinity Broadcasting Network's "Atlas - Faith Journeys" uses the
   word "Atlas" for a devotional app; the names are distinct.
2. **Name and domains.** No App Store app is named "Prayerbook Atlas"
   (search API, US store). The owner holds **prayerbookatlas.com**
   (registered 2026-10-28 21:43 UTC) and **prayerbook-atlas.com**
   (2026-10-28 21:40 UTC), both at Cloudflare. Both resolve to the owner's
   Ubuntu server, the same address as graceandfootnotes.com and
   beautifulcorner.app; both have Cloudflare Email Routing MX records and an
   SPF record; neither answered HTTPS on 2026-10-28 (no Caddy site yet).
   prayerbookatlas.app and prayerbookatlas.org were unregistered. No
   trademark search has been done (P0.5).
3. **The Episcopal Church's prayer books.** The explanation to General
   Convention 2024 resolution D038 states that the canons make authorized
   versions of the Book of Common Prayer public domain (Canon II.3.6), and
   proposed extending this to translations
   ([D038](https://www.episcopalarchives.org/files/gc_resolutions/2024-D038.pdf)).
   Read the current canon itself in P8.1 and record its wording. The
   Episcopal Church publishes the 1979 book as a PDF
   ([2007 printing](https://www.episcopalchurch.org/wp-content/uploads/2021/02/book-of-common-prayer-2006.pdf)).
   Lesser Feasts and Fasts, Enriching Our Worship, the Book of Occasional
   Services, and the Hymnal 1982 are separate publications and presumed
   copyrighted until checked (P16.5). The 1928 book was published in 1928,
   so it is in the US public domain by age as well (US works published in
   1928 entered the public domain on 1 January 2024, and those of 1929 on 1
   January 2025); later printings carrying the revised lectionary need their
   own check.
4. **The 1662 Book of Common Prayer and the King James Version.** Both are in
   the US public domain. In the United Kingdom they remain under the Crown's
   prerogative rights, with Cambridge University Press acting as the Crown's
   patentee; UK reproduction needs its permission
   ([LibriVox's 1662 notice](https://librivox.org/the-book-of-common-prayer-1662-selections)).
   Printings differ: the sovereign's name in the state prayers changes, the
   three state services were removed in 1859, and the lectionary was
   replaced by the 1871 Revised Table of Lessons. Each printing used must be
   identified (P7.1).
5. **The ACNA's 2019 Book of Common Prayer.** Anglican House's
   [permissions page](https://anglicanhousepublishers.org/permissions/)
   allows limited liturgical and non-commercial use but says apps and digital
   tools need the publisher's permission "regardless of whether the app is
   free", forbids making complete texts available in any format, and forbids
   ingesting the book into or training any AI tool without written
   permission. Required credit: "Excerpts from The Book of Common Prayer
   (2019), Anglican Church in North America. Used by permission of Anglican
   House." The Daily Office app reports holding such permission. The New
   Coverdale Psalter's terms were not on that page; ask about it explicitly.
6. **The Church of England's Common Worship.** The
   [copyright page](https://www.churchofengland.org/copyright) says its texts
   may not be used in any software program or app without prior written
   permission from the Copyright and Contracts Administrator of the
   Archbishops' Council. Some included material belongs to other holders.
7. **The Anglican Church of Canada.** The 1962 book carries a 1962 copyright
   of the General Synod, which [anglican.ca/texts](https://www.anglican.ca/texts)
   directs to its publications office; the 1962 book remains authorized. The
   1918 Canadian book is in the US public domain by age.
8. **The Revised Common Lectionary.** The Consultation on Common Texts holds
   the copyright, permits limited local non-commercial reproduction with a
   credit line, and asks publishers and organizations to seek permission
   ([CCT sample notice](https://ms.augsburgfortress.org/downloads/RCL_DailyReadings_Expanded_Sample.pdf)).
   The Episcopal Church uses the RCL for Sundays; the 1979 book's own Sunday
   lectionary is public domain with the book.
9. **Scripture.** The KJV (with the Apocrypha) is US public domain (UK Crown
   rights, finding 4); the World English Bible, which includes the
   deuterocanonical books, is public domain. The RSV, used on Grace &
   Footnotes, the ESV, and the NRSV(ue) need licenses for an app's reader and
   readings. The prayer books' own Psalters belong to the books: Coverdale's
   in 1662 and 1928 (as each prints it), the 1979 Psalter, and the 2019 New
   Coverdale Psalter (licensed separately). Verse divisions in the BCP
   Psalters differ from the KJV's in places.
10. **Calendar facts.** Western Easter falls between 22 March and 25 April
    by the Gregorian computus; the 1662 book prints its own tables (Golden
    Number and Sunday Letter) for finding it. Season names differ by book
    (Sundays after Trinity in 1662 and 1928, after Pentecost with numbered
    Propers in 1979; Septuagesima, Sexagesima, and Quinquagesima in 1662 and
    1928 but not 1979). The 1979 Daily Office Lectionary runs on a two-year
    cycle with Year One beginning on the First Sunday of Advent preceding
    odd-numbered years (BCP 1979 p. 934; verify in P10.2). The 1662 Psalter
    is read through monthly, and its rubric appoints the Athanasian Creed on
    thirteen named feasts and the Litany on Sundays, Wednesdays, and Fridays.
11. **Church emblems.** The compass rose is the emblem of the Anglican
    Communion; the Episcopal Church, the ACNA, and the Church of England have
    their own shields and marks. The app uses none of them and avoids
    look-alikes (confirm the Communion's emblem usage terms in P2.2).
12. **AI and licensed texts.** Because Anglican House forbids AI use of the
    2019 book without permission (finding 5), the AI study assistant (P23)
    may only retrieve over texts whose licenses allow it, recorded per source
    in `content/SOURCES.md`.
13. **App Store rules.** User-generated content needs filtering, reporting,
    blocking, and published contact details (Guideline 1.2). Apps with
    account creation must offer in-app account deletion (5.1.1(v)). Nonprofit
    donations are governed by 3.2.1. A privacy policy URL is required, and a
    support URL is shown on the product page
    ([Guidelines](https://developer.apple.com/app-store/review/guidelines/)).
14. **C. S. Lewis.** His books remain under US copyright (95 years from
    publication; *Mere Christianity*, 1952, until the end of 2047). Use only
    original writing in his spirit and cite titles.
15. **Hymns and music.** Old hymn texts are often public domain, but modern
    hymnals (the Hymnal 1940 and 1982), pointed psalters, arrangements, and
    every recording carry their own rights. Use cleared texts and owner-made
    or licensed recordings only.
16. **Local toolchain** (this Mac, 2026-10-28): macOS 27.2, Xcode 27.1
    (27A9275), Swift 6.4 (swiftlang-6.4.0.34.1), XcodeGen 2.46.0, iOS 27.0
    and 27.1 simulator runtimes, Homebrew 7.0.11. Docker is not on the PATH,
    so `make test-linux` needs Colima or Docker installed first (P1.13).

---

## Owner decisions

Each open decision has a recommendation, which is the working default
until the owner answers (AGENTS.md §4). Record each answer here as
`(owner, date)`, or `(agent, date)` with reasons where D9 lets agents
decide, and record its consequences in `docs/decisions.md`.

| ID | Question | Recommendation | Decision |
|---|---|---|---|
| D1 | App name and identifiers | An original, warm, liturgical name | **Prayerbook Atlas** (owner, 2026-10-28). Working defaults until confirmed: bundle ID **`com.prayerbookatlas.app`** (the domain reversed), used as the prefix for extensions (`com.prayerbookatlas.app.widgets`), App Group `group.com.prayerbookatlas`, iCloud container `iCloud.com.prayerbookatlas`; Xcode project and scheme **`PrayerbookAtlas`**; URL scheme `prayerbookatlas`. App Store name "Prayerbook Atlas"; the Home Screen display name may truncate at 16 characters, so P1.7 checks it on device sizes and proposes a short form if needed. |
| D2 | Minimum iOS version | iOS 26, as Beautiful Corner | Open |
| D3 | Which prayer books, in what order | At launch, the three books that are public domain in the US: **1662** (England), **1928** (US), **1979** (US). By permission (D6): the ACNA's **2019**, Canada's **1962**, the Church of England's **Common Worship**, then other provinces. As a study layer in the Atlas: 1549, 1552, 1559, 1604, the 1637 Scottish book, the 1764 Scottish Communion Office, the 1789 and 1892 American books, the 1918 Canadian, the 1926 Irish, the 1928 English "deposited" book, and the 1929 Scottish book, each once its rights are cleared | Open |
| D4 | Default book and first launch | A skippable card on Today (never a modal) asks which book the person's church uses, with a plain line about each; if skipped, the preset is **1662**, the common ancestor; changeable at any time, with per-office overrides | Open |
| D5 | Scripture policy | Each office uses its own book's Psalter. The reader and lessons launch with the **KJV with the Apocrypha** and the **World English Bible**, labeled by name. Request an **RSV** license at the demo stage (matching Grace & Footnotes), and ESV and NRSV licenses for 2019 and 1979 users who expect them. Never mix translations unlabeled | Open |
| D6 | When to ask for copyrighted texts | Build with public-domain texts first; send permission requests once the app is demoable ([GATE DEMO]): Anglican House (2019 book, New Coverdale Psalter, lectionaries), the General Synod of Canada (1962), the Archbishops' Council (Common Worship), Cambridge University Press (1662 and KJV in the UK), the Consultation on Common Texts (RCL), Church Publishing (Lesser Feasts and Fasts, Enriching Our Worship), and the Bible publishers (D5). Record wanted sources in `content/SOURCES.md` as the build finds them | Open |
| D7 | Monetization | Everything free, donation-supported: no subscriptions, ads, affiliate links, or "premium" prayers; AI costs capped per user | Open |
| D8 | The app's theological voice | Each book is presented faithfully on its own terms. The app's own original teaching follows the creeds, the prayer books, and the historic formularies where Anglicans share them, within the owner's statement of faith (Grace & Footnotes SOUL.md §2), and describes differences among provinces and churchmanships accurately and charitably from their own sources. The owner's personal convictions on questions disputed among Anglicans are not app content unless the owner asks for a page on them | Open |
| D9 | Who builds and decides | As Beautiful Corner D21: agents build the app and decide open questions, recording reasons as `(agent, date)`, limited only by their host's safety rules and by honesty (never claim a review, blessing, or permission that did not happen). Until the owner answers, AGENTS.md §4 applies | Open |
| D10 | Reuse from the owner's other repositories | Copy and adapt generic engineering code from `beautiful-corner` (the content compiler, SQLite reader, `CivilDate`, scripts, Makefile and CI patterns), naming the source commit in `docs/decisions.md`. Copy no Orthodox content. Consult `anglican-catholic-app` for lessons only; any text from it must pass this repository's rights and proofreading rules as if new. Never change either repository | Open |
| D11 | Repository visibility and license | The repository was created **public** on 2026-10-28, while both sister projects are private. Recommendation: make it private, as they are, until the owner deliberately chooses open source; if it stays public, add a LICENSE (code only; texts keep their own rights) and remember that every push publishes rights research and permission drafts. Agents never change visibility themselves | Open |
| D12 | Domain and support email | prayerbookatlas.com as the canonical domain | **prayerbookatlas.com** (owner, 2026-10-28): DNS at Cloudflare, pointing at the owner's Ubuntu server; Cloudflare Email Routing with a **catch-all** forwarding every address at the domain to the owner's inbox. Support email **support@prayerbookatlas.com**; other addresses (privacy@, permissions@) arrive the same way. Receive-only: replies come from the owner's own address unless a sending service is added. **prayerbook-atlas.com** is also the owner's (same day, same server and mail setup) and is to redirect permanently to prayerbookatlas.com (P19.2). |
| D13 | Legal entity and Apple account | Develop and ship under the owner's existing individual Apple Developer membership (Team ID `D9QMP3LP8H`, renews March 13; Beautiful Corner D11), transferring later to a nonprofit if the owner forms one. Settle the EU Digital Services Act trader declaration before any EU storefront | Open |
| D14 | App Store territories | The United States first (1662 and KJV carry Crown rights in the UK); others after a rights review per territory, the UK after Cambridge University Press answers | Open |
| D15 | Visual identity | The **Ribbon** direction above, settled in a design session that also shows two alternatives, recorded in `docs/design.md` and `design/tokens.json` | Open |
| D16 | Office record and streaks | A private record of offices prayed, off by default, with no count of consecutive days | Open |
| D17 | Relationship to Grace & Footnotes | Separate name and design; shared voice and source mark; an offline reader for the website's feed; links to its gospel pages; an app page on the website only when the owner authorizes it | Open |
| D18 | Clergy review | Ask the owner's own priest about reviewing original teaching and about the app generally; record only what actually happens | Open |
| D19 | Server and web-app stack | Self-hosted on the owner's Ubuntu server behind the existing Caddy: a Swift service (Vapor, as Beautiful Corner D7, confirmed from current documentation when Phase 24 starts) rendering semantic HTML from the same packages and content database as the app, working without JavaScript; PostgreSQL only when accounts exist; nightly encrypted backups on owner-controlled infrastructure; CloudKit for users' private sync | Open |
| D20 | Calendar and lectionary facts | Facts only (names, dates, ranks, references), never prose, each cited and cross-checked against two independent sources with every difference listed, as Beautiful Corner D20 | Open |
| D21 | Rights research downloads | Agents may download candidate scans and files from the Internet Archive, HathiTrust, Google Books, eBible.org, CCEL, Project Canterbury, and first-party church sites into the gitignored `research/` folder; nothing there ships until cleared, as Beautiful Corner D19 | Open |
| D22 | Audio | On-device speech for read-aloud at first, clearly labeled as synthetic; recorded readings by the owner or a hired reader later; chant only from owner-made or licensed recordings | Open |
| D23 | AI study assistant | Yes, in a later phase: server-proxied Claude API (key never in the app), retrieval only over texts whose licenses allow it (finding 12), strict citations, free with per-user caps | Open |
| D24 | Finding a church | Link to each church's own official finder (The Episcopal Church, the ACNA, the Church of England's A Church Near You, the Anglican Church of Canada, and others); no scraped or invented directory. A curated directory only later, with permission | Open |
| D25 | Android | Not before the web app ships. Then choose between a native Android app sharing the Swift packages (through the Swift SDK for Android, if mature by then) with a Kotlin UI, and an installable web app, recorded in `docs/decisions.md` | Open |
| D26 | Public website stack | A small static site in `Website/` (semantic HTML, vanilla CSS, no JavaScript needed, no trackers, no remote fonts), built by a short script into `build/website/` and served by Caddy on the owner's server; Astro, as on Grace & Footnotes, only if the site outgrows plain pages. The web app (Phase 25) later serves its pages under the same domain | Open |

---

## Engineering foundations

These adapt Beautiful Corner's foundations (D10). P1.4 records each as an
entry in `docs/decisions.md`.

1. **XcodeGen.** The Xcode project is generated from `project.yml`; the
   `.xcodeproj` is gitignored and never hand-edited.
2. **SwiftUI with Observation.** `@Observable` for shared state; UIKit only
   through small wrappers, each with a comment explaining why.
3. **SwiftData for user data**, with a `VersionedSchema`, a migration plan,
   and CloudKit-compatible models (optional or defaulted properties, no
   unique constraints). Liturgical content never goes in SwiftData.
4. **A bundled read-only SQLite content database.** `Tools/ContentCompiler`
   validates `content/` and writes a deterministic `Content.sqlite` (system
   `SQLite3`, FTS5), refusing any content whose source is not `cleared`.
5. **Pure logic in local Swift packages**: `ChurchYear` (calendar, Easter,
   seasons, holy days, precedence, fasts, collects), `ContentKit` (content
   models, SQLite reader, search), `ScriptureKit` (canon, references,
   versification), `OfficeKit` (assembling offices and services),
   `AtlasKit` (the concordance of prayers across books and the text
   comparison), and later `SharedModels`. Linux-compatible, tested with
   `swift test` on macOS and in the `swift:6.4` container, so the server,
   web app, and any Android port share them.
6. **Zero third-party runtime dependencies** in the app unless a decision
   entry justifies one. Approved build tools: XcodeGen and Apple's bundled
   `swift format`. Never analytics, advertising, tracking, crash-reporting,
   affiliate, or remote-font SDKs.
7. **Swift Testing** for packages and unit tests; XCTest for UI tests.
   Table-driven tests across many years for every calendar and lectionary
   rule, each citing its source.
8. **Civil dates, not `Date`.** A pure `CivilDate` (year, month, day) for
   all calendar logic; convert to `Date` at the UI edge only.
9. **Our own simple formats.** Content files use `key: value` front matter
   parsed by our code (no YAML library); tables are JSON.
10. **Debug date override.** Debug builds accept `-today YYYY-MM-DD` so UI
    tests and screenshots can pin any date.
11. **Book, printing, and page on everything.** Every liturgical block knows
    the book it belongs to, the printing it was transcribed from, and its
    printed page. Texts are never shared between books by reference, even
    when identical: each book's witness is its own transcription.
12. **Works and witnesses.** The Atlas links each book's text of a prayer
    (a *witness*) to the abstract prayer (a *work*), so comparison is a
    query, not a copy.

Lessons carried from Beautiful Corner's handoff notes:

- xcodebuild prints warnings only for files it recompiles; clean or touch the
  sources before trusting "zero warnings".
- Static helpers on SwiftUI views are main-actor isolated; mark pure ones
  `nonisolated` so tests can call them.
- The simulator panel's fast swipe does not trigger SwiftUI drag gestures; a
  sampled `touch_path` does, and so do XCUITest swipes.
- UI tests must reset the state they change, and unit tests must not leak
  `UserDefaults` suites.
- Pin stored raw values (book and option identifiers) with tests so renames
  never break saved settings.
- Keep a full year's calendar computation under a measured budget and test
  it on the hosted runner too; hosted machines are slower.

### Architecture at a glance

```
┌──────────────────── iOS app (SwiftUI, Swift 6) ─────────────────────┐
│ Today · Pray · Bible · Kalendar · Atlas    Widgets · Watch · Intents  │
│     │           │         │          │           │                    │
│ ChurchYear   OfficeKit  ScriptureKit  AtlasKit   SwiftData            │
│ (Easter,     (offices,  (canon,       (works,    (favorites, rule,    │
│  seasons,     services,  references,   witnesses, intercessions,      │
│  holy days,   propers)   psalters)     compare)   journal, plans;     │
│  collects,         └──── ContentKit ────┘          iCloud private     │
│  lectionaries)     (read-only SQLite + FTS5)       sync)              │
└──────────────────────────────┬───────────────────────────────────────┘
                               │ HTTPS (later phases)
┌──────────────────────────────▼───────────────────────────────────────┐
│ Owner server (D19): Caddy → static site (P19) and Swift service (P24) │
│ prayerbookatlas.com · web app · AI proxy · accounts (optional)        │
└──────────────────────────────────────────────────────────────────────┘
Tools/ContentCompiler: content/ (sourced texts) → Content.sqlite (bundled)
```

### Milestones

- **M1 Foundation** (P1–P4): the app runs in its design, the content
  pipeline enforces rights, and the church year is correct for every book.
- **M2 The Daily Office** (P5–P8): Today, the Kalendar, and complete offices
  from 1662, 1928, and 1979 for any day. The app is demoable here.
- **M3 Word and Atlas** (P9–P12): Scripture, every lectionary and reading
  plan, the Atlas, and Holy Communion with the pastoral offices.
- **M4 Rule of life** (P13–P15): personal prayer, holy days, and Learn.
- **M5 Version 1.0** (P16–P21): more books by permission, sharing, widgets
  and Watch, the public website, hardening, and release. P16 never holds up
  the release; what permission has not cleared ships later.
- **M6 Voice** (P22–P23): audio and the AI study assistant.
- **M7 Web** (P24–P26): the server, the web app, and optional accounts.
- **M8 Everywhere** (P27–P29): sustainability, operations, Android, and more
  platforms.

---

## Phase 0: Owner foundations

- [ ] **P0.1 [OWNER]** Answer D2–D11 and D13–D26, or accept their recommendations, and record the answers above.
- [x] **P0.2 [OWNER]** Create the repository. *(Owner, 2026-10-28: `dunamismax/prayerbook-atlas`, created public; see D11.)*
- [ ] **P0.3 [OWNER] [GATE D11]** Set the repository's visibility and, if it stays public, its license.
- [x] **P0.4 [OWNER]** Register the domain and support email (D12). *(Owner, 2026-10-28: prayerbookatlas.com and prayerbook-atlas.com at Cloudflare, DNS pointed at the Ubuntu server, catch-all Email Routing; checked by `dig` the same day.)*
- [ ] **P0.5 [OWNER]** A trademark knockout search for "Prayerbook Atlas" (USPTO), recorded in `docs/decisions.md`; consider registering prayerbookatlas.app and .org defensively.
- [ ] **P0.6 [OWNER] [GATE D13]** Put the Team ID in `Config/Base.xcconfig` (a Team ID is not secret) before the first device or TestFlight build, and add the owner's Apple ID in Xcode's Settings → Accounts.
- [ ] **P0.7 [OWNER]** Create the App Store Connect record with the bundle ID from D1, reserving the name, once P1.14 can upload a build.
- [ ] **P0.8 [OWNER]** Have printed copies at hand for proofreading where scans fall short: a current 1662 (Cambridge), a 1928 (US), and a 1979 (US). *(Optional.)*
- [ ] **P0.9 [OWNER] [GATE D18]** Ask a priest about reviewing original teaching.
- [ ] **P0.10 [OWNER]** Decide the CI triggers: manual dispatch, plus pushes to `main` if the repository stays public (hosted macOS minutes are billed for private repositories).
- [ ] **P0.11 [OWNER] [REVIEW]** Approve SOUL.md once P1.3 drafts it.

When the app is demoable:

- [ ] **P0.12 [GATE DEMO]** Draft the permission requests D6 lists, each describing the app, the free and offline use, the exact texts wanted, the attribution, and the demo. Save them to `docs/owner-drafts/permission-requests.md`.
- [ ] **P0.13 [GATE DEMO]** Draft the Scripture license requests D5 lists. Save them to `docs/owner-drafts/scripture-licenses.md`.
- [ ] **P0.14 [OWNER] [GATE DEMO]** Send the requests, with a TestFlight build to show, from the owner's address (replies to permissions@prayerbookatlas.com also reach the owner), and record each response's status in `content/SOURCES.md` (letters stay off-repo).

## Phase 1: Repository and toolchain

- [x] **P1.1** Add `.gitignore`: Xcode user data, DerivedData, `build/`, `.build/`, `.swiftpm/`, generated `*.xcodeproj`, `Config/Secrets.xcconfig`, `.env*`, `*.p8`, `*.p12`, `*.cer`, `*.mobileprovision`, `.DS_Store`, `screenshots/`, `research/`, and the generated `Content.sqlite`.
- [x] **P1.2** Update `README.md`: prerequisites confirmed on this Mac, a quick start that works, and the real repository layout.
  - *2026-10-28 note:* done after P1.10, because the quick start needed the Makefile; its commands were run from clean.
- [x] **P1.3 [REVIEW]** Draft `SOUL.md`: the owner's statement of faith as Grace & Footnotes SOUL.md §2 gives it (the owner's words, unaltered), the sources and their authority, the quotation practice for this app (D5), voice and pastoral conduct, and a closing section on serving common prayer in an app (the principles above, D8's fairness among Anglicans, and AGENTS.md §3). The owner approves it (P0.11).
  - *2026-10-28 result:* drafted. §2 is Grace & Footnotes SOUL.md §2's statement and closing line (lines 21–43 at its commit fcb2a90), copied by script and checked byte-identical with `diff`. Status line says draft; approval is P0.11, still open.
- [x] **P1.4** Create `docs/decisions.md` as a numbered, append-only decision log. Seed it with the [Engineering foundations](#engineering-foundations), the deployment target (D2), the Scripture policy (D5), the no-tracking rule, and the reuse rule (D10).
- [x] **P1.5** Verify the toolchain (Research finding 16) and create `project.yml`: the app target `App` (SwiftUI lifecycle, iPhone and iPad), `AppTests`, and `AppUITests`; Swift 6 language mode; complete strict concurrency; warnings as errors for app code; project, scheme, display name, and bundle ID from D1; settings from `Config/Base.xcconfig` (marketing version, build number, `ITSAppUsesNonExemptEncryption = NO`), with a committed `Config/Secrets.xcconfig.example`.
  - *2026-10-28 result:* toolchain re-verified (macOS 27.2, Xcode 27.1 27A9275, Swift 6.4, XcodeGen 2.46.0; iOS 26.5, 27.0 and 27.1 runtimes; Colima now installed, Docker CLI not). `DEVELOPMENT_TEAM` is left commented in `Config/Base.xcconfig` for P0.6. Built with zero warnings; one Swift Testing unit test and one XCTest launch test pass.
- [x] **P1.6** Create the local packages `ChurchYear`, `ContentKit`, and `ScriptureKit` (iOS and macOS platforms, Linux-compatible sources), each with one passing Swift Testing test, and link them into `App`. (`OfficeKit` and `AtlasKit` arrive with Phases 6 and 11.)
- [x] **P1.7** A minimal app that launches to a placeholder Today showing the date in paper and ink. Run it in the simulator, take a screenshot, and check how the display name sits under the Home Screen icon (D1).
  - *2026-10-28 result:* the date only, in the Ribbon proposal's `paper`, `ink`, and `muted` (D15 working default; P2.3 regenerates them from tokens). Checked on iPhone Duo (iOS 27.1) in light, dark, and AX5 text. "Prayerbook Atlas" (16 characters) shows untruncated under the icon on iPhone 17 Pro (iOS 27.0) at the default text size, so no short form is proposed; the iPhone Duo's Home Screen could not be reached headlessly.
- [x] **P1.8** Add `.swift-format` (4-space indent, 120 columns) with `make format` and `make lint` using Xcode's `swift format`.
- [x] **P1.9** Write `scripts/sim-destination.sh`: the newest available iPhone simulator; `SIM_DEVICE` overrides it.
- [x] **P1.10** Write the `Makefile`: `help`, `generate`, `content`, `content-release`, `build`, `build-release`, `test-packages`, `test-app`, `test-linux`, `run`, `screenshot`, `check`, `format`, `lint`, and `clean`, each with a one-line description at the top.
  - *2026-10-28 result:* every target written. `content` and `content-release` print that there is no compiler yet until `Tools/ContentCompiler` exists (P3.3), then run it; `test-linux` waits on P1.13. `make clean && make check` passes with zero warnings; `run` and `screenshot` work.
- [x] **P1.11** A placeholder app icon, with dark and tinted appearances, and the rubric accent colour. The final icon is P21.8.
  - *2026-10-28 note (rewritten):* the item first asked for an icon rendered by a script from `design/icon/app-icon.svg`. The generated Ribbon icons (A1–A3, 1024×1024 light, dark, and tinted in `design/generated/`) already serve better as a placeholder, so `scripts/app-icon.sh` (`make icon`) copies them into the asset catalog unchanged, and `make guards` checks the copies stay byte-identical. The sources are untouched and stay `pending` (SOURCES.md); D15 stays open. AccentColor is the proposal's `rubric` (day `#A42A1E`, night `#E2765F`).
  - *Result:* all three renditions are in the compiled `Assets.car`; the light icon and the untruncated label were seen on the iPhone 17 Pro Home Screen. The simulator's Home Screen kept the light style in dark mode (its icon style is a separate setting `simctl` cannot change), so the dark and tinted icons were not seen rendered there.
- [x] **P1.12** Add `.github/workflows/check.yml` running `make check` on a macOS runner with Xcode 27, on the triggers P0.10 chooses.
  - *2026-10-28 result:* triggers are P0.10's recommendation as a working default (manual, and pushes to `main` while the repository is public; skipped on a private one). Hosted run 40810242713 (commit 13a7c7e, `xcode-27` image) passed `make check`. A running check now finishes rather than being cancelled by the next push.
- [x] **P1.13** Make `make test-linux` run every package's tests in the `swift:6.4` container (install Colima or Docker first; Research finding 16), and add a static guard that packages import only Linux-available modules.
  - *2026-10-28 result:* the Docker CLI (29.9.2, Homebrew) was linked and Colima started (4 CPUs, 6 GB). `make test-linux` passes every package's tests in `swift:6.4` (aarch64 Linux). `scripts/check-package-imports.sh`, from Beautiful Corner, runs in `make guards`; probes importing UIKit, and SQLite3 without `#if canImport`, made it fail. `make check` does not run `test-linux` (the hosted macOS runner has no Docker).
- [ ] **P1.14** The TestFlight path to the owner's iPhone: `make archive` and `make testflight` (a signed Release archive with release-checked content, uploaded to App Store Connect), the privacy manifest it needs, and `docs/release.md` with the one-time setup. Tick after the first build installs through TestFlight.
  - *2026-10-28 note:* prepared, waiting on the owner. `make archive`, `make testflight`, `Config/ExportOptions.plist`, the privacy manifest, and `docs/release.md` are in place; an unsigned device archive builds with zero warnings. Signing and uploading need the owner's account: P0.6, P0.7, and the steps in `docs/release.md`.

## Phase 2: Design system and app shell

- [x] **P2.1** Write `docs/product.md`: the information architecture (from the proposal above), navigation rules, the tone rules from AGENTS.md §3, "each book on its own terms", no guilt mechanics, privacy by design, and the newcomer principle.
- [ ] **P2.2 [GATE D15]** The design system.
  - [ ] **P2.2a** Hold the design session: render the Ribbon direction and two alternatives as real screens (Today, an office, the Atlas compare view) in day and night; the owner chooses (D15).
  - [x] **P2.2b** Write `docs/design.md` (tokens, contrast, type scale, motifs, ribbons, the atlas plate, layout and Liquid Glass, appearance, symbols, components, accessibility, the app icon, and the research behind them), `design/tokens.json`, and the icon sources in `design/icon/`.
    - *2026-10-28 result:* written on the Ribbon working default (D15 open; P2.2a not held). Adds ribbon hues, which BUILD.md did not specify, with computed contrast: white and Lenten array by day and black by night fall below 3:1 on paper and get a gilt edge. The icon sources are the generated A1–A5 in `design/generated/`; `design/icon/` is reserved for P21.8's Icon Composer file. Revisit both files if the owner chooses another direction.
  - [x] **P2.2c** Prepare the owner's requested image set from `design/image-prompts.md`: all 54 PNGs, master-referenced icon variants and layers, genuine alpha masks, the local gallery, and image provenance. This preparation may precede P2.2a at the owner's request; it does not settle D15 or complete Icon Composer/SF Symbols integration.
    - *2026-10-28 result:* all 54 PNGs generated and registered in `design/image-registry.json` and `content/SOURCES.md`. The generator returned the 38 square files at 1254×1254; they are now exact 1024×1024 exports (ImageMagick, Lanczos), and the tinted icon's mask was rebuilt from its 50% outline in pure white, without the haze or the partial alpha in the cross. The 15 landscape files and the portrait frame met their sizes as generated. The native squares, with their C2PA Content Credentials, stay in commit 2232e7f. Checked: sizes, alpha ranges, no pale pixels in the ink masks, registry hashes, and the gallery in a browser over local HTTP.
- [x] **P2.3** Generate the colour tokens in the asset catalog (day and night) from `design/tokens.json` by a script, so they cannot drift; expose them as named `Color` values; add the ribbon colours with their words; and test that every text pair in `docs/design.md` meets WCAG AA in both modes.
- [ ] **P2.4** Bundle the chosen OFL book face (with its licence file, recorded in `content/SOURCES.md`), check its glyph coverage (small capitals, ℣ ℟ ✠ † ¶, Greek, old-style figures), and add the type scale: display, title, heading, reading, rubric, red initial, eyebrow, role, page number, source, and source mark, all scaling with Dynamic Type to AX5; SF for interface text.
- [ ] **P2.5** Build the shared components: card, eyebrow, red initial, rubric, role label, versicle and response, Amen, repetition, name chip (intercessions), ribbon marker, gilt hairline, atlas plate, page-number margin mark, `SourceFootnote` (a rubric mark that opens a source sheet with book, printing, and page), margin note (wide layouts), empty/loading/error states, a haptics helper, and a share helper that always attaches attribution.
- [x] **P2.6** The tab structure with one `NavigationStack` per tab and the search tab; restore the selected tab and paths on relaunch.
- [x] **P2.7** `AppRoute` for every destination and the custom URL scheme (D1); every tappable destination has a route.
  - *2026-10-28 result (P2.6 and P2.7 together):* five tabs, each with a `NavigationStack`, plus search; on iPhone the search tab would push two tabs into "More", so Search is a toolbar button there (decision 17). Tab and paths restore from UserDefaults (privacy manifest now declares CA92.1). `AppRoute` covers every destination that exists (Settings, Search); later items add theirs. `prayerbookatlas://` links parse to tabs and routes. Checked: unit and UI tests (deep link to Settings, the Search button), relaunch restoration, light, dark and AX5 on iPhone 17 Pro, and the search tab on iPad.
- [ ] **P2.8** The `LiturgicalBlock` model in ContentKit: heading, paragraph, rubric, role-labeled lines as each book labels them (Minister, Priest, Officiant, People, Answer), versicle and response, Amen, the Gloria Patri marker, psalm verses with the half-verse mark as printed (colon or asterisk) and both verse numberings where they differ, canticle references, collects, alternatives ("or this"), seasonal insertion points, name insertion points (N., the sovereign, the bishop), the book, printing, and printed page of each block, and page-break hints.
- [ ] **P2.9** Build `LiturgicalTextView`, rendering `[LiturgicalBlock]` with Dynamic Type to AX5, VoiceOver that announces roles and reads rubrics as instructions, page numbers in the margin, and text selection and copy.
- [ ] **P2.10** Reading settings: text size, line spacing, rubrics in red or italic, show or hide rubrics, show page numbers, keep the screen awake while praying, and original or modernized spelling (historic books only, P11.6).
- [ ] **P2.11 [GATE D4]** First-launch setup, skippable and changeable in Settings: the person's prayer book, with a line about each; nothing is required to begin praying.
- [ ] **P2.12** Settings: prayer book and per-office overrides, reading settings, notifications, appearance (Automatic, Day, Night), acknowledgements and sources (generated from the content database once P3.8 lands), the non-affiliation statement, "About this app" (sister of Grace & Footnotes), support (support@prayerbookatlas.com), and version and build.
- [x] **P2.13** Create a String Catalog (`Localizable.xcstrings`) and route every interface string through it (English only for now).
  - *2026-10-28 result:* `make strings` syncs the compiler-extracted strings into the catalog (`scripts/sync-strings.sh`, from Beautiful Corner); `make check` fails when it is stale (probed). 17 strings so far. English-only entries compile to nothing in the bundle, as expected; `.lproj` files appear with the first translation.
- [ ] **P2.14** A UI test that launches, visits every tab, opens Settings, and switches appearance, capturing screenshots as attachments.

## Phase 3: Content pipeline and rights registry

- [ ] **P3.1** Create `content/SOURCES.md` with a documented schema (id, title, book and printing, year, publisher, obtained-from URL or scan, jurisdiction, rights basis per territory, AI-use permission, what was checked, status). Add "Original work (owner)", `pending` entries for the public-domain candidates in Research findings 3, 4, 7, and 9, and a **Wanted** section for the requests in D6.
- [ ] **P3.2** Write `docs/content-format.md`: UTF-8 text files with `key: value` front matter and a line syntax for every `LiturgicalBlock` kind; ids for books and printings (for example `bcp1662`, `bcp1928us`, `bcp1979us`); the `work` key that links a witness to its work (P11.1); required keys (`id`, `book`, `printing`, `page`, `source`, `kind`, `translation` for Scripture, `review` for original work); JSON tables for calendars and lectionaries.
- [ ] **P3.3** Build `Tools/ContentCompiler` (a Swift executable package): parse and validate `content/` and write a deterministic `Content.sqlite` with a schema version, text tables, and an FTS5 index. Fail on unknown sources, duplicate ids, unresolved references, and original works without `review`. Release mode fails on uncleared sources; `--allow-pending` downgrades that to a warning for development.
- [ ] **P3.4** The book guard: every liturgical text names its book, printing, and page; a text may not be placed in a book it was not transcribed from; and a source cleared for one territory is not treated as cleared for another (D14).
- [ ] **P3.5** The Scripture guard (D5): every Scripture item names its `translation`; only allowed translations are accepted; licensed translations have verse ceilings (configurable, below each gratis limit) unless `SOURCES.md` records a license, and their notices appear in the acknowledgements.
- [ ] **P3.6** The quotation and image registries: every quotation names its author, work, edition, and location from a `cleared` source; every image (title pages, engravings, portraits) records its source, creator, date, holder, and rights basis; AI-generated sacred images are rejected.
- [ ] **P3.7** The ContentKit SQLite reader: read-only, prepared statements, an actor-isolated async API, and tests against a fixture database; confirm FTS5 at runtime on iOS.
- [ ] **P3.8** Build integration: `make content` writes `App/Resources/Content.sqlite` (gitignored); `make build` and `make check` depend on it; an Xcode build phase fails clearly if it is missing. Generate Settings → Acknowledgements from the database's sources.
- [ ] **P3.9** Ranked full-text search with highlighted snippets and filters by book and kind (office, prayer, collect, psalm, Scripture, lesson, rubric), with tests.
- [ ] **P3.10** A content-integrity suite in `make check`: unique ids, resolved references, registered sources, no empty blocks, every block with a book, printing, and page.
- [ ] **P3.11** Write `docs/proofreading.md`: two independent passes against the page images, a word-level diff between them, how differences are settled, the record in `SOURCES.md`, and the errata process for users' reports (support@prayerbookatlas.com).

## Phase 4: Church year engine (ChurchYear)

Cite the governing source (book and page) for every rule in
`docs/calendar-rules.md`. Mark any rule without a printed source as an "app
convention" and say why it was chosen.

- [ ] **P4.1** `CivilDate` (year, month, day) with weekday, day arithmetic, comparisons, `Codable` and `Sendable`, and Julian Day Number conversion (D10 permits adapting Beautiful Corner's). Exhaustive tests.
- [ ] **P4.2** Western Easter by the Gregorian computus, tested 1583–4099 against an authoritative table, and independently by the 1662 book's own tables and rules (Golden Number, Sunday Letter), the two required to agree for every year the tables cover.
- [ ] **P4.3** The moveable cycle per book: Advent Sunday; the Sundays after Christmas and after the Epiphany (and how surplus Sundays are handled); Septuagesima, Sexagesima, and Quinquagesima where the book keeps them; Ash Wednesday and Lent; Holy Week; Easter; Rogation Sunday and the Rogation Days; Ascension; Whitsunday or Pentecost; Trinity Sunday; the Sundays after Trinity or after Pentecost with 1979's Propers by date; and the Sunday next before Advent.
- [ ] **P4.4** The fixed holy days of each launch book (D3) as facts in `content/calendar/<book>.json` (date, name, rank as the book gives it, page), including red-letter and black-letter days where the book distinguishes them.
- [ ] **P4.5 [GATE D20]** Compile each book's lesser commemorations as facts only (names, dates, ranks), cited and cross-checked against two independent sources with every difference listed.
- [ ] **P4.6** Precedence and transfer per book: 1979's rules (Principal Feasts, Sundays, Holy Days, and the rest) as printed; 1662's and 1928's from their rubrics, with app conventions documented where the books are silent (for example a holy day on a Sunday).
- [ ] **P4.7** Fasts and abstinence per book, as information only: 1662's Table of Vigils, Fasts, and Days of Abstinence (including Ember and Rogation days), 1928's table, and 1979's days of special devotion, each with the book's own words and page and a line that one's parish priest may counsel differently.
- [ ] **P4.8** Liturgical colours, as information, labeled as custom where the book prescribes none, with an optional Sarum sequence; off by default.
- [ ] **P4.9** The collect of the day per book from its rubrics: the Sunday collect serving the week; the Advent and Ash Wednesday collects said daily through their seasons in the books that direct it; holy-day collects and their eves (first Evensong); and precedence between them. A test that every collect key for a year resolves.
- [ ] **P4.10** The public API `ChurchDay`: (date, book) → the day's name, season, week, colour, holy days and commemorations with ranks, collect keys, fast and abstinence notes, lectionary keys, Ember and Rogation flags, and eve flags. Deterministic, `Sendable`, cached per year.
- [ ] **P4.11** Golden files: full-year outputs for 2026, 2027, and 2028, an early-Easter year (2008, 23 March), and a late-Easter year (2038, 25 April) for each launch book, checked by `GoldenTests` and confirmed against printed tables.
- [ ] **P4.12** Performance: a full year for every book computes within a measured budget (start at 50 ms) on the simulator and the hosted runner; the package tests pass on Linux.
- [ ] **P4.13** Write `docs/calendar-rules.md`: every rule, its source, and its test.

## Phase 5: Today and the Kalendar

- [ ] **P5.1** The Today screen: the day's name in the chosen book (with the other launch books' names one tap away), the ribbon, holy days, fast and abstinence notes, the office for the hour, the collect, the psalms and lessons (references now, text from P9), and slots for my rule (P13.4) and the reading-plan portion (P10.4), plus the next holy day with no countdown.
- [ ] **P5.2** Day navigation: swipe or arrow between days, a date picker, and a Today button; midnight rollover and time-zone changes; the Debug `-today` override.
- [ ] **P5.3** The Kalendar: a month grid with red-letter days in red and marked by a symbol too (never colour alone), a list mode, a year jump, and quick jumps to Advent, Ash Wednesday, and Easter.
- [ ] **P5.4** The day page (`prayerbookatlas://kalendar/YYYY-MM-DD`): everything Today shows, for every launch book, with the source of each rule.
- [ ] **P5.5** The Easter tables screen: Easter and the moveable feasts for any year, the year's Golden Number and Sunday Letter, and the 1662 book's own tables explained.
- [ ] **P5.6** UI tests: open specific dates (Easter 2027, Ash Wednesday 2028, Septuagesima in 1662, Proper 28 in 1979, an Ember Day) and assert their titles.

## Phase 6: The Daily Office engine (OfficeKit)

- [ ] **P6.1** The office assembly engine: (date, book, office, options) → an ordered list of content ids with the day's propers (sentences, invitatory and its seasonal forms, psalms, lessons, canticles, the creed, suffrages, collects, the state prayers, the Litany where appointed). Pure and tested. A book without an office (Compline in 1662) returns "not in this book", never another book's office.
- [ ] **P6.2** The options model per book: Rite I or II (1979), canticle choices, the Athanasian Creed on its days (1662), the Litany days, Suffrages A or B, said or sung forms, and the state prayers' form (the convention P7.9 records).
- [ ] **P6.3** The office reader: continuous scroll, a section index, page numbers, inline choices, lessons from the Bible store and psalms from the book's own Psalter, a saved position, and keep-awake.
- [ ] **P6.4** Snapshot tests: the assembled id lists for forty representative days per launch book (ordinary Sundays, holy days, Lent, Holy Week, Easter week, Ember Days, eves), each checked by hand against the printed book, with every id resolving.
- [ ] **P6.5** Print or export an office as a PDF booklet with its sources and the required notices, for cleared texts only.
- [ ] **P6.6** Family prayer and short forms where a book provides them (1928's family prayer, 1979's Daily Devotions for Individuals and Families).

## Phase 7: The 1662 Book of Common Prayer

- [ ] **P7.1 [RIGHTS]** Identify the printing(s): page images of a printing carrying the 1871 lectionary (Internet Archive or HathiTrust), and the current Cambridge text for comparison; record the edition, scan URLs, and the rights basis (US public domain; UK Crown rights, Research finding 4) as `pending`, then clear for the US.
- [ ] **P7.2** Transcribe and proofread (P3.11) Morning and Evening Prayer with all canticles, the Litany, and the Prayers and Thanksgivings upon Several Occasions.
- [ ] **P7.3** The Collects, Epistles, and Gospels for the year, as printed in the book.
- [ ] **P7.4** The Psalter (Coverdale) in its thirty-day cycle, with the book's rules for the thirty-first day and February and its proper psalms.
- [ ] **P7.5 [GATE D20]** The Kalendar and lectionary as facts: the 1871 Revised Table of Lessons (default), the 1922 table (option), and the original 1662 table (historical), cross-checked against two sources.
- [ ] **P7.6** The Order for the Administration of the Lord's Supper, or Holy Communion, to follow and to prepare.
- [ ] **P7.7** The occasional offices for study and preparation: Baptism (three forms), the Catechism, Confirmation, Matrimony, the Visitation and Communion of the Sick, Burial, the Thanksgiving of Women after Child-birth, the Commination, the Forms of Prayer to be Used at Sea, the Ordinal, the Articles of Religion, and the Table of Kindred and Affinity.
- [ ] **P7.8** The Creed of Saint Athanasius and the days its rubric appoints.
- [ ] **P7.9** The state prayers: record in `docs/decisions.md` how the app names the sovereign and offers other forms, and implement it.
- [ ] **P7.10** The complete proofreading record in `SOURCES.md`, and a book page for the Atlas (P11.3).

## Phase 8: The American prayer books: 1928 and 1979

- [ ] **P8.1 [RIGHTS]** Identify and clear the printings: the 1928 (and which lectionary revision it carries) and the 1979 (the Episcopal Church's PDF of the 2007 printing, checked against a printed copy), reading Canon II.3.6's current text and recording it (Research finding 3).
- [ ] **P8.2** 1928: Morning and Evening Prayer, family prayer, the Litany, the Prayers and Thanksgivings, the Collects, Epistles, and Gospels, the Psalter in the book's selections and monthly cycle, and the tables of lessons as facts (D20).
- [ ] **P8.3** 1979: the Daily Office in Rite I and Rite II, Noonday Prayer, An Order of Worship for the Evening, Compline, the Daily Devotions, the Great Litany, the collects in both languages, the Psalter (half-verse asterisks, LORD in small capitals), and the two-year Daily Office Lectionary as facts.
- [ ] **P8.4** 1979: the Holy Eucharist in Rite I and Rite II, the Proper Liturgies for Special Days, and the 1979 Sunday lectionary as facts (the RCL arrives by permission, P16.6).
- [ ] **P8.5** 1979 and 1928 pastoral offices and catechisms for study: Holy Baptism, Confirmation, Marriage, the Thanksgiving for the Birth or Adoption of a Child, the Reconciliation of a Penitent, Ministration to the Sick, Burial, the Offices of Instruction (1928), An Outline of the Faith (1979), and the 1979 Historical Documents.
- [ ] **P8.6** 1928 Holy Communion and its Propers.
- [ ] **P8.7** The proofreading records and book pages for both.

## Phase 9: Holy Scripture and the Psalter

- [ ] **P9.1** ScriptureKit: the canon as Anglican Bibles print it (Old Testament, the Apocrypha as Article VI lists it, New Testament), every abbreviation the books' tables use, ranges and cross-chapter ranges, and the verse mapping between each BCP Psalter and the KJV. Extensive tests.
- [ ] **P9.2 [RIGHTS] [GATE D5]** A `ScriptureProvider` protocol with an offline store and attribution metadata, and the launch texts: the KJV with the Apocrypha and the World English Bible from identified digital editions, proofread on samples against printed editions, imported by `make bible`, and cleared in `SOURCES.md`.
- [ ] **P9.3** The Bible reader: books and chapters, go-to reference, verse selection, share with the required notice, reading settings, and search.
- [ ] **P9.4** The Psalter for prayer: each book's Psalter in its own cycle (1662 monthly, 1979 seven-week, and the others as printed), switchable, with the book's pointing marks.
- [ ] **P9.5** Lessons in the offices rendered from the store in the reader's chosen translation, labeled, with each book's own reference style.
- [ ] **P9.6** Required notices on every screen that shows licensed Scripture, and acknowledgements entries.
- [ ] **P9.7 [RIGHTS]** Cross references from a cleared public-domain dataset (for example the Treasury of Scripture Knowledge).
- [ ] **P9.8 [RIGHTS] [GATE DEMO]** Licensed translations as licenses arrive (D5), as options in reading settings, with their notices and the guard's ceilings lifted only as each license allows.

## Phase 10: Lectionaries and reading plans

- [ ] **P10.1** The lectionary model in ChurchYear: civil-date tables (1662/1871), week-and-day tables (1979), and proper-based tables, all resolving to `(office, lesson, reference)` for a date and book.
- [ ] **P10.2 [GATE D20]** Golden lectionary files for 2026–2028 per launch lectionary, cross-checked against two independent sources with every difference listed.
- [ ] **P10.3** Reading plans: each launch lectionary as a plan, the 1662 pattern (Old Testament once, New Testament three times a year), the Psalter monthly and in seven weeks, Robert Murray M'Cheyne's calendar (1842), the Gospels in Lent, and the Bible in a year (an original arrangement, labeled).
- [ ] **P10.4** The plan screen: today's portion, an optional private mark, "begin from today" at any time, and no streaks, catch-up pressure, or scores (D16).
- [ ] **P10.5** A lectionary comparison: the same day's readings in every book, side by side.
- [ ] **P10.6** `docs/lectionaries.md`: each lectionary's source, cycle, rules, and tests.

## Phase 11: The Atlas

- [ ] **P11.1** AtlasKit: works and witnesses (Engineering foundation 12), a concordance file mapping the launch books' prayers, canticles, creeds, and rites to works, and tests that every mapped witness resolves.
- [ ] **P11.2** The compare view: two or three witnesses side by side, word-level differences marked (an alignment that ignores spelling and punctuation variants on request), page references, and sources.
- [ ] **P11.3 [REVIEW]** Book pages: each book's history, who authorized it and where it is used today, its contents, and the printing the app follows, with sources.
- [ ] **P11.4 [REVIEW]** The lineage map: a sourced genealogy of the Books of Common Prayer drawn as an atlas plate, every edge citing a source.
- [ ] **P11.5** "Where is this prayer?": from any prayer, its witnesses in every book, or a plain note of its absence.
- [ ] **P11.6 [RIGHTS] [GATE D3]** The historic study layer (D3): identify and clear each book's printing (US public domain by age), transcribe, proofread, and show in original spelling with an optional modernized display.
- [ ] **P11.7 [REVIEW]** A timeline of the prayer book, Cranmer to today, each entry sourced and linked to its book page.

## Phase 12: Holy Communion and the pastoral offices

- [ ] **P12.1** Follow-along Holy Communion in each launch book with the day's propers (collect, epistle, gospel, proper preface).
- [ ] **P12.2** Holy Week and Easter across the books: the propers, the Proper Liturgies (1979), and what each book appoints.
- [ ] **P12.3** The pastoral offices index for study and preparation, each with a line to speak with the parish priest.
- [ ] **P12.4 [RIGHTS]** Preparation for Holy Communion and thanksgiving afterwards, from the books and cleared devotional sources, private.
- [ ] **P12.5 [REVIEW]** A newcomer's guide to the Eucharist in Anglican worship (1662, 1928, Rite I and Rite II): what happens and why, how to take part, and who may receive by the church's own rule (for The Episcopal Church, Canon I.17.7), linking to Grace & Footnotes' next-steps page.

## Phase 13: Personal life of prayer

- [ ] **P13.1** Versioned SwiftData with a migration plan: Favorite, Bookmark, Intercession, IntercessionGroup, RuleItem, JournalEntry, PlanProgress, ReadingPosition, OfficeRecord, MyPrayer, and Reminder, all CloudKit-compatible; preserve each shipped schema version.
- [ ] **P13.2** Favorites and bookmarks for every kind of content.
- [ ] **P13.3** The intercession list: names in groups and cycles (daily, weekly), read in place at the name insertion points a book provides, and a plain list to print.
- [ ] **P13.4** My rule of life: the offices, Communion, reading, fasting, and giving the person chooses, shown on Today; nothing graded.
- [ ] **P13.5** A journal with an optional Face ID or passcode lock.
- [ ] **P13.6 [REVIEW]** Preparation for confession: the Reconciliation of a Penitent (1979) for preparation, an original explanation of private confession in Anglican practice, and an examination of conscience (the Commandments, the Summary of the Law, the Beatitudes). The checklist stays on the device only, is never synced or sent, and can be erased with one tap. The app never pronounces absolution.
- [ ] **P13.7 [GATE D16]** The office record, as D16 decides.
- [ ] **P13.8** Local notifications: office times, holy days, plan portions, and custom reminders; permission asked in context; Focus modes respected; wording gentle.
- [ ] **P13.9 [OWNER]** Create the iCloud container (D1) and enable the capability.
- [ ] **P13.10** iCloud sync through the CloudKit private database, tested offline and with conflicts; confession notes excluded.
- [ ] **P13.11** Export my data (JSON) and delete all my data, both in Settings.
- [ ] **P13.12** My Prayers: user-written prayers, stored locally, that can be ordered and added to a rule.
- [ ] **P13.13 [RIGHTS] [REVIEW]** Devotions, labeled as private devotion rather than prayer-book text and by the tradition that keeps them (for example the Angelus and the Anglican rosary), from cleared sources only.

## Phase 14: Holy days and the saints

- [ ] **P14.1** The commemoration model: names, dates per book, rank as each book gives it, collect keys, and sources.
- [ ] **P14.2 [REVIEW]** Short original notes for the red-letter days (the apostles, evangelists, and the feasts of our Lord), each fact sourced.
- [ ] **P14.3** Holy-day pages: the collect in each book, the readings, the note, and the sources.
- [ ] **P14.4 [REVIEW]** The black-letter days of the 1662 Kalendar explained as facts with sources.
- [ ] **P14.5 [RIGHTS] [GATE DEMO]** Other books' calendars of commemorations as permission allows (Lesser Feasts and Fasts, the 2019 calendar).
- [ ] **P14.6** Reminders for holy days and for personal days (a baptism or confirmation anniversary), stored privately.

## Phase 15: Learn: the Anglican way

- [ ] **P15.1 [REVIEW]** "New to the prayer book": how the offices work, how the year turns, how to follow a service with a printed book (page numbers), and how to find a parish.
- [ ] **P15.2 [REVIEW]** The catechisms (1662, the 1928 Offices of Instruction, the 1979 Outline of the Faith) with original notes.
- [ ] **P15.3 [REVIEW]** The creeds (Apostles', Nicene, Athanasian) in each book's wording, with original line-by-line notes.
- [ ] **P15.4 [REVIEW]** The Thirty-Nine Articles (the 1662 text and the American form of 1801) with historically careful notes that give each article its place among the formularies today.
- [ ] **P15.5 [REVIEW]** The Anglican Communion and its churches explained fairly: provinces, The Episcopal Church, the ACNA and its relationships, the Continuing churches, and the Chicago-Lambeth Quadrilateral.
- [ ] **P15.6 [REVIEW]** A glossary (Mattins, Evensong, collect, canticle, rubric, red-letter day, Ember Days, Rogation, Septuagesima, ordinary, and many more).
- [ ] **P15.7 [REVIEW]** The history of the prayer book, linked to the Atlas.
- [ ] **P15.8 [REVIEW]** Common questions, representing other Christian traditions fairly.
- [ ] **P15.9 [REVIEW]** Reading guides to C. S. Lewis's books: original notes only, no Lewis text (Research finding 14).
- [ ] **P15.10** The AI-assistance disclosure on every screen of original teaching (AGENTS.md §3).
- [ ] **P15.11** Unified search across Learn, the books, Scripture, and the Atlas.

## Phase 16: More prayer books, by permission [GATE DEMO]

Each item follows Phase 7's pattern: printing identified, permission recorded,
transcription proofread, calendar and lectionary as facts, golden files, Atlas
integration, and the required credit line. None holds up version 1.0.

- [ ] **P16.1 [RIGHTS]** The ACNA's 2019 book: the offices, the New Coverdale Psalter, the lectionaries, the calendar, and Holy Communion; marked as excluded from AI use unless the permission says otherwise (Research finding 12).
- [ ] **P16.2 [RIGHTS]** Canada's 1962 book (and the 1918 book, which needs no permission, in the study layer).
- [ ] **P16.3 [RIGHTS]** The Church of England's Common Worship offices and lectionary.
- [ ] **P16.4 [RIGHTS]** Other provinces' books as permission arrives (for example Ireland, Scotland, Australia, New Zealand, Kenya, and Southern Africa).
- [ ] **P16.5 [RIGHTS]** The Episcopal Church's supplements from Church Publishing: Lesser Feasts and Fasts, Enriching Our Worship, and the Book of Occasional Services.
- [ ] **P16.6 [RIGHTS]** The Revised Common Lectionary (the Consultation on Common Texts).
- [ ] **P16.7 [RIGHTS]** The 1662 book and the KJV for UK users, after Cambridge University Press answers (D14).

## Phase 17: Grace & Footnotes, sharing, and finding a church

- [ ] **P17.1 [GATE D17]** "From Grace & Footnotes": fetch `https://graceandfootnotes.com/feed.xml` with our own parser, cache it for offline reading, show articles in the app's style, and open the full page in Safari.
- [ ] **P17.2** Link the website's gospel presentation (`/gospel`) and next-steps page from Learn and the newcomer's guides.
- [ ] **P17.3** Share cards for collects, verses, and prayers, typeset in the app's style with attribution and the app's name.
- [ ] **P17.4** A bookshelf: plain links to the publishers of the books and to good editions, with no affiliate tracking.
- [ ] **P17.5 [GATE D24]** "Find a church": links to each church's official finder, opened in Safari, with a line on what to expect at a first visit.

## Phase 18: System integration and Apple Watch

- [ ] **P18.1 [OWNER]** Register the App Group identifier (D1).
- [ ] **P18.2** Widgets: the day and its ribbon, the collect of the day, the lessons, and the next office; Lock Screen accessories.
- [ ] **P18.3** StandBy and a quiet bedside Compline widget.
- [ ] **P18.4** App Intents and App Shortcuts: "Pray Morning Prayer", "Pray Evening Prayer", "What is today's collect?", "Today's readings", and "What day is it in the Church's year?".
- [ ] **P18.5** Control Center and Lock Screen controls and the Action button (open the office for now).
- [ ] **P18.6** Spotlight indexing of prayers, collects, holy days, and Learn articles.
- [ ] **P18.7** An Apple Watch app: today, the collect, a short office, and complications.
- [ ] **P18.8** Deep links through the custom scheme, and universal links through `apple-app-site-association` on prayerbookatlas.com (P19.6).

## Phase 19: The public website (prayerbookatlas.com) [GATE D26]

The public face of the app: what it is, how to get it, how to reach the
owner, and the legal pages the App Store requires. It is not the web app
(Phase 25), which later joins it on the same domain. P19.1–P19.5 may be done
at any time after M1, ahead of their turn, because external TestFlight and
App Review need a privacy policy and a support page.

- [ ] **P19.1** The site's decision entry (D26) and `Website/` source: semantic HTML, vanilla CSS from the app's tokens (generated from `design/tokens.json`, never copied by hand), the bundled book face self-hosted, no JavaScript required, no trackers or remote assets, light and dark, readable on phones, and a `make website` target that builds `build/website/` and checks every link.
- [ ] **P19.2 [OWNER]** Serve it: a Caddy site file for prayerbookatlas.com and www (added beside the server's existing sites, never replacing them), HTTPS, permanent redirects from www and from prayerbook-atlas.com, security headers, and a deploy that copies only the built site (never the checkout as a web root). Document it in `docs/website.md`.
- [ ] **P19.3** The home page: what the app is, the books it carries (only those actually shipped or in TestFlight, never promised ones as present), screenshots in day and night, the non-affiliation statement, and the App Store link once it exists.
- [ ] **P19.4** The support page (`/support`): support@prayerbookatlas.com, how to report a text error (book, page, and what is wrong), what the app collects (nothing, D7), and frequently asked questions.
- [ ] **P19.5** The privacy policy (`/privacy`) and terms of use (`/terms`) drafted from the real data flows in `docs/legal/` and published here. **[OWNER]** approves them.
- [ ] **P19.6** `/.well-known/apple-app-site-association` for universal links (P18.8), served with the right content type.
- [ ] **P19.7** The sources page (`/sources`): the books, printings, translations, and permissions the app uses, generated from `content/SOURCES.md`, with every required credit line.
- [ ] **P19.8** A press page (`/press`): the icon, screenshots, a short description, and contact, all owner-approved.
- [ ] **P19.9** Sharing previews (Open Graph and Twitter card tags with a static image), `robots.txt`, a sitemap, a favicon set, and a custom 404 page.
- [ ] **P19.10** A website check in `make check`: links, HTML validity, the token CSS in step with `design/tokens.json`, and no external requests; and a post-deploy check of the live site's status codes, redirects, and headers.

## Phase 20: Quality hardening

- [ ] **P20.1** A full VoiceOver pass on every screen: labels, traits, and reading order.
- [ ] **P20.2** Dynamic Type at AX5 on every screen; Reduce Motion; Reduce Transparency; contrast in both modes.
- [ ] **P20.3** A pseudo-localization run (double-length strings, right-to-left) to catch layout breakage before other languages arrive.
- [ ] **P20.4** Performance: launch time, scrolling in long offices, database size, and memory, with baselines in `docs/performance.md`.
- [ ] **P20.5** An airplane-mode test of every offline feature.
- [ ] **P20.6** A MetricKit subscriber for on-device crash and hang diagnostics (no third-party crash SDK).
- [ ] **P20.7** iPad layouts: sidebar navigation, readable widths, margin notes, and the compare view in columns.
- [ ] **P20.8** A security pass: no secrets in the binary, App Transport Security defaults, Keychain use, file-protection classes, and private data excluded from backups where appropriate.
- [ ] **P20.9** UI tests covering every critical flow in M1–M5.

## Phase 21: Version 1.0 release

- [ ] **P21.1 [OWNER]** Confirm the App Store Connect record (P0.7), the bundle ID, and the capabilities (iCloud, App Group).
- [ ] **P21.2** The privacy manifest (`PrivacyInfo.xcprivacy`) with accurate required-reason API declarations.
- [ ] **P21.3** Privacy and support URLs live on prayerbookatlas.com (P19.4, P19.5).
- [ ] **P21.4** The privacy nutrition label (target: "Data Not Collected"), age rating, and export-compliance answers in `docs/app-store/`.
- [ ] **P21.5** The App Store metadata: name, subtitle (30 characters at most), description with the non-affiliation statement, keywords, support URL `https://prayerbookatlas.com/support`, privacy URL, marketing URL, and review notes.
- [ ] **P21.6** Automated screenshots by UI tests for the required device sizes, in light and dark.
- [ ] **P21.7** The rights audit: generate `docs/rights-audit.md` from `SOURCES.md`, with every shipped item `cleared` for every storefront (D14).
- [ ] **P21.8 [OWNER]** Approve the final app icon as an Icon Composer file.
- [ ] **P21.9 [OWNER] [REVIEW]** Theological sign-off on every [REVIEW] item, with a priest where possible (D18).
- [ ] **P21.10 [OWNER]** A TestFlight beta, internal then external, with users of each launch book. Agents triage feedback into BUILD.md items.
- [ ] **P21.11 [OWNER]** Submit version 1.0 for review and release, and update the website (P19.3).

## Phase 22: Audio [GATE D22]

- [ ] **P22.1** Read-aloud with on-device speech, labeled as synthetic, following the office line by line with the current line marked.
- [ ] **P22.2** The audio engine: background audio, Now Playing and remote commands, AirPlay, speed, a sleep timer, resume, and offline downloads.
- [ ] **P22.3** Write `docs/audio-production.md`: scripts, recording guidelines, loudness, encoding, naming, and the work-for-hire checklist.
- [ ] **P22.4 [OWNER]** Record or commission the first set: Morning and Evening Prayer and Compline in one book.
- [ ] **P22.5 [RIGHTS]** Chant and sung settings only from owner-made or licensed recordings (Research finding 15).
- [ ] **P22.6** CarPlay audio (an Apple entitlement request, **[OWNER]**).

## Phase 23: AI study assistant [GATE D23]

- [ ] **P23.1** Write `docs/ai-assistant.md`: scope (study help on Scripture, the prayer books, doctrine, history, and parish life), what it is not (a priest, a confessor, an authority), crisis handling, privacy (retention, deletion, no training use), and cost caps.
- [ ] **P23.2 [REVIEW]** Draft the system prompt from SOUL.md and D8. **[OWNER]** approves it.
- [ ] **P23.3** A server proxy to the Claude API (current model ids from the official documentation when building) with streaming, per-user caps, and the key only on the server (after P24).
- [ ] **P23.4** Retrieval over cleared content whose AI-use permission allows it (Research finding 12), with citations that deep-link into the app.
- [ ] **P23.5** Text integrity: the model emits reference tags, and the app renders Scripture and prayer-book text from its own store; generated text is never shown as Scripture or as a book's text.
- [ ] **P23.6** An evaluation suite of 150 or more cases (faithfulness to the creeds, fairness among Anglican traditions and to other Christians, refusing to speak as God or a saint, crisis responses, citation accuracy, humility), run on every prompt or model change.
- [ ] **P23.7** The chat screen: sources under each answer, an "AI study assistant, not a priest" label, report an answer, and delete a conversation.
- [ ] **P23.8** An optional on-device helper with Apple's Foundation Models for small offline tasks, adopted only if its quality is verified.

## Phase 24: Server foundation [GATE D19]

- [ ] **P24.1** A decision entry for the server: framework and version, database, SQL approach, and every approved dependency, confirmed from current official documentation.
- [ ] **P24.2** `Packages/SharedModels`; the `Server/` package with environment configuration, structured logging, `/health`, and graceful shutdown.
- [ ] **P24.3** `make server-run` and `make server-test`; server tests in `make check`.
- [ ] **P24.4** API conventions: `/v1`, a JSON error envelope, rate limits, request-size limits, ETags, and pagination.
- [ ] **P24.5** Write `docs/deploy.md` for the owner's Ubuntu server: a systemd unit, the service behind Caddy under prayerbookatlas.com beside the static site (P19.2), log rotation, the firewall, unattended upgrades, backups, and a restore procedure. **[OWNER]** deploys.
- [ ] **P24.6** The app's `APIClient`: async URLSession, retries with backoff, an offline cache, and typed errors.

## Phase 25: Web app

- [ ] **P25.1** A decision entry: a server-rendered web app from the same server and packages (D19), styled from the same tokens, with no third-party browser dependencies or remote fonts.
- [ ] **P25.2** Pages that work without JavaScript: Today, the Kalendar and day pages, the offices for any date and book, the Bible and the day's lessons, and the Psalter.
- [ ] **P25.3** The Atlas on the web: book pages, compare, and the lineage map.
- [ ] **P25.4** Print styles, so any office prints as a clean booklet with its sources.
- [ ] **P25.5** Calendar subscriptions (`.ics`) of each book's holy days.
- [ ] **P25.6** Settings kept in a cookie-free way (the URL or local storage) for the book and options; no account needed.
- [ ] **P25.7** Accessibility and performance budgets for the web, checked in `make check`.
- [ ] **P25.8** Cross-links with Grace & Footnotes, authorized by the owner (D17).

## Phase 26: Accounts and web sync

- [ ] **P26.1 [OWNER]** Decide whether the web app needs accounts at all; if not, mark this phase not needed and stop.
- [ ] **P26.2** Sign in with Apple on the web and in the app; opaque session tokens, hashed at rest; the minimum stored.
- [ ] **P26.3** Sync of favorites, plans, and the rule between the web and the app; intercessions and confession notes never leave the device.
- [ ] **P26.4** In-app and web account deletion (Guideline 5.1.1(v)); update the privacy policy and label. **[OWNER]** approves.

## Phase 27: Donations and sustainability [GATE D7]

- [ ] **P27.1** Confirm the current App Review rules for donations (Guideline 3.2.1) and record the approach.
- [ ] **P27.2** A quiet "Support this work" page in the app and on the website: what gifts pay for, never on a prayer screen, never with urgency.
- [ ] **P27.3 [OWNER]** The giving route (Apple nonprofit approval, or a Safari link).
- [ ] **P27.4** Per-user caps for the AI assistant and other costly services, with honest messages when a cap is reached.

## Phase 28: Operations and annual maintenance

- [ ] **P28.1** Write `docs/operations.md`: the incident runbook, a quarterly backup-restore drill, and the support inbox routine.
- [ ] **P28.2** Annual verification: each autumn, compare next year's computed calendars and lectionaries with printed tables and fix discrepancies with tests.
- [ ] **P28.3** A yearly platform upgrade after each September Xcode release: new SDK, deprecations, the deployment target (D2), and a full `make check`.
- [ ] **P28.4** A yearly rights review: every license's term, territory, and credit line still current.
- [ ] **P28.5** An errata routine: user reports of text errors checked against the page images and fixed with a note in `SOURCES.md`.
- [ ] **P28.6 [OWNER]** Renew the Apple Developer Program membership before **March 13** each year (D13).
- [ ] **P28.7 [OWNER]** Renew prayerbookatlas.com and prayerbook-atlas.com before **October 28** each year (Cloudflare; auto-renew recommended).

## Phase 29: Android and future platforms

The owner decides priority; promoted items become full phases.

- [ ] **P29.1 [GATE D25]** The Android decision entry, then an Android app or installable web app as decided, sharing the engine and content database.
- [ ] **P29.2** A native Mac app through SwiftUI multiplatform.
- [ ] **P29.3 [RIGHTS]** Other languages with cleared liturgical texts (for example Spanish, French, Swahili, and Chinese editions of the books) and parallel bilingual display.
- [ ] **P29.4 [RIGHTS]** Hymns: public-domain texts keyed to the day, with tunes named; modern hymnals only by license.
- [ ] **P29.5 [RIGHTS]** Pointed psalters and Anglican chant settings.
- [ ] **P29.6 [RIGHTS]** Research the Anglican Breviary, the Monastic Diurnal, and the Anglican and English Missals (publication dates, renewals, and current holders) before considering them.
- [ ] **P29.7** Diocesan cycles of prayer, by permission.
- [ ] **P29.8** A visionOS reading experience.
- [ ] **P29.9** A curated parish directory, only with the churches' permission (D24).

---

## Handoff notes

*Replaced each session; keep under 25 lines. History lives in Git.*

- **2026-10-28, image exports:** finished P2.2c. The 38 square PNGs, which
  the generator returned at 1254×1254, are now exact 1024×1024 exports
  (ImageMagick 7.1.2-34, Lanczos, metadata stripped). The 15 landscape files
  and the portrait frame were already the requested size and are unchanged.
- A3's mask was rebuilt: native alpha upsampled to 8192 px, thresholded at
  50%, box-filtered to 1024; RGB pure white. Four regions only (background,
  book, cross cutout, ribbon); the outline differs from the native one by 76
  pixels. The haze and the partial alpha in the cross are gone.
- `design/image-registry.json` records new hashes, sizes, and each export
  step; `original_sha256` names the native files, which stay in commit
  2232e7f with their C2PA Content Credentials (the exports drop that chunk).
- Re-checked all 38: 1024×1024, alpha 0–255 where transparent, still no pale
  pixels in the B/C/D/E4 ink masks, and registry hashes match.
- The gallery now loads in a browser over local HTTP: 54 images at their
  recorded sizes, 31 night samples. Fixed its CSS so A3 shows on the night
  colour instead of the checkerboard.
- Still open: A4/A5 alignment in Icon Composer (P21.8); tracing the symbols
  (P2.5); D15; release clearance for every image (P3.6).
- No Makefile or app exists, so `make check` and simulator flows cannot run.
- Next app work: P0.1, then P1.1 on working defaults. D1/D12 decided; all
  other decisions open. Repository visibility remains D11; no settings changed.
