# BUILD.md: The Build Plan

This is the master plan for **Prayerbook Atlas**, a website for Anglican and
Episcopal common prayer across the Books of Common Prayer, at
[prayerbookatlas.com](https://prayerbookatlas.com). It is built in Ruby on
Rails, desktop first with a dedicated phone site, step by step by AI agent
sessions working under [AGENTS.md](AGENTS.md), within the faith and voice set
out there and in [SOUL.md](SOUL.md).

**Name:** **Prayerbook Atlas** (owner decision D1): a way to navigate the
Books of Common Prayer and their reading traditions, warm and recognizably
liturgical. Canonical domain **prayerbookatlas.com**; **prayerbookatlas.org**
is the backup domain and **prayerbook-atlas.com** is also held, both
redirecting to it (D12). Support email **support@prayerbookatlas.com**.
Repository `dunamismax/prayerbook-atlas`. The site is a sister project of
[Grace & Footnotes](https://graceandfootnotes.com), the owner's website, and
shares its faith and its plain, careful voice; its visual design is its own
(D15).

The product is personal lay work, not an official publication of the Church
of England, The Episcopal Church, the Anglican Church in North America, the
Anglican Communion, or any other church, diocese, or parish.

**Origins:** the owner created this repository on 2026-10-28 and named the
project the same day. It began as a native iPhone app: a SwiftUI shell, the
Engraved Plate design system, and a first TestFlight build were finished by
2026-10-29. That day the owner chose to make it a website only, built with
Ruby on Rails (D27). The iPhone app is retired and kept in Git at the tag
`ios-archive` (commit `a9be149`); step ids in commits before that tag
(P1.1–P2.14 and so on) refer to the retired plan, not to the items below.
Two earlier projects of the owner's bear on it: the retired Anglican Catholic
app "Word & Altar" (repository `anglican-catholic-app`, tag
`anglican-archive`) and the Orthodox app Beautiful Corner (repository
`beautiful-corner`). D10 governs what may be reused from either.

---

## How agents use this file

1. Read AGENTS.md and SOUL.md first. Then read this whole file once per
   session.
2. Work the **first open `- [ ]` item in the earliest incomplete phase**,
   skipping items whose gate is still closed (AGENTS.md §4). Items marked
   *(parallel-safe)* may be done in any order within their phase.
3. Inspect the code before trusting a checkbox. Fix drift in either direction.
4. Tick a box only when AGENTS.md §7 (definition of done) is met. Commit the
   tick with the work, using the step id in the subject (e.g. `P4.2: ...`).
5. Complete as many items as possible per session. Before stopping, run
   `bin/ci`, update the **Build status** table, push, and replace the
   **Handoff notes** at the bottom.
6. If an item is wrong, too large, or out of order, do not silently skip or
   delete it. Split it into sub-items (`P7.4a`, `P7.4b`), rewrite it, or add
   a note under it, and say what you changed in the Handoff notes.
7. Record history where the next agent will look for it: a dated *Note* or
   *Result* line under the item it concerns, the decision in the Owner
   decisions table or `docs/decisions.md`, the evidence in
   `content/SOURCES.md`, and the current state in the Handoff notes. Git
   keeps the rest.

Markers describe the kind of work: **[OWNER]** accounts, legal, money,
publishing, the server, and outside contact · **[GATE Dn]** depends on an
owner decision · **[RIGHTS]** needs cleared entries in `content/SOURCES.md` ·
**[REVIEW]** theological or pastoral content · **[GATE DEMO]** begins when the
site is usable, demoable, and shareable (M2 complete and deployed to
prayerbookatlas.com), when the requests for copyrighted texts go out (D6). D9
decides how far agents may act on each; AGENTS.md §4 gives the working rule.

---

## Build status

Update the **Done** column whenever you tick or untick a box. "Items" counts
top-level items (sub-items roll up into their parent).

| Phase | Name | Milestone | Items | Done |
|---|---|---|---|---|
| 0 | Owner foundations | — | 14 | 8 |
| 1 | Rails foundation | M1 Foundation | 12 | 12 |
| 2 | Design system and site shell | M1 Foundation | 14 | 11 |
| 3 | Content pipeline and rights registry | M1 Foundation | 11 | 0 |
| 4 | Church year engine | M1 Foundation | 13 | 0 |
| 5 | Hosting at prayerbookatlas.com | M1 Foundation | 7 | 1 |
| 6 | Today and the Kalendar | M2 The Daily Office | 7 | 0 |
| 7 | The Daily Office engine and reader | M2 The Daily Office | 6 | 0 |
| 8 | The 1662 Book of Common Prayer | M2 The Daily Office | 10 | 0 |
| 9 | The American prayer books: 1928 and 1979 | M2 The Daily Office | 7 | 0 |
| 10 | Holy Scripture and the Psalter | M3 Word and Atlas | 8 | 0 |
| 11 | Lectionaries and reading plans | M3 Word and Atlas | 6 | 0 |
| 12 | The Atlas | M3 Word and Atlas | 7 | 0 |
| 13 | Holy Communion and the pastoral offices | M3 Word and Atlas | 5 | 0 |
| 14 | Personal life of prayer | M4 Rule of life | 11 | 0 |
| 15 | Holy days and the saints | M4 Rule of life | 6 | 0 |
| 16 | Learn: the Anglican way | M4 Rule of life | 11 | 0 |
| 17 | More prayer books, by permission | M5 Version 1.0 | 7 | 0 |
| 18 | The web platform: offline, install, print, share | M5 Version 1.0 | 9 | 0 |
| 19 | Grace & Footnotes, sharing, and finding a church | M5 Version 1.0 | 5 | 0 |
| 20 | Public pages and legal | M5 Version 1.0 | 8 | 0 |
| 21 | Quality hardening | M5 Version 1.0 | 10 | 0 |
| 22 | Version 1.0 launch | M5 Version 1.0 | 7 | 0 |
| 23 | Audio | M6 Voice | 5 | 0 |
| 24 | AI study assistant | M6 Voice | 8 | 0 |
| 25 | Accounts and sync | M7 Accounts and sustainability | 5 | 0 |
| 26 | Donations and sustainability | M7 Accounts and sustainability | 4 | 0 |
| 27 | Operations and annual maintenance | M8 Ongoing | 8 | 0 |
| 28 | Future directions | M8 Ongoing | 8 | 0 |

**Current state (2026-10-29):** the project is now a Rails 8.1.4 website
(D27). The iPhone app is retired (tag `ios-archive`). The Rails app runs in
both modes (the full site and the phone site) with placeholder sections, the
Engraved Plate tokens as CSS, and self-hosted Cardo; `bin/ci` passes. No
liturgical text is on the site, and nothing is deployed yet.

---

## The finished site

This section defines what "complete" means. Every phase below builds toward
it. When the whole plan is done, prayerbookatlas.com is:

**Every prayer book, one daily office.** A person opens the site and the
right office for the hour is ready: Morning or Evening Prayer (Mattins or
Evensong), Noonday Prayer, or Compline, with the day's sentences, psalms,
lessons, canticles, and collects already in place, from the prayer book they
choose: the Church of England's 1662, the American 1928 or 1979, and, as
permission allows, the ACNA's 2019, Canada's 1962, Common Worship, and
others. No ribbons to set, no tables to decode.

**Two ways to the same pages.** On a desktop or tablet browser, the **full
site**: a wide, unhurried reading column with the book's contents beside it
and a margin for sources, notes, and parallel texts; the Atlas comparing up to
three books side by side; the Kalendar as a month grid; keyboard navigation;
and print-ready booklets. On a phone, the **phone site**: one column sized for
the hand, a tab bar of the five sections within reach of a thumb, sources and
notes folded under the text, and an installable, offline-capable web app.
Both are drawn by the same server from the same content, at the same URLs; a
person can switch between them from any page (D27, docs/product.md §1).

**An atlas of the prayer books.** Any prayer can be seen in every book that
has it, side by side, with the differences marked: the General Confession
from 1552 to 2019, the Prayer of Humble Access, the Te Deum, the Collect for
Purity. Each book has a page that says who authorized it, where it is used,
and which printing the site follows. A sourced map shows how the books
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
and quotation carries its source one click away, with the printed page number
of the book it came from, so the site and the pew book agree. Nothing is
typed from memory. Nothing is misattributed.

**The Christian year, kept accurately.** Easter and the moveable feasts,
Advent to the Sunday next before Advent, Septuagesima where a book keeps it,
red-letter and black-letter days, Ember and Rogation days, vigils, fasts, and
days of abstinence, and the collect of the day by each book's own rubrics,
tested against the printed tables.

**A rule of life, kept privately.** Favorites, an intercession list whose
names appear in the prayers, a personal rule, a journal, preparation for
confession that never leaves the person's own browser, and gentle reminders.
No streaks, no guilt (D16).

**Private and free.** No analytics, advertising, affiliate links, or
tracking, and no paywall on prayer (D7). Every page that sets out prayer works
without JavaScript, and once visited it can be prayed again offline.

**Beautiful because it is careful.** Engraved Plate (D15): chart paper,
iron-blue ink, double-rule frames, small capitals, and one cartographer's
blue, with the season's colour carried by a ribbon marker. Quiet on prayer
pages, by day and by night.

**A welcome for the newcomer.** Plain explanations of Mattins, Evensong,
collects, rubrics, and the seasons; how to follow along in church with a
printed book; and a pointer toward a parish and a priest, never toward the
site as a substitute.

### Feature map: what others offer, and our answer

From the App Store listings checked on 2026-10-28 and the websites checked on
2026-10-29 (Research finding 1).

| Seen in | What it offers | Our answer (phase) |
|---|---|---|
| The Daily Office (2019 BCP) | Each office on one page, readings resolved, family prayer, searchable Psalter, collects, the Great Litany, calendar | The same ease for every book, with 2019 by permission (P7, P17) |
| Venite.app | 1979 Rite I and II, Enriching Our Worship, three psalters, read-aloud audio, bulletins, Word export | Read-aloud audio, printable office booklets, every psalter labeled (P18.3, P10.4, P23) |
| electronic Common Prayer (Church Publishing) | The 1979 book with lectionaries, Lesser Feasts and Fasts, indices, in-app purchases | The 1979 book free and complete; Lesser Feasts and Fasts by permission (P9, P17.5) |
| Daily Prayer (Church of England) | Common Worship and BCP offices in full, NRSV readings, podcast audio | 1662 offices complete; Common Worship by permission (P8, P17.3) |
| Book of Common Prayer - BCP | The 1979 book, WEB and KJV, notes and bookmarks | The same, plus every other book and the Atlas (P9, P14) |
| Common Prayer App | 1979 Rite II offices, fasting, KJV offline, licensed modern translations | Fasts and abstinence per book as information, never as a rule (P4.7) |
| The Book of Common Prayer (1789 text) | A historic American book with a KJV reader | The historic books as an honest study layer (P12.6) |
| The Daily Office (web) | The 2019 offices, a "Book view", audio, settings kept in the browser | The same calm for every book, as HTML that works with no script (P7, P2.10) |
| Venite and Forward Movement (web) | 1979 offices with many liturgies, Bible versions, psalters, and display settings | Each book's own Psalter and lectionary, labeled; reading settings applied by the server (P2.10, P10.4, P11) |
| Mission St. Clare (web) | A static page per day for the 1979 offices | Static-fast pages for every book, with sources and page numbers (P7, P2.9) |
| justus.anglican.org, Lynda Howell's 1662 (web) | Public-domain prayer books in plain HTML, with notes on sources | Every printing identified and proofread, and compared in the Atlas (P3, P8, P12) |
| Oremus (web) | Daily prayer, a Bible browser, an almanac | The same, with no affiliate links or analytics (D7, decision 31) |

**What none of them does:** every major prayer book in one place, honest
sourcing with printed page numbers, side-by-side comparison of the same
prayer across editions, and the history of the books as a map, on a site
that works on any computer and any phone.

### Beyond them: what the finished site adds

- **The Atlas**: compare any prayer across books, "where is this prayer?",
  book pages, and the lineage map (P12).
- **A desktop reading experience** with the margin beside the text: sources,
  page numbers, notes, and the same passage in another book (P2, P7).
- **Collects resolved by each book's own rubrics**, including first Evensong
  of holy days and the Advent and Lent collects said daily (P4.9).
- **The BCP's own Easter tables** (Golden Number and Sunday Letter) as a
  second, independent computation and a teaching page (P4.2, P6.6).
- **Printed page numbers** on every block, so the site can follow a pew book
  (P2.8).
- **An intercession list** whose names appear in the prayers where a book
  provides for them (P14.3).
- **Printable office booklets** with their sources, from the browser's own
  print (P18.3).
- **Calendar subscriptions** of each book's holy days (P18.4).
- **From Grace & Footnotes**: the website's writing, linked and summarized
  (P19).
- **A citation-bound AI study assistant** that knows it is not a priest (P24).

---

## Product principles

`docs/product.md` expands these into rules for every page.

1. **Serve prayer.** Quiet pages while praying; no interruptions.
2. **Each book on its own terms.** Show a book's text, rubrics, calendar, and
   lectionary as printed. Never fill a gap in one book with another's text
   unlabeled, and never "correct" a text toward a more familiar edition.
3. **Sources one click away.** Every text shows its book, printing, and page.
4. **Every Anglican welcome.** Users of every book, province, and
   churchmanship are treated with equal respect; differences are described,
   not ranked (D8).
5. **Not a priest.** No absolution, dispensation, or direction; point to the
   parish priest for personal questions.
6. **No guilt mechanics.** No shaming, badges, points, or pressure (D16).
7. **Private by design.** Intentions, names, journals, and confession notes
   stay in the person's own browser unless synced by choice; confession notes
   never leave it (D29).
8. **Works everywhere.** Every prayer page is semantic HTML that works without
   JavaScript, in any browser, at any text size; JavaScript only adds to it.
9. **Desktop first, phone well.** The full site is the complete experience;
   the phone site is a dedicated design for the hand, never a squeezed
   desktop (D27).
10. **Free.** No paywall on prayer, no ads, no affiliate links (D7).
11. **Welcome the newcomer.** Explain terms; never assume.

### Information architecture

Five sections, the same in both modes (docs/product.md §1):

| Section | Holds |
|---|---|
| **Today** | The day's name in the chosen book, the season's ribbon, holy days, fasts, the office for the hour, the collect, the psalms and lessons, my rule, the reading-plan portion, the next holy day |
| **Pray** | The offices, the Litany, prayers and thanksgivings, Holy Communion, the pastoral offices, devotions, my prayers, intercessions, confession preparation |
| **Bible** | The Bible reader, the day's lessons, each book's Psalter, lectionaries, reading plans |
| **Kalendar** | Month and year views, holy days and commemorations, fasts, the Easter tables |
| **Atlas** | The books and their pages, compare, "where is this prayer?", the lineage map, Learn |

Search and Settings are reachable from every page: in the masthead on the
full site, from the phone bar on the phone site.

---

## Research findings that shape this plan

Checked 2026-10-28 unless noted. Agents must re-verify anything they depend
on and record what they checked.

1. **Other Anglican apps** (US App Store, via Apple's public lookup API).
   [The Daily Office](https://apps.apple.com/us/app/id1513851259) (The Daily
   Office, LLC; the ACNA's 2019 book; 4.9 stars from 314 ratings) is the
   strongest single-book app.
   [Venite.app](https://apps.apple.com/us/app/venite-app/id1502034358)
   (Gregory Johnston; 1979 Rite I and II, Enriching Our Worship, audio,
   bulletins). [electronic Common Prayer](https://apps.apple.com/us/app/id552932612)
   (Church Publishing; 1979 with Lesser Feasts and Fasts).
   [Daily Prayer](https://apps.apple.com/us/app/id818491760) (Hymns Ancient
   and Modern; the Church of England's Common Worship and BCP offices, NRSV).
   [Book of Common Prayer - BCP](https://apps.apple.com/us/app/id6756549582)
   (1979, WEB and KJV). [Common Prayer App](https://apps.apple.com/us/app/id6767042681)
   (1979 Rite II, fasting). [The Book of Common Prayer](https://apps.apple.com/us/app/id1570678346)
   (a 1789 text). Each serves one book or one church; none spans 1662, 1928,
   1979, and 2019 together, compares editions, or cites printed pages.
   **Websites** (P1.12, checked 2026-10-29 in the in-app browser and by
   fetching each page; "no script" means the page's text arrived with
   JavaScript off):
   - [The Daily Office](https://www.dailyoffice2019.com/) (a personal project
     sponsored by Anglican House): the 2019 book's offices, Family Prayer,
     readings, a "Book view", audio, many settings kept in the browser. ESV
     and NRSV by permission, with their notices; the New Coverdale Psalter
     or the Traditional Language Edition's Coverdale. Names the book, not
     its pages. A script-drawn app (the HTML holds only a loader).
   - [Venite](https://www.venite.app/) (sponsored by Forward Movement): 1979
     Rite I and II, Enriching Our Worship, the Daily Devotions, Lesser Feasts
     and Fasts, nineteen liturgies; eight Bible versions; four psalters
     (1979, Coverdale, Common Worship, an inclusive psalter); the 1979, 1662,
     and RCL lectionaries; Spanish. A script-drawn app.
   - [Forward Movement's Daily Prayer](https://prayer.forwardmovement.org/):
     1979 Rite I and II, Daily Devotions, readings, a prayer list,
     reminders; NRSV, RSV, or KJV; the 1979 or Coverdale Psalter; display
     settings (four modes, five sizes, two faces). A script-drawn app.
   - [Mission St. Clare](https://www.missionstclare.com/english/): 1979 Rite
     II Morning and Evening Prayer as one static HTML page per day (works
     with no script), Noonday and Compline, a Spanish edition, an iPhone
     app. Neither the book's pages nor the Bible translation is named on the
     office page.
   - [The Society of Archbishop Justus](http://justus.anglican.org/resources/bcp/)
     (Charles Wohlers; last updated 2018): several dozen prayer books by
     province, public-domain texts only, with a copyright note on its basis
     (age, missing notices, unrenewed copyrights); copyrighted books are
     linked to their publishers. No script; no phone layout.
   - [Lynda Howell's 1662](http://www.eskimo.com/~lhowell/bcp1662/): the
     whole book in HTML, its base text the 1987 Cambridge edition, with
     the 1662 King's Printers' copy (EEBO, Wing B3622) for the Act of
     Uniformity and the state services; a sources page, search, and an
     Easter almanac; printers' errors corrected, and the author does not
     recommend it for scholarly use. No script; no phone layout.
   - [Oremus](https://www.oremus.org/) (Steve Benner and Simon Kershaw,
     since 1993): daily prayer, a Bible browser, Common Worship and 1662
     links, a calendar and almanac. Its home page carries an Amazon
     affiliate search and a third-party analytics image. No phone layout.
   **What the survey shows:** the 1979 and 2019 are well served, and the
   best of them are script-drawn apps; no site sets the books side by side,
   cites a printed page, or keeps 1662 and 1928 as complete daily offices
   with their own calendars; the static sites that work everywhere are old,
   desktop-only, and single-purpose. Prayerbook Atlas's place is the
   honesty of the old sites with the ease of the new apps, in HTML that
   needs no script.
2. **Name and domains.** No App Store app is named "Prayerbook Atlas"
   (search API, US store). The owner holds **prayerbookatlas.com**
   (registered 2026-10-28 21:43 UTC) and **prayerbook-atlas.com**
   (2026-10-28 21:40 UTC), both at Cloudflare, both resolving to the owner's
   Ubuntu server (the same address as graceandfootnotes.com and
   beautifulcorner.app), with Cloudflare Email Routing MX records and an SPF
   record; neither answered HTTPS on 2026-10-28. The owner added
   **prayerbookatlas.org** on 2026-10-29 (Cloudflare, created 09:28 UTC); its
   DNS was not yet answering that day. prayerbookatlas.app was not bought.
3. **The Episcopal Church's prayer books.** The explanation to General
   Convention 2024 resolution D038 states that the canons make authorized
   versions of the Book of Common Prayer public domain (Canon II.3.6), and
   proposed extending this to translations
   ([D038](https://www.episcopalarchives.org/files/gc_resolutions/2024-D038.pdf)).
   Read the current canon itself in P9.1 and record its wording. The
   Episcopal Church publishes the 1979 book as a PDF
   ([2007 printing](https://www.episcopalchurch.org/wp-content/uploads/2021/02/book-of-common-prayer-2006.pdf)).
   Lesser Feasts and Fasts, Enriching Our Worship, the Book of Occasional
   Services, and the Hymnal 1982 are separate publications and presumed
   copyrighted until checked (P17.5). The 1928 book is in the US public
   domain by age (US works published in 1928 entered the public domain on 1
   January 2024); later printings carrying the revised lectionary need their
   own check.
4. **The 1662 Book of Common Prayer and the King James Version.** Both are in
   the US public domain. In the United Kingdom they remain under the Crown's
   prerogative rights, with Cambridge University Press acting as the Crown's
   patentee; UK reproduction needs its permission
   ([LibriVox's 1662 notice](https://librivox.org/the-book-of-common-prayer-1662-selections)).
   A website is read in the UK as well as the US, so this bears on launch
   (D14, P8.1). Printings differ: the sovereign's name in the state prayers
   changes, the three state services were removed in 1859, and the
   lectionary was replaced by the 1871 Revised Table of Lessons. Each
   printing used must be identified (P8.1).
5. **The ACNA's 2019 Book of Common Prayer.** Anglican House's
   [permissions page](https://anglicanhousepublishers.org/permissions/)
   allows limited liturgical and non-commercial use but says apps and digital
   tools need the publisher's permission "regardless of whether the app is
   free", forbids making complete texts available in any format, and forbids
   ingesting the book into or training any AI tool without written
   permission. Required credit: "Excerpts from The Book of Common Prayer
   (2019), Anglican Church in North America. Used by permission of Anglican
   House." The New Coverdale Psalter's terms were not on that page; ask about
   it explicitly.
6. **The Church of England's Common Worship.** The
   [copyright page](https://www.churchofengland.org/copyright) says its texts
   may not be used in any software program or app without prior written
   permission from the Copyright and Contracts Administrator of the
   Archbishops' Council; confirm its terms for websites when asking (P17.3).
7. **The Anglican Church of Canada.** The 1962 book carries a 1962 copyright
   of the General Synod, which [anglican.ca/texts](https://www.anglican.ca/texts)
   directs to its publications office. The 1918 Canadian book is in the US
   public domain by age.
8. **The Revised Common Lectionary.** The Consultation on Common Texts holds
   the copyright, permits limited local non-commercial reproduction with a
   credit line, and asks publishers and organizations to seek permission
   ([CCT sample notice](https://ms.augsburgfortress.org/downloads/RCL_DailyReadings_Expanded_Sample.pdf)).
   The 1979 book's own Sunday lectionary is public domain with the book.
9. **Scripture.** The KJV (with the Apocrypha) is US public domain (UK Crown
   rights, finding 4); the World English Bible, which includes the
   deuterocanonical books, is public domain. The RSV, ESV, and NRSV(ue) need
   licenses. The prayer books' own Psalters belong to the books: Coverdale's
   in 1662 and 1928 (as each prints it), the 1979 Psalter, and the 2019 New
   Coverdale Psalter (licensed separately). Verse divisions in the BCP
   Psalters differ from the KJV's in places.
10. **Calendar facts.** Western Easter falls between 22 March and 25 April
    by the Gregorian computus; the 1662 book prints its own tables (Golden
    Number and Sunday Letter). Season names differ by book (Sundays after
    Trinity in 1662 and 1928, after Pentecost with numbered Propers in 1979;
    Septuagesima, Sexagesima, and Quinquagesima in 1662 and 1928 but not
    1979). The 1979 Daily Office Lectionary runs on a two-year cycle with
    Year One beginning on the First Sunday of Advent preceding odd-numbered
    years (BCP 1979 p. 934; verify in P11.2). The 1662 Psalter is read through
    monthly, and its rubric appoints the Athanasian Creed on thirteen named
    feasts and the Litany on Sundays, Wednesdays, and Fridays.
11. **Church emblems.** The compass rose is the emblem of the Anglican
    Communion; the Episcopal Church, the ACNA, and the Church of England have
    their own shields and marks. The site uses none of them and avoids
    look-alikes.
12. **AI and licensed texts.** Because Anglican House forbids AI use of the
    2019 book without permission (finding 5), the AI study assistant (P24)
    may only retrieve over texts whose licenses allow it, recorded per source
    in `content/SOURCES.md`.
13. **The web's own rules** (to confirm from primary sources in Phase 20,
    not yet checked for this plan). A site read in the EU and UK falls under
    the GDPR and UK GDPR for any personal data it handles, and under the
    ePrivacy rules for cookies, which exempt strictly necessary cookies (such
    as the session and preference cookies the site sets) from consent. US
    state privacy laws (for example California's) turn mostly on selling or
    sharing data, which the site never does. WCAG 2.2 AA is the accessibility
    target (Phase 21).
14. **C. S. Lewis.** His books remain under US copyright (95 years from
    publication; *Mere Christianity*, 1952, until the end of 2047). Use only
    original writing in his spirit and cite titles.
15. **Hymns and music.** Old hymn texts are often public domain, but modern
    hymnals (the Hymnal 1940 and 1982), pointed psalters, arrangements, and
    every recording carry their own rights. Use cleared texts and owner-made
    or licensed recordings only.
16. **Local toolchain** (this Mac, checked 2026-10-29): macOS 27.2 on Apple
    silicon; mise 2026.10.18 managing **Ruby 4.0.9** (2026-10-23, the newest
    stable release; a precompiled build with OpenSSL 3.5.5 and libyaml
    0.2.5) as the global Ruby; RubyGems and Bundler 4.0.23; **Rails 8.1.4**,
    the newest Rails; the sqlite3 gem 2.10.2 bundling SQLite 3.54.1 with FTS5;
    Puma 8.0.2; Homebrew 7.0.11; Google Chrome for system tests; PostgreSQL 17
    (installed, not used). Homebrew's own Ruby 4.0.9 is still installed but
    kept off the PATH (decision 23).

---

## Owner decisions

Each decision has a recommendation, which was the working default until the
owner answered (AGENTS.md §4). Answers are recorded as `(owner, date)`, or
`(agent, date)` with reasons where D9 lets agents decide; their consequences
are in `docs/decisions.md`. Decisions overtaken by D27 say so and keep their
history.

| ID | Question | Recommendation | Decision |
|---|---|---|---|
| D1 | Name and identifiers | An original, warm, liturgical name | **Prayerbook Atlas** (owner, 2026-10-28). The Rails application module is `PrayerbookAtlas`. The iPhone identifiers (bundle ID `com.prayerbookatlas.app`, App Store Connect app 6828358779) were retired with the app (D27). |
| D2 | Which browsers | (Was: minimum iOS version, iOS 26.) Every browser gets working pages; enhancements target current browsers | **Superseded by D27.** Every browser is served semantic HTML that works without JavaScript; enhancements (offline, install, local data) target the current and previous major versions of Safari, Chrome, Firefox, and Edge, desktop and mobile (agent, 2026-10-29; decision 25). |
| D3 | Which prayer books, in what order | At launch, the three books that are public domain in the US: **1662** (England), **1928** (US), **1979** (US). By permission (D6): the ACNA's **2019**, Canada's **1962**, the Church of England's **Common Worship**, then other provinces. As a study layer in the Atlas: 1549, 1552, 1559, 1604, the 1637 Scottish book, the 1764 Scottish Communion Office, the 1789 and 1892 American books, the 1918 Canadian, the 1926 Irish, the 1928 English "deposited" book, and the 1929 Scottish book, each once its rights are cleared | **As recommended** (owner, 2026-10-29). |
| D4 | Default book and first visit | A skippable card on Today (never a modal) asks which book the person's church uses, with a plain line about each; if skipped, the preset is **1662**, the common ancestor; changeable at any time, with per-office overrides | **As recommended, with 1662 as the preset** (owner, 2026-10-29). On the web the choice is kept in a preference cookie, so it works without JavaScript. |
| D5 | Scripture policy | Each office uses its own book's Psalter. The reader and lessons launch with the **KJV with the Apocrypha** and the **World English Bible**, labeled by name. Request an **RSV** license at the demo stage (matching Grace & Footnotes), and ESV and NRSV licenses for 2019 and 1979 users. Never mix translations unlabeled | **As recommended** (owner, 2026-10-29). |
| D6 | When to ask for copyrighted texts | Build with public-domain texts first; send permission requests once the site is demoable ([GATE DEMO]): Anglican House (2019 book, New Coverdale Psalter, lectionaries), the General Synod of Canada (1962), the Archbishops' Council (Common Worship), Cambridge University Press (1662 and KJV in the UK), the Consultation on Common Texts (RCL), Church Publishing (Lesser Feasts and Fasts, Enriching Our Worship), and the Bible publishers (D5) | **As recommended** (owner, 2026-10-29). The demo is now the site itself at prayerbookatlas.com. |
| D7 | Monetization | Everything free, donation-supported: no subscriptions, ads, affiliate links, or "premium" prayers; AI costs capped per user | **As recommended** (owner, 2026-10-29). |
| D8 | The site's theological voice | Each book is presented faithfully on its own terms. The site's own original teaching follows the creeds, the prayer books, and the historic formularies where Anglicans share them, within the owner's statement of faith (Grace & Footnotes SOUL.md §2), and describes differences among provinces and churchmanships accurately and charitably from their own sources. The owner's personal convictions on questions disputed among Anglicans are not site content unless the owner asks for a page on them | **As recommended** (owner, 2026-10-29). |
| D9 | Who builds and decides | As Beautiful Corner D21: agents build and decide open questions, recording reasons as `(agent, date)`, limited only by their host's safety rules and by honesty | **Agents decide**, as recommended (owner, 2026-10-29): agents build, do [OWNER] preparation, and settle open questions with reasons as `(agent, date)`; the owner's credentials, payments, server changes, and messages in the owner's name still need the owner (AGENTS.md §4). |
| D10 | Reuse from the owner's other repositories | Copy and adapt generic engineering from `beautiful-corner`, naming the source commit. Copy no Orthodox content. Consult `anglican-catholic-app` for lessons only. Never change either repository | **As recommended** (owner, 2026-10-29). Since D27, Beautiful Corner's Swift code no longer applies directly; this repository's own retired Swift packages (tag `ios-archive`: `CivilDate`, `LiturgicalBlock`, `SourceCitation`, `PrayerBookID`, `TranslationID`) are the reference for their Ruby ports. |
| D11 | Repository visibility and license | Private until the owner chooses open source; if public, a LICENSE and care that every push publishes | **Stays public, all rights reserved** (owner, 2026-10-29): `LICENSE` says so; texts, Scripture, fonts, and images keep their own rights. Every push still publishes, so permission drafts stay generic. |
| D12 | Domains and support email | prayerbookatlas.com as the canonical domain | **prayerbookatlas.com** (owner, 2026-10-28): DNS at Cloudflare, pointing at the owner's Ubuntu server; Cloudflare Email Routing with a **catch-all** to the owner's inbox; support email **support@prayerbookatlas.com**. **prayerbookatlas.org** is the backup domain (owner, 2026-10-29): it redirects permanently to .com, and the server is configured so it can serve the site directly if .com ever cannot (docs/deploy.md). **prayerbook-atlas.com** redirects permanently to .com. |
| D13 | Publisher and accounts | (Was: the owner's individual Apple Developer account, team `D9QMP3LP8H`.) | **Superseded by D27.** The site is published by the owner as an individual; no Apple account is needed for it. The owner may keep or close the retired app's App Store Connect record (P0.6). |
| D14 | Where texts may be served | (Was: App Store territories, the US first.) A website is read everywhere. Serve public-domain-in-the-US texts while the site is in development; before launch, settle the UK question for 1662 and the KJV (finding 4) by asking Cambridge University Press (D6) and recording its answer | **Open: researched in P8.1, settled before P22** (agent, 2026-10-29). No geo-blocking unless the rights research shows it is required; the site's terms and sources page state the rights basis of every text. |
| D15 | Visual identity | The Ribbon direction, settled in a design session with two alternatives | **B · Engraved Plate** (owner, 2026-10-29): chart paper, iron-blue ink, double-rule frames, small capitals, square corners, one cartographer's blue; book face **Cardo** (agent, 2026-10-29; decision 18). The tokens carry over to the web unchanged (decision 24). Images come only from the owner's generator (decision 20). |
| D16 | Office record and streaks | A private record of offices prayed, off by default, with no count of consecutive days | **As recommended** (owner, 2026-10-29). |
| D17 | Relationship to Grace & Footnotes | Separate name and design; shared voice and source mark; links to its gospel pages; a page about this site on Grace & Footnotes only when the owner authorizes it | **As recommended** (owner, 2026-10-29). |
| D18 | Clergy review | Ask the owner's own priest about reviewing original teaching; record only what actually happens | **As recommended** (owner, 2026-10-29); the asking is P0.8. |
| D19 | Server and web stack | (Was: a Swift service with Vapor beside a static site.) | **Superseded by D27 and D28.** |
| D20 | Calendar and lectionary facts | Facts only (names, dates, ranks, references), never prose, each cited and cross-checked against two independent sources with every difference listed | **As recommended** (owner, 2026-10-29). |
| D21 | Rights research downloads | Agents may download candidate scans and files from the Internet Archive, HathiTrust, Google Books, eBible.org, CCEL, Project Canterbury, and first-party church sites into the gitignored `research/` folder; nothing there is served until cleared | **As recommended** (owner, 2026-10-29). |
| D22 | Audio | Read-aloud with the browser's speech synthesis at first, clearly labeled as synthetic; recorded readings by the owner or a hired reader later; chant only from owner-made or licensed recordings | **As recommended** (owner, 2026-10-29; restated for the web by an agent, 2026-10-29). |
| D23 | AI study assistant | Yes, in a later phase: the Claude API called from the server (the key only in the server's credentials), retrieval only over texts whose licenses allow it (finding 12), strict citations, free with per-user caps | **As recommended** (owner, 2026-10-29). |
| D24 | Finding a church | Link to each church's own official finder; no scraped or invented directory | **As recommended** (owner, 2026-10-29). |
| D25 | Android and native apps | (Was: Android after the web app.) | **Superseded by D27.** Phones are served by the phone site and its installable web app (P18). A native app returns only if the owner reopens the question. |
| D26 | Public website stack | (Was: a static site in `Website/`.) | **Superseded by D27.** The Rails app is the website; there is no separate static site. |
| D27 | Platform and framework | — | **A website only, built with Ruby on Rails** (owner, 2026-10-29): no native mobile app; Rails 8.1.4 on Ruby 4.0; primarily for desktop browsers, with a dedicated phone mode for small-screen mobile browsers and a fuller full-site mode with more features for desktop and full-size windows. Decisions 21–24 record how. |
| D28 | Hosting | Self-hosted on the owner's Ubuntu server behind the existing Caddy: Puma under systemd, SQLite in the shared storage directory, deploys of the built release only, no Docker or Kamal | **Self-hosted at prayerbookatlas.com, with .org as backup** (owner, 2026-10-29); the process model as recommended (agent, 2026-10-29; decision 27). |
| D29 | Where personal data lives | In the person's own browser by default (IndexedDB), exportable; optional account sync later (P25) for what the person chooses; confession notes never leave the browser | **As recommended** (agent, 2026-10-29; decision 28). |

---

## Engineering foundations

`docs/decisions.md` records each with its reasons (entries 8, 11, 12, and
21–31).

1. **Rails 8.1, the Rails way.** Ruby 4.0.9 pinned in `.ruby-version`,
   Rails 8.1.4, Propshaft, importmap, Turbo, Stimulus, Solid Cache, Solid
   Queue, Solid Cable, Puma, Minitest, RuboCop (rails-omakase), Brakeman,
   bundler-audit. Conventions over invention: REST routes, server-rendered
   views, partials and helpers for components.
2. **Two modes, one site** (decision 24). `SiteMode` chooses the phone site
   for small-screen mobile browsers (the `Sec-CH-UA-Mobile` client hint,
   then the user agent) and the full site for everything else; the person
   can choose either. The phone site renders `+phone` variants of layouts and
   views where they exist and the shared templates otherwise; CSS lets the
   full site fold gracefully in a narrow window.
3. **Progressive enhancement** (decision 25). Every page works as semantic
   HTML without JavaScript, in every browser. Stimulus adds keyboard
   shortcuts, swipes, local data, offline, and the like; Turbo speeds
   navigation. Nothing needed to pray depends on a script.
4. **Vanilla CSS from tokens.** `design/tokens.json` → generated
   `app/assets/stylesheets/tokens.css` (`bin/rails design:tokens`, checked by
   a test); every other stylesheet uses only the custom properties. No CSS
   framework, no build step.
5. **SQLite everywhere** (decision 26): the app's own databases (primary,
   cache, queue, cable) and a separate, read-only **content database**
   compiled from `content/` by `bin/rails content:compile`, with FTS5 search,
   refusing any content whose source is not `cleared`.
6. **Plain Ruby for the engines.** The church year, offices, Scripture
   references, and the Atlas are plain Ruby objects under `app/models/`
   (`ChurchYear::`, `Office::`, `Scripture::`, `Atlas::`) with no database
   access of their own, tested with fast table-driven Minitest cases.
7. **Dates are dates** (decision 30). Church-calendar logic uses Ruby's
   `Date` (a civil date, proleptic Gregorian), never `Time`, `DateTime`, or
   a time zone. The person's local date is settled once at the request edge.
8. **Book, printing, and page on everything** (decision 11). Every liturgical
   block knows its book, the printing it was transcribed from, and its
   printed page. Texts are never shared between books by reference.
9. **Works and witnesses** (decision 12). The Atlas links each book's text of
   a prayer (a *witness*) to the abstract prayer (a *work*).
10. **Our own simple formats.** Content files use `key: value` front matter
    parsed by our code; tables are JSON.
11. **Few dependencies** (decision 29). Only the gems `rails new` installs;
    every other gem needs a decision entry. No analytics, advertising,
    tracking, crash-reporting, affiliate, remote-font, or CDN code, ever.
12. **Nothing from elsewhere** (decision 31). A strict Content Security
    Policy allows only this site: no remote fonts, scripts, styles, images,
    or frames.
13. **A date override for tests.** Pages accept `?date=YYYY-MM-DD` (and a
    book) so tests and screenshots can pin any day; the date in the URL is
    also how people share a day.
14. **Local CI.** `bin/ci` (`config/ci.rb`) is the check before every commit:
    setup, RuboCop, bundler-audit, importmap audit, Brakeman, tests, seeds,
    and, as they arrive, system tests, content checks, and the link check.

### Architecture at a glance

```
Browser ─ desktop: the full site · phone: the phone site (+phone variants)
   │  HTML first; Turbo and Stimulus enhance; IndexedDB holds personal data
   ▼
Caddy (owner's Ubuntu server): TLS, compression, redirects
   prayerbook-atlas.com, prayerbookatlas.org, www.* → prayerbookatlas.com
   │
   ▼
Puma (systemd) ─ Rails 8.1 ─ SiteMode → controllers → views (+phone)
   │                │
   │      ChurchYear · Office · Scripture · Atlas   (plain Ruby)
   │                │
   ├─ storage/production.sqlite3 (+ cache, queue, cable)   app data
   └─ db/content.sqlite3  read-only, FTS5                   texts, tables
         ▲
bin/rails content:compile ← content/ (sourced, proofread texts and facts)
```

### Milestones

- **M1 Foundation** (P1–P5): the site runs in its design in both modes, the
  content pipeline enforces rights, the church year is correct for every
  book, and the site is deployed at prayerbookatlas.com.
- **M2 The Daily Office** (P6–P9): Today, the Kalendar, and complete offices
  from 1662, 1928, and 1979 for any day. The site is demoable here.
- **M3 Word and Atlas** (P10–P13): Scripture, every lectionary and reading
  plan, the Atlas, and Holy Communion with the pastoral offices.
- **M4 Rule of life** (P14–P16): personal prayer, holy days, and Learn.
- **M5 Version 1.0** (P17–P22): more books by permission, the web platform,
  public pages, hardening, and launch. P17 never holds up the launch.
- **M6 Voice** (P23–P24): audio and the AI study assistant.
- **M7 Accounts and sustainability** (P25–P26).
- **M8 Ongoing** (P27–P28): operations, maintenance, and future directions.

---

## Phase 0: Owner foundations

- [x] **P0.1 [OWNER]** Answer D2–D26, or accept their recommendations, and record the answers above. *(Owner, 2026-10-29.)*
- [x] **P0.2 [OWNER]** Create the repository. *(Owner, 2026-10-28: `dunamismax/prayerbook-atlas`, public; see D11.)*
- [x] **P0.3 [OWNER] [GATE D11]** Set the repository's visibility and license. *(Owner, 2026-10-29: public, all rights reserved; `LICENSE`.)*
- [x] **P0.4 [OWNER]** Register the domains and support email (D12). *(Owner: prayerbookatlas.com and prayerbook-atlas.com on 2026-10-28, prayerbookatlas.org on 2026-10-29, all at Cloudflare; catch-all Email Routing on the first two.)*
- [x] **P0.5 [OWNER]** A trademark knockout search for "Prayerbook Atlas" (USPTO). *(2026-10-29: no conflict found; decision 19.)*
- [ ] **P0.6 [OWNER]** Decide what to do with the retired iPhone app's App Store Connect record (app 6828358779, build 0.1.0 in internal TestFlight): leave it unreleased, or remove the app in App Store Connect. Agents do not touch it.
- [ ] **P0.7 [OWNER]** Have printed copies at hand for proofreading where scans fall short: a current 1662 (Cambridge), a 1928 (US), and a 1979 (US). *(Optional.)*
- [ ] **P0.8 [OWNER] [GATE D18]** Ask a priest about reviewing original teaching.
  - *2026-10-29 note:* the owner chose to leave this for later. Original-teaching pages wait in `review: pending` until reviewed.
- [x] **P0.9 [OWNER]** Decide the CI triggers. *(Owner, 2026-10-29: manual dispatch only. Hosted Linux minutes are free for a public repository, so pushes to `main` could run it too if the owner wishes.)*
- [x] **P0.10 [OWNER] [REVIEW]** Approve SOUL.md. *(Owner, 2026-10-29: approved as written. Its wording was changed from "app" to "site" with D27 at the owner's direction the same day; §2, the statement of faith, is untouched.)*
- [x] **P0.11 [OWNER]** Choose the platform and framework (D27) and the hosting (D28). *(Owner, 2026-10-29: a website only, Ruby on Rails 8.1.4, self-hosted at prayerbookatlas.com with prayerbookatlas.org as backup.)*

When the site is demoable:

- [ ] **P0.12 [GATE DEMO]** Draft the permission requests D6 lists, each describing the site, the free use, the exact texts wanted, the attribution, and the demo. Save them to `docs/owner-drafts/permission-requests.md`.
- [ ] **P0.13 [GATE DEMO]** Draft the Scripture license requests D5 lists. Save them to `docs/owner-drafts/scripture-licenses.md`.
- [ ] **P0.14 [OWNER] [GATE DEMO]** Send the requests from the owner's address (replies to permissions@prayerbookatlas.com also reach the owner), and record each response's status in `content/SOURCES.md` (letters stay off-repo).

## Phase 1: Rails foundation

- [x] **P1.1** Set up this Mac for Ruby and Rails: Ruby through mise (the owner's existing runtime manager), Rails 8.1.4, and a shell where `ruby`, `gem`, `bundle`, and `rails` are unambiguous.
  - *2026-10-29 result:* mise installed precompiled Ruby 4.0.9 and set it global (`~/.config/mise/config.toml`); mise now reads `.ruby-version` (`idiomatic_version_file_enable_tools = ["ruby"]`). RubyGems updated to 4.0.23, Bundler 4.0.23, Rails 8.1.4 installed; `~/.gemrc` skips documentation; Bundler installs with 8 jobs. In `~/.zshrc` the Homebrew Ruby PATH line is commented out (Homebrew's Ruby stays installed, unused); `~/.zprofile` adds mise's shims for login shells and GUI apps. Backups: `~/.zshrc.bak-20261029`, `~/.zprofile.bak-20261029`. Checked in a fresh login shell: `which ruby` is mise's 4.0.9.
- [x] **P1.2** Generate the Rails 8.1.4 app in the repository root with SQLite, Propshaft, importmap, Turbo, Stimulus, the Solid trio, Minitest, RuboCop, Brakeman, bundler-audit, and GitHub CI; without Kamal, Thruster, Docker, Action Mailbox, Action Text, Active Storage, Jbuilder, or a devcontainer (decision 22). Write `.gitignore` (Rails' entries, secrets, the content database, `research/`).
- [x] **P1.3** Retire the iPhone app: remove `App/`, `AppTests/`, `AppUITests/`, `Packages/`, `project.yml`, `Config/`, `scripts/`, the Makefile, the Xcode CI workflow, and `docs/release.md`; tag the last app commit `ios-archive`.
  - *2026-10-29 result:* tagged at `a9be149`. The owner's local, gitignored `Config/Secrets.xcconfig` (App Store Connect key id, issuer, and key path; not the key) was moved out of the repository to `~/.config/prayerbook-atlas-ios/Secrets.xcconfig`, because Rails' `config/` is the same folder on a case-insensitive disk.
- [x] **P1.4** Record the web decisions in `docs/decisions.md` (entries 21–31) and mark the iPhone entries superseded.
- [x] **P1.5** Rewrite `README.md`: what the site is, prerequisites confirmed on this Mac, a quick start that works from a clean checkout, and the real layout.
- [x] **P1.6** Rewrite AGENTS.md, SOUL.md's wording, `docs/product.md`, and `docs/design.md` for the website, and add `docs/deploy.md`.
- [x] **P1.7** The two modes (decision 24): `SiteMode` (client hint, then user agent; the person's choice in a cookie holding only "phone" or "full"), the full-site layout (masthead, contents, reading column, margin) and the phone layout (phone bar, one column, tab bar), the footer switch, and `Vary` headers. Integration tests for phones, tablets, desktops, the hint, the choice, and its undoing.
- [x] **P1.8** The five sections and the About page as honest placeholders, in both modes; no `allow_browser` gate (decision 25); a strict Content Security Policy and a Permissions Policy (decision 31); production hosts for both domains.
  - *2026-10-29 result:* checked in the in-app browser at 1440×900 (light and dark), 800×900, and the mobile preset (375×812 with a phone user agent): both layouts, the tab bar, the folded margin, and the mode switch both ways; no console errors or CSP violations.
- [x] **P1.9** `bin/ci` passes: setup, RuboCop, bundler-audit, importmap audit, Brakeman, tests, and seeds.
- [x] **P1.10** GitHub Actions: the generated workflow (`.github/workflows/ci.yml`), on manual dispatch only (P0.9). Tick after the first hosted run passes.
  - *2026-10-29 result:* the first runs failed in the test jobs (no `db/schema.rb`, which `db:test:prepare` needs; then no `test/system/`). After both were added, run [40890263834](https://github.com/dunamismax/prayerbook-atlas/actions/runs/40890263834) passed all five jobs (39 tests, 4 system tests). GitHub warns that `ubuntu-latest` moves to Ubuntu 26 from 2026-10-19.
- [x] **P1.11** System tests with Capybara and headless Chrome: a phone-sized window with a phone user agent and a desktop-sized window, each visiting every section; `bin/rails test:system` added to `config/ci.rb` and the workflow. Screenshots go to `tmp/screenshots/`, never committed.
  - *2026-10-29 result:* `ApplicationSystemTestCase` (1440×900) and `PhoneSystemTestCase` (Chrome's mobile emulation at 390×844: a phone user agent and `Sec-CH-UA-Mobile: ?1`, since a bare user-agent override still sends `?0`, which `SiteMode` reads first). Each driver is registered under its own name; with one shared name the last class's driver wins. Small-capital labels render lower-case, so visible-text assertions match case-insensitively.
- [x] **P1.12** Survey the Anglican prayer websites Research finding 1 lists (what each offers, which books, how it sources texts, how it works on a phone), and update finding 1 and the feature map.

## Phase 2: Design system and site shell

- [x] **P2.1** Write `docs/product.md` for the website: the five sections, the two modes and what each adds, URLs and navigation, the tone rules, each book on its own terms, no guilt mechanics, privacy by design, and the newcomer.
- [x] **P2.2** Carry Engraved Plate to the web: `docs/design.md` for CSS (tokens, contrast, type in rem, layout for both modes, rules, appearance), `design/tokens.json` notes for the web, and `lib/design_tokens.rb` generating `tokens.css` (`bin/rails design:tokens`), with tests that it is current and that no other stylesheet writes a raw colour.
- [x] **P2.3** Self-host Cardo: the three faces as WOFF2 in `app/assets/fonts/` with the OFL, `@font-face` with `font-display: swap`, recorded in `content/SOURCES.md`.
  - *2026-10-29 result:* converted from the cleared TTFs (SHA-256 prefixes `bcb81f37`, `52c51cfd`, `6c9383b1`, as recorded) with fontTools' `ttLib.woff2 compress`, which recompresses without changing outlines or tables. Small capitals render through `font-variant-caps` in Chrome.
- [x] **P2.4** Type in the browser: check Cardo's small capitals (`smcp`), old-style figures (`onum`), ℣ ℟ † ¶, and polytonic Greek in Safari, Chrome, and Firefox; choose the fallback for ✠ (U+2720), which Cardo lacks; tune sizes per mode (the phone a step smaller for display and title); a development-only type specimen page.
  - *2026-10-29 result:* `/dev/type` (development and test only). ✠ comes from **Atlas Cross**, a `unicode-range` face of system fonts only (docs/design.md §5). Checked in Chrome (in-app: full site at 1440 and 800 wide, phone emulation, day and night, 200% text, no console errors), Firefox 159 (headless `--screenshot`), and WebKit through `script/webkit_snapshot.swift`. Safari itself was not driven: the owner declined screen access to it this session, so WebKit stands in until P21.5.
- [x] **P2.5** Components as partials and helpers, in both modes: card, eyebrow, red initial (`initial-letter` where supported, an enlarged capital otherwise), rubric, role label, versicle and response, Amen, repetition, name chip, ribbon marker (with its name, never colour alone), atlas plate, title rule, page-number mark (in the margin on the full site, inline on the phone), source footnote (the HTML `popover` attribute, so it opens without JavaScript, with a plain link fallback), margin note, and empty, loading, and error states. A development-only gallery at `/dev/components`.
  - *2026-10-29 result:* `ComponentsHelper` and `shared/_state`; ribbon edges generated as `--ribbon-<name>-edge`. Page numbers hang in a right gutter of `.with-page-marks` on the full site (the reading column is too narrow at common widths to use the margin column itself). Checked in Chrome at 1440 and 800 wide and the phone emulation, day and night, 200% text; the popover opened from its button. No console errors.
- [x] **P2.6** Appearance: Automatic, Day, or Night, chosen from Settings by a plain form, kept in a preference cookie, and applied as `data-appearance` on `<html>` by the server (no flash, no script).
  - *2026-10-29 result:* `AppearancePreference`, `AppearancesController`, and a first `/settings` page with the Appearance form, linked from the masthead and the phone bar (P2.12 fills in the rest). Checked in Chrome: Night with the system light and Day with the system dark, on the full site and the phone, back to Automatic; system tests drive the form in both modes.
- [x] **P2.7** URLs: write `docs/urls.md` (readable, stable, shareable URLs for every destination: a day, an office in a book on a date, a prayer in the Atlas, a compare, a psalm, a passage) and route every placeholder destination by it.
  - *2026-10-29 result:* `docs/urls.md`; `PrayerBook` and `Translation` ported from the retired Swift ids (`bcp1662`, `bcp1928us`, `bcp1979us`; `kjva`, `web`) and `Office::NAMES`. Every planned destination is routed to `DestinationsController`, an honest placeholder at its final address; impossible dates, months, books, offices, and translations are 404s. `UrlsTest` requests every URL the document lists, in both modes. Checked in Chrome on the full site and the phone.
- [x] **P2.8** The `LiturgicalBlock` model in Ruby, ported from the retired Swift ContentKit (tag `ios-archive`): heading, paragraph, rubric, role-labeled lines as each book labels them, versicle and response, Amen, the Gloria Patri marker, psalm verses with the half-verse mark as printed and both numberings where they differ, canticle references, collects, alternatives, seasonal and name insertion points, book, printing, and page, and page breaks; with its `problems` checks.
  - *2026-10-29 result:* `LiturgicalBlock` (twelve kinds as `Data` classes, inline runs, role lines, alternatives) and `SourceCitation`, ported from `Packages/ContentKit` at `ios-archive` (`a9be149`), with a stable hash form for the compiler (P3.3) and the Swift tests ported. Added checks the Swift lacked: an unknown book, an unknown insertion kind or half-verse mark, and a KJV verse number that duplicates the book's.
- [x] **P2.9** Render `LiturgicalBlock`s as semantic HTML: rubrics marked as instructions for screen readers, role labels announced, page numbers in the margin (full) or inline (phone), insertion points visible, and plain text selection and copy.
  - *2026-10-29 result:* `LiturgyHelper#liturgy`, with `SampleBlocks` (bracketed placeholders, an unregistered "example" printing) on `/dev/liturgy`. Checked in Chrome at 1440 wide and the phone emulation, day and night, 200% text, and a copy of the whole text (no "Instruction:", page numbers, or KJV labels in it); with JavaScript off in headless Firefox. No console errors.
- [x] **P2.10** Reading settings, kept in a preference cookie and applied by the server: text size, line spacing, rubrics in colour or italic, show or hide rubrics, show page numbers, keep the screen awake while praying (the Screen Wake Lock API, where supported), and original or modernized spelling (historic books only, P12.6).
  - *2026-10-29 result:* `ReadingSettings` in one cookie (`reading`, only the choices that differ from the defaults), written on `<html>` as data attributes and styled by `reading.css`; keep-awake is the `wake-lock` Stimulus controller, which asks only on pages with a `.liturgy` and does nothing where the API is missing. The spelling choice is stored now and says plainly that it waits for P12.6. Checked in Chrome on both modes with the settings applied, and back to the defaults; a system test drives the form.
- [x] **P2.11 [GATE D4]** The first visit: a skippable card on Today choosing the person's prayer book, with a line about each; the preset is 1662; nothing is required to begin praying.
  - *2026-10-29 result:* a card on Today after the title (never a dialog), with a plain line about each book (`PrayerBook#summary`), "Use this book" and "Skip for now"; skipping records the preset, 1662, so the card does not return. The choice is a cookie holding only the book's id (`BookPreference`), also chosen in Settings. Checked in Chrome on the full site (and Skip), and as a phone with JavaScript off in headless Firefox.
- [ ] **P2.12** Settings (`/settings`): prayer book and per-office overrides, reading settings, appearance, the site mode, acknowledgements and sources (generated from the content database once P3.8 lands), the non-affiliation statement, about, support, and the running version (the deployed commit).
- [ ] **P2.13** Route every interface string through Rails I18n (`config/locales/en.yml`), English only for now; a test finds untranslated literal text in views.
- [ ] **P2.14** A system-test tour: every section and Settings, in both modes and both appearances, saving screenshots to `tmp/screenshots/`.

## Phase 3: Content pipeline and rights registry

- [ ] **P3.1** Give `content/SOURCES.md` a documented schema (id, title, book and printing, year, publisher, obtained-from URL or scan, jurisdiction, rights basis per territory, AI-use permission, what was checked, status). Add "Original work (owner)", `pending` entries for the public-domain candidates in Research findings 3, 4, 7, and 9, and a **Wanted** section for the requests in D6.
- [ ] **P3.2** Write `docs/content-format.md`: UTF-8 text files with `key: value` front matter and a line syntax for every `LiturgicalBlock` kind; ids for books and printings (for example `bcp1662`, `bcp1928us`, `bcp1979us`); the `work` key (P12.1); required keys (`id`, `book`, `printing`, `page`, `source`, `kind`, `translation` for Scripture, `review` for original work); JSON tables for calendars and lectionaries.
- [ ] **P3.3** Build the content compiler (`lib/content/`, `bin/rails content:compile`): parse and validate `content/` and write a deterministic `db/content.sqlite3` with a schema version, text tables, and an FTS5 index. Fail on unknown sources, duplicate ids, unresolved references, and original works without `review`. Production and `bin/ci` fail on uncleared sources; `ALLOW_PENDING=1` downgrades that to a warning in development.
- [ ] **P3.4** The book guard: every liturgical text names its book, printing, and page; a text may not be placed in a book it was not transcribed from; and a source cleared for one territory is not treated as cleared for another (D14).
- [ ] **P3.5** The Scripture guard (D5): every Scripture item names its `translation`; only allowed translations are accepted; licensed translations have verse ceilings unless `SOURCES.md` records a license, and their notices appear wherever they are shown.
- [ ] **P3.6** The quotation and image registries: every quotation names its author, work, edition, and location from a `cleared` source; every image records its source, creator, date, holder, and rights basis; AI-generated sacred images are rejected.
- [ ] **P3.7** The read-only content database in Rails: a `content` database in `config/database.yml`, an abstract `ContentRecord` connected to it read-only, models for books, printings, blocks, and works, and tests against a fixture database.
- [ ] **P3.8** Build integration: `bin/setup`, `bin/ci`, and the deploy compile the content; a missing content database fails clearly; the acknowledgements and the sources page are generated from it.
- [ ] **P3.9** Search (`/search`): ranked FTS5 results with highlighted snippets and filters by book and kind (office, prayer, collect, psalm, Scripture, lesson, rubric). On the full site the search field is in the masthead and the filters in the contents column; on the phone, a search page with the filters folded.
- [ ] **P3.10** A content-integrity suite in `bin/ci`: unique ids, resolved references, registered sources, no empty blocks, every block with a book, printing, and page.
- [ ] **P3.11** Write `docs/proofreading.md`: two independent passes against the page images, a word-level diff between them, how differences are settled, the record in `SOURCES.md`, and the errata process for readers' reports (support@prayerbookatlas.com).

## Phase 4: Church year engine (ChurchYear)

Plain Ruby under `app/models/church_year/`. Cite the governing source (book
and page) for every rule in `docs/calendar-rules.md`. Mark any rule without a
printed source as an "app convention" and say why it was chosen.

- [ ] **P4.1** Civil-date helpers on Ruby's `Date` (proleptic Gregorian): weekday names as each book uses them, Sundays before and after, the nearest Sunday, and the Julian Day Number, with exhaustive tests (the retired Swift `CivilDate` at `ios-archive` is the reference).
- [ ] **P4.2** Western Easter by the Gregorian computus, tested 1583–4099 against an authoritative table, and independently by the 1662 book's own tables and rules (Golden Number, Sunday Letter), the two required to agree for every year the tables cover.
- [ ] **P4.3** The moveable cycle per book: Advent Sunday; the Sundays after Christmas and after the Epiphany (and how surplus Sundays are handled); Septuagesima, Sexagesima, and Quinquagesima where the book keeps them; Ash Wednesday and Lent; Holy Week; Easter; Rogation Sunday and the Rogation Days; Ascension; Whitsunday or Pentecost; Trinity Sunday; the Sundays after Trinity or after Pentecost with 1979's Propers by date; and the Sunday next before Advent.
- [ ] **P4.4** The fixed holy days of each launch book (D3) as facts in `content/calendar/<book>.json` (date, name, rank as the book gives it, page), including red-letter and black-letter days where the book distinguishes them.
- [ ] **P4.5 [GATE D20]** Compile each book's lesser commemorations as facts only (names, dates, ranks), cited and cross-checked against two independent sources with every difference listed.
- [ ] **P4.6** Precedence and transfer per book: 1979's rules as printed; 1662's and 1928's from their rubrics, with app conventions documented where the books are silent.
- [ ] **P4.7** Fasts and abstinence per book, as information only: 1662's Table of Vigils, Fasts, and Days of Abstinence (including Ember and Rogation days), 1928's table, and 1979's days of special devotion, each with the book's own words and page and a line that one's parish priest may counsel differently.
- [ ] **P4.8** Liturgical colours, as information, labeled as custom where the book prescribes none, with an optional Sarum sequence; off by default.
- [ ] **P4.9** The collect of the day per book from its rubrics: the Sunday collect serving the week; the Advent and Ash Wednesday collects said daily through their seasons where directed; holy-day collects and their eves (first Evensong); and precedence between them. A test that every collect key for a year resolves.
- [ ] **P4.10** The public API `ChurchYear::Day`: (date, book) → the day's name, season, week, colour, holy days and commemorations with ranks, collect keys, fast and abstinence notes, lectionary keys, Ember and Rogation flags, and eve flags. Deterministic, frozen, and cached per year (Solid Cache).
- [ ] **P4.11** Golden files: full-year outputs for 2026, 2027, and 2028, an early-Easter year (2008, 23 March), and a late-Easter year (2038, 25 April) for each launch book, checked by tests and confirmed against printed tables.
- [ ] **P4.12** Performance: a full year for every book computes within a measured budget (start at 100 ms per book-year on this Mac), recorded in `docs/performance.md`.
- [ ] **P4.13** Write `docs/calendar-rules.md`: every rule, its source, and its test.

## Phase 5: Hosting at prayerbookatlas.com [GATE D28]

Early, so the owner can watch the site grow. Every step that changes the
server, DNS, or Caddy is the owner's to approve (AGENTS.md §4); agents
prepare everything.

- [x] **P5.1** Write `docs/deploy.md`: the server layout (`/srv/prayerbookatlas` with releases, a shared `storage/`, and an environment file holding `RAILS_MASTER_KEY`), Ruby on the server through mise, the systemd unit for Puma (with Solid Queue in Puma), the Caddy site for prayerbookatlas.com with redirects from www, prayerbook-atlas.com, and prayerbookatlas.org (and how to make .org serve directly as the backup), security headers, logs, and rollback.
- [ ] **P5.2** `bin/deploy`: build a release from a clean `git archive` of `main`, copy it to the server, `bundle install` (deployment mode), precompile assets, compile the content with release checks, migrate, switch the `current` link, restart Puma, check `/up`, and roll back on failure. Never makes the checkout or the repository a web root.
- [ ] **P5.3 [OWNER]** Provision the server as `docs/deploy.md` says: a `prayerbookatlas` user, Ruby 4.0.9 through mise, the directories, the environment file with the master key (from the owner's `config/master.key`), the systemd unit, and the Caddy site beside the existing ones (never replacing them).
- [ ] **P5.4 [OWNER]** The first deploy, then check every name: prayerbookatlas.com serves the site over HTTPS; www, prayerbook-atlas.com, prayerbookatlas.org, and their www names redirect permanently to it; the response headers are right.
- [ ] **P5.5** Backups: a nightly SQLite `.backup` of the app's databases in `storage/`, encrypted and kept off the server on owner-controlled storage, with a written restore drill run once. (The content database is rebuilt from the repository, not backed up.)
- [ ] **P5.6** A post-deploy check (`bin/rails site:check_live`): status codes, redirects, TLS, the security headers, and no requests to other hosts.
- [ ] **P5.7** Robots and preview: until launch (P22), `robots.txt` disallows crawling and every page says the site is in development.

## Phase 6: Today and the Kalendar

- [ ] **P6.1** The person's date: the browser's time zone is sent once in a preference cookie by a tiny script; without it the server uses the date in the URL or, failing that, the owner's default zone, and says which date it is showing. Midnight and travel are handled at the request edge only (decision 30).
- [ ] **P6.2** Today: the day's name in the chosen book (the other launch books' names one click away), the ribbon, holy days, fast and abstinence notes, the office for the hour, the collect, the psalms and lessons (references now, text from P10), slots for my rule (P14.4) and the reading-plan portion (P11.4), and the next holy day with no countdown. The full site sets the other books' names and the lessons in the margin; the phone stacks them.
- [ ] **P6.3** Day navigation: previous and next links, a date field, and a Today link everywhere; arrow keys on the full site and a swipe on the phone (Stimulus), both only as enhancements of the links.
- [ ] **P6.4** The Kalendar: a month grid on the full site with red-letter days in rubric and marked by a symbol and words too (never colour alone), a list on the phone, a year view, and quick jumps to Advent, Ash Wednesday, and Easter.
- [ ] **P6.5** The day page (`/kalendar/YYYY-MM-DD`): everything Today shows, for every launch book, with the source of each rule.
- [ ] **P6.6** The Easter tables page: Easter and the moveable feasts for any year, the year's Golden Number and Sunday Letter, and the 1662 book's own tables explained.
- [ ] **P6.7** System tests: open specific dates (Easter 2027, Ash Wednesday 2028, Septuagesima in 1662, Proper 28 in 1979, an Ember Day) in both modes and assert their titles.

## Phase 7: The Daily Office engine and reader

- [ ] **P7.1** The office assembly engine (`Office::Assembler`): (date, book, office, options) → an ordered list of content ids with the day's propers (sentences, invitatory and its seasonal forms, psalms, lessons, canticles, the creed, suffrages, collects, the state prayers, the Litany where appointed). Pure and tested. A book without an office (Compline in 1662) returns "not in this book", never another book's office.
- [ ] **P7.2** The options model per book: Rite I or II (1979), canticle choices, the Athanasian Creed on its days (1662), the Litany days, Suffrages A or B, said or sung forms, and the state prayers' form (the convention P8.9 records); chosen by plain forms, remembered in a preference cookie.
- [ ] **P7.3** The office reader. Full site: the office's sections in the contents column (current section marked as the reader scrolls), the text in the reading column, sources, page numbers, and the alternatives in the margin. Phone: one continuous column with a sections menu at the top. Both: inline choices, lessons from the Bible store and psalms from the book's own Psalter, and keep-awake.
- [ ] **P7.4** Snapshot tests: the assembled id lists for forty representative days per launch book (ordinary Sundays, holy days, Lent, Holy Week, Easter week, Ember Days, eves), each checked by hand against the printed book, with every id resolving.
- [ ] **P7.5** Keyboard use on the full site: next and previous section, jump to the psalms or lessons, and a `?` sheet listing the keys, all also reachable without the keyboard.
- [ ] **P7.6** Family prayer and short forms where a book provides them (1928's family prayer, 1979's Daily Devotions for Individuals and Families).

## Phase 8: The 1662 Book of Common Prayer

- [ ] **P8.1 [RIGHTS] [GATE D14]** Identify the printing(s): page images of a printing carrying the 1871 lectionary (Internet Archive or HathiTrust), and the current Cambridge text for comparison; record the edition, scan URLs, and the rights basis (US public domain; UK Crown rights, Research finding 4) as `pending`, then clear for the US. Research what serving it on a website read in the UK requires and record it under D14.
- [ ] **P8.2** Transcribe and proofread (P3.11) Morning and Evening Prayer with all canticles, the Litany, and the Prayers and Thanksgivings upon Several Occasions.
- [ ] **P8.3** The Collects, Epistles, and Gospels for the year, as printed in the book.
- [ ] **P8.4** The Psalter (Coverdale) in its thirty-day cycle, with the book's rules for the thirty-first day and February and its proper psalms.
- [ ] **P8.5 [GATE D20]** The Kalendar and lectionary as facts: the 1871 Revised Table of Lessons (default), the 1922 table (option), and the original 1662 table (historical), cross-checked against two sources.
- [ ] **P8.6** The Order for the Administration of the Lord's Supper, or Holy Communion, to follow and to prepare.
- [ ] **P8.7** The occasional offices for study and preparation: Baptism (three forms), the Catechism, Confirmation, Matrimony, the Visitation and Communion of the Sick, Burial, the Thanksgiving of Women after Child-birth, the Commination, the Forms of Prayer to be Used at Sea, the Ordinal, the Articles of Religion, and the Table of Kindred and Affinity.
- [ ] **P8.8** The Creed of Saint Athanasius and the days its rubric appoints.
- [ ] **P8.9** The state prayers: record in `docs/decisions.md` how the site names the sovereign and offers other forms, and implement it.
- [ ] **P8.10** The complete proofreading record in `SOURCES.md`, and a book page for the Atlas (P12.3).

## Phase 9: The American prayer books: 1928 and 1979

- [ ] **P9.1 [RIGHTS]** Identify and clear the printings: the 1928 (and which lectionary revision it carries) and the 1979 (the Episcopal Church's PDF of the 2007 printing, checked against a printed copy), reading Canon II.3.6's current text and recording it (Research finding 3).
- [ ] **P9.2** 1928: Morning and Evening Prayer, family prayer, the Litany, the Prayers and Thanksgivings, the Collects, Epistles, and Gospels, the Psalter in the book's selections and monthly cycle, and the tables of lessons as facts (D20).
- [ ] **P9.3** 1979: the Daily Office in Rite I and Rite II, Noonday Prayer, An Order of Worship for the Evening, Compline, the Daily Devotions, the Great Litany, the collects in both languages, the Psalter (half-verse asterisks, LORD in small capitals), and the two-year Daily Office Lectionary as facts.
- [ ] **P9.4** 1979: the Holy Eucharist in Rite I and Rite II, the Proper Liturgies for Special Days, and the 1979 Sunday lectionary as facts (the RCL arrives by permission, P17.6).
- [ ] **P9.5** 1979 and 1928 pastoral offices and catechisms for study: Holy Baptism, Confirmation, Marriage, the Thanksgiving for the Birth or Adoption of a Child, the Reconciliation of a Penitent, Ministration to the Sick, Burial, the Offices of Instruction (1928), An Outline of the Faith (1979), and the 1979 Historical Documents.
- [ ] **P9.6** 1928 Holy Communion and its Propers.
- [ ] **P9.7** The proofreading records and book pages for both.

## Phase 10: Holy Scripture and the Psalter

- [ ] **P10.1** `Scripture::`: the canon as Anglican Bibles print it (Old Testament, the Apocrypha as Article VI lists it, New Testament), every abbreviation the books' tables use, ranges and cross-chapter ranges, and the verse mapping between each BCP Psalter and the KJV. Extensive tests.
- [ ] **P10.2 [RIGHTS] [GATE D5]** The Scripture store with attribution metadata and the launch texts: the KJV with the Apocrypha and the World English Bible from identified digital editions, proofread on samples against printed editions, imported by `bin/rails content:bible`, and cleared in `SOURCES.md`.
- [ ] **P10.3** The Bible reader (`/bible/<book>/<chapter>`): books and chapters, go to a reference, verse links, share with the required notice, reading settings, and search. The full site shows a second translation or the cross references in the margin; the phone, one translation with a switch.
- [ ] **P10.4** The Psalter for prayer: each book's Psalter in its own cycle (1662 monthly, 1979 seven-week, and the others as printed), with the book's pointing marks.
- [ ] **P10.5** Lessons in the offices rendered from the store in the reader's chosen translation, labeled, with each book's own reference style.
- [ ] **P10.6** Required notices on every page that shows licensed Scripture, and acknowledgements entries.
- [ ] **P10.7 [RIGHTS]** Cross references from a cleared public-domain dataset (for example the Treasury of Scripture Knowledge).
- [ ] **P10.8 [RIGHTS] [GATE DEMO]** Licensed translations as licenses arrive (D5), with their notices and the guard's ceilings lifted only as each license allows.

## Phase 11: Lectionaries and reading plans

- [ ] **P11.1** The lectionary model in ChurchYear: civil-date tables (1662/1871), week-and-day tables (1979), and proper-based tables, all resolving to `(office, lesson, reference)` for a date and book.
- [ ] **P11.2 [GATE D20]** Golden lectionary files for 2026–2028 per launch lectionary, cross-checked against two independent sources with every difference listed.
- [ ] **P11.3** Reading plans: each launch lectionary as a plan, the 1662 pattern, the Psalter monthly and in seven weeks, Robert Murray M'Cheyne's calendar (1842), the Gospels in Lent, and the Bible in a year (an original arrangement, labeled).
- [ ] **P11.4** The plan page: today's portion, an optional private mark kept in the browser, "begin from today" at any time, and no streaks, catch-up pressure, or scores (D16).
- [ ] **P11.5** A lectionary comparison: the same day's readings in every book, side by side on the full site, one book at a time on the phone.
- [ ] **P11.6** `docs/lectionaries.md`: each lectionary's source, cycle, rules, and tests.

## Phase 12: The Atlas

- [ ] **P12.1** `Atlas::`: works and witnesses (Engineering foundation 9), a concordance file mapping the launch books' prayers, canticles, creeds, and rites to works, and tests that every mapped witness resolves.
- [ ] **P12.2** The compare page: on the full site, two or three witnesses in columns that scroll together; on the phone, two at a time, one above the other, or one with a switch. Word-level differences marked (underlined and announced, never colour alone), an alignment that can ignore spelling and punctuation variants, page references, and sources.
- [ ] **P12.3 [REVIEW]** Book pages: each book's history, who authorized it and where it is used today, its contents, and the printing the site follows, with sources.
- [ ] **P12.4 [REVIEW]** The lineage map: a sourced genealogy of the Books of Common Prayer drawn as an atlas plate (HTML and CSS from the data, so it reflows and reads aloud), every edge citing a source.
- [ ] **P12.5** "Where is this prayer?": from any prayer, its witnesses in every book, or a plain note of its absence.
- [ ] **P12.6 [RIGHTS] [GATE D3]** The historic study layer (D3): identify and clear each book's printing, transcribe, proofread, and show in original spelling with an optional modernized display.
- [ ] **P12.7 [REVIEW]** A timeline of the prayer book, Cranmer to today, each entry sourced and linked to its book page.

## Phase 13: Holy Communion and the pastoral offices

- [ ] **P13.1** Follow-along Holy Communion in each launch book with the day's propers (collect, epistle, gospel, proper preface).
- [ ] **P13.2** Holy Week and Easter across the books: the propers, the Proper Liturgies (1979), and what each book appoints.
- [ ] **P13.3** The pastoral offices index for study and preparation, each with a line to speak with the parish priest.
- [ ] **P13.4 [RIGHTS]** Preparation for Holy Communion and thanksgiving afterwards, from the books and cleared devotional sources.
- [ ] **P13.5 [REVIEW]** A newcomer's guide to the Eucharist in Anglican worship (1662, 1928, Rite I and Rite II): what happens and why, how to take part, and who may receive by the church's own rule (for The Episcopal Church, Canon I.17.7), linking to Grace & Footnotes' next-steps page.

## Phase 14: Personal life of prayer

Everything here lives in the person's own browser (D29) unless they later
choose account sync (P25).

- [ ] **P14.1** The local store: an IndexedDB schema with versions and migrations behind one small Stimulus-facing module (Favorite, Bookmark, Intercession, IntercessionGroup, RuleItem, JournalEntry, PlanProgress, ReadingPosition, OfficeRecord, MyPrayer, Reminder), tested in system tests; a plain message where storage is unavailable.
- [ ] **P14.2** Favorites and bookmarks for every kind of content.
- [ ] **P14.3** The intercession list: names in groups and cycles (daily, weekly), shown in place at the name insertion points a book provides, and a plain list to print. The names are filled in by the browser and never sent to the server.
- [ ] **P14.4** My rule of life: the offices, Communion, reading, fasting, and giving the person chooses, shown on Today; nothing graded.
- [ ] **P14.5** A journal, optionally locked with a passphrase (Web Crypto; the passphrase never leaves the browser and cannot be recovered, said plainly).
- [ ] **P14.6 [REVIEW]** Preparation for confession: the Reconciliation of a Penitent (1979) for preparation, an original explanation of private confession in Anglican practice, and an examination of conscience (the Commandments, the Summary of the Law, the Beatitudes). The notes stay in the browser only, are never synced, exported, or sent, and can be erased with one click. The site never pronounces absolution.
- [ ] **P14.7 [GATE D16]** The office record, as D16 decides.
- [ ] **P14.8** Reminders without tracking: downloadable calendar files (`.ics`) for office times and holy days, so the person's own calendar reminds them; Web Push only later, if ever, with its own decision entry.
- [ ] **P14.9** Export my data (JSON) and import it on another browser; delete all my data, from Settings.
- [ ] **P14.10** My Prayers: user-written prayers, stored locally, that can be ordered and added to a rule.
- [ ] **P14.11 [RIGHTS] [REVIEW]** Devotions, labeled as private devotion rather than prayer-book text and by the tradition that keeps them (for example the Angelus and the Anglican rosary), from cleared sources only.

## Phase 15: Holy days and the saints

- [ ] **P15.1** The commemoration model: names, dates per book, rank as each book gives it, collect keys, and sources.
- [ ] **P15.2 [REVIEW]** Short original notes for the red-letter days (the apostles, evangelists, and the feasts of our Lord), each fact sourced.
- [ ] **P15.3** Holy-day pages: the collect in each book, the readings, the note, and the sources.
- [ ] **P15.4 [REVIEW]** The black-letter days of the 1662 Kalendar explained as facts with sources.
- [ ] **P15.5 [RIGHTS] [GATE DEMO]** Other books' calendars of commemorations as permission allows (Lesser Feasts and Fasts, the 2019 calendar).
- [ ] **P15.6** Holy-day and personal-day reminders (a baptism or confirmation anniversary) as `.ics` files, kept in the browser.

## Phase 16: Learn: the Anglican way

- [ ] **P16.1 [REVIEW]** "New to the prayer book": how the offices work, how the year turns, how to follow a service with a printed book (page numbers), and how to find a parish.
- [ ] **P16.2 [REVIEW]** The catechisms (1662, the 1928 Offices of Instruction, the 1979 Outline of the Faith) with original notes.
- [ ] **P16.3 [REVIEW]** The creeds (Apostles', Nicene, Athanasian) in each book's wording, with original line-by-line notes.
- [ ] **P16.4 [REVIEW]** The Thirty-Nine Articles (the 1662 text and the American form of 1801) with historically careful notes.
- [ ] **P16.5 [REVIEW]** The Anglican Communion and its churches explained fairly: provinces, The Episcopal Church, the ACNA and its relationships, the Continuing churches, and the Chicago-Lambeth Quadrilateral.
- [ ] **P16.6 [REVIEW]** A glossary (Mattins, Evensong, collect, canticle, rubric, red-letter day, Ember Days, Rogation, Septuagesima, ordinary, and many more), linked from where each term appears.
- [ ] **P16.7 [REVIEW]** The history of the prayer book, linked to the Atlas.
- [ ] **P16.8 [REVIEW]** Common questions, representing other Christian traditions fairly.
- [ ] **P16.9 [REVIEW]** Reading guides to C. S. Lewis's books: original notes only, no Lewis text (Research finding 14).
- [ ] **P16.10** The AI-assistance disclosure on every page of original teaching (AGENTS.md §3).
- [ ] **P16.11** Unified search across Learn, the books, Scripture, and the Atlas.

## Phase 17: More prayer books, by permission [GATE DEMO]

Each item follows Phase 8's pattern: printing identified, permission
recorded (including the terms for a website), transcription proofread,
calendar and lectionary as facts, golden files, Atlas integration, and the
required credit line. None holds up version 1.0.

- [ ] **P17.1 [RIGHTS]** The ACNA's 2019 book: the offices, the New Coverdale Psalter, the lectionaries, the calendar, and Holy Communion; excluded from AI use unless the permission says otherwise (Research finding 12).
- [ ] **P17.2 [RIGHTS]** Canada's 1962 book (and the 1918 book, which needs no permission, in the study layer).
- [ ] **P17.3 [RIGHTS]** The Church of England's Common Worship offices and lectionary.
- [ ] **P17.4 [RIGHTS]** Other provinces' books as permission arrives (for example Ireland, Scotland, Australia, New Zealand, Kenya, and Southern Africa).
- [ ] **P17.5 [RIGHTS]** The Episcopal Church's supplements from Church Publishing: Lesser Feasts and Fasts, Enriching Our Worship, and the Book of Occasional Services.
- [ ] **P17.6 [RIGHTS]** The Revised Common Lectionary (the Consultation on Common Texts).
- [ ] **P17.7 [RIGHTS]** The 1662 book and the KJV for readers in the UK, after Cambridge University Press answers (D14).

## Phase 18: The web platform: offline, install, print, share

- [ ] **P18.1** An installable web app: the manifest (`/manifest`, Rails' PWA routes) with the owner's icons, name, colours from the tokens, and `display: standalone`; checked on iPhone (Add to Home Screen) and Android.
- [ ] **P18.2** Offline: a service worker that keeps the site's assets and every prayer page the person has opened, plus an explicit "keep this week offline" for the chosen book, with an honest offline page for anything not kept. Never caches personal data on the server's side.
- [ ] **P18.3** Print: a print stylesheet that turns any office or service into a clean booklet (paper and ink, page numbers, sources, required notices) through the browser's own print, for cleared texts only.
- [ ] **P18.4** Calendar subscriptions (`.ics`) of each book's holy days and fasts, per book, with sources in each event.
- [ ] **P18.5** Sharing: the Web Share API where it exists and a copy-link fallback, always with the text's source and attribution; Open Graph tags per page with the owner's static image (no generated images).
- [ ] **P18.6** Keyboard shortcuts across the full site (sections, search, day navigation), listed on a `?` sheet and in Settings, never overriding the browser's own keys.
- [ ] **P18.7** An OpenSearch description so browsers can search the site from the address bar.
- [ ] **P18.8** Feeds: an Atom feed of each book's day (the day's name, the collect where cleared, the readings as references) for readers who want it.
- [ ] **P18.9** Structured data (schema.org) only where it is accurate, and a `humans.txt` that credits sources, not AI.

## Phase 19: Grace & Footnotes, sharing, and finding a church

- [ ] **P19.1 [GATE D17]** "From Grace & Footnotes": read `https://graceandfootnotes.com/feed.xml` on the server (cached, with our own parser), show recent articles' titles and summaries in the site's style, and link to the full page there.
- [ ] **P19.2** Link the website's gospel presentation (`/gospel`) and next-steps page from Learn and the newcomer's guides.
- [ ] **P19.3** Share cards for collects, verses, and prayers as printable, copyable text with attribution and the site's name.
- [ ] **P19.4** A bookshelf: plain links to the publishers of the books and to good editions, with no affiliate tracking.
- [ ] **P19.5 [GATE D24]** "Find a church": links to each church's official finder, with a line on what to expect at a first visit.

## Phase 20: Public pages and legal

- [ ] **P20.1** The home page for visitors: what the site is, the books it carries (only those actually on the site, never promised ones as present), and the non-affiliation statement, beside Today.
- [ ] **P20.2** The support page (`/support`): support@prayerbookatlas.com, how to report a text error (book, page, and what is wrong), what the site collects (nothing beyond strictly necessary cookies), and frequently asked questions.
- [ ] **P20.3** The privacy policy (`/privacy`) and terms of use (`/terms`), drafted from the real data flows in `docs/legal/` and the rules in Research finding 13, confirmed from primary sources. **[OWNER]** approves them.
- [ ] **P20.4** The cookie statement: every cookie the site sets, what it holds, and why it is strictly necessary; no consent banner because no cookie needs consent (re-checked whenever a cookie is added).
- [ ] **P20.5** The sources page (`/sources`): the books, printings, translations, fonts, images, and permissions the site uses, generated from the content database and `content/SOURCES.md`, with every required credit line.
- [ ] **P20.6** The accessibility statement (`/accessibility`): the standard aimed at (WCAG 2.2 AA), what was tested, known gaps, and how to report a barrier.
- [ ] **P20.7** Favicons and app icons from the owner's images (resized only), `robots.txt`, a sitemap, and custom 404, 422, and 500 pages in the site's style (the 404 with the owner's E4 image), served by Rails' public error pages.
- [ ] **P20.8** A link check in `bin/ci`: every internal link resolves, every page validates as HTML, and no page refers to another host except the external links it means to make.

## Phase 21: Quality hardening

- [ ] **P21.1** Keyboard: every page and control usable with the keyboard alone, visible focus everywhere, a skip link, and a logical order.
- [ ] **P21.2** Screen readers: VoiceOver on macOS and iOS, and NVDA on Windows where available: landmarks, headings, role labels, rubrics as instructions, and differences in compare announced.
- [ ] **P21.3** Text and zoom: 200% text and 400% zoom (320 CSS pixels wide) reflow without loss in both modes; forced colours (Windows High Contrast) keep every meaning; reduced motion respected.
- [ ] **P21.4** Contrast in both appearances, tested from the tokens (WCAG 2 ratios, as `docs/design.md` §3 records).
- [ ] **P21.5** Browsers: Safari, Chrome, Firefox, and Edge, desktop and mobile, current and previous versions, plus an old browser with JavaScript off, each recorded in `docs/browsers.md`.
- [ ] **P21.6** Performance budgets in `docs/performance.md`: server time for Today and an office, page weight (HTML, CSS, fonts), and first render on a slow phone connection; checked in `bin/ci` where measurable.
- [ ] **P21.7** Security: Brakeman and bundler-audit clean, the CSP strict with no `unsafe-*`, rate limits on every form and search (Rails `rate_limit`), request-size limits, secure cookies, and the response headers checked by P5.6.
- [ ] **P21.8** Errors without third parties: Rails' error reporter writing to the server log, with a daily summary the owner can read; no crash-reporting service.
- [ ] **P21.9** An offline test of every offline feature (P18.2) with the network off.
- [ ] **P21.10** System tests covering every critical flow in M1–M5 in both modes.

## Phase 22: Version 1.0 launch

- [ ] **P22.1** The rights audit: generate `docs/rights-audit.md` from `SOURCES.md`, with every served text `cleared` for the readers it reaches (D14).
- [ ] **P22.2 [OWNER] [REVIEW]** Theological sign-off on every [REVIEW] item, with a priest where possible (D18).
- [ ] **P22.3 [OWNER]** A private beta: invite users of each launch book to the site; agents triage feedback into BUILD.md items.
- [ ] **P22.4 [OWNER]** Approve the final icon set and sharing image from the owner's generated images.
- [ ] **P22.5** Open the site to search engines (remove P5.7's development notice and `robots.txt` block) and submit the sitemap. **[OWNER]** approves the day.
- [ ] **P22.6 [OWNER]** Announce the site where the owner chooses (for example Grace & Footnotes, with D17's authorization).
- [ ] **P22.7** Tag `v1.0.0` and record what shipped in the Handoff notes.

## Phase 23: Audio [GATE D22]

- [ ] **P23.1** Read-aloud with the browser's speech synthesis, labeled as synthetic, following the office line by line with the current line marked; off unless started.
- [ ] **P23.2** Recorded audio playback: the Media Session API (lock-screen controls), speed, a sleep timer, resume, and offline keeping through P18.2.
- [ ] **P23.3** Write `docs/audio-production.md`: scripts, recording guidelines, loudness, encoding, naming, and the work-for-hire checklist.
- [ ] **P23.4 [OWNER]** Record or commission the first set: Morning and Evening Prayer and Compline in one book.
- [ ] **P23.5 [RIGHTS]** Chant and sung settings only from owner-made or licensed recordings (Research finding 15).

## Phase 24: AI study assistant [GATE D23]

- [ ] **P24.1** Write `docs/ai-assistant.md`: scope (study help on Scripture, the prayer books, doctrine, history, and parish life), what it is not (a priest, a confessor, an authority), crisis handling, privacy (retention, deletion, no training use), and cost caps.
- [ ] **P24.2 [REVIEW]** Draft the system prompt from SOUL.md and D8. **[OWNER]** approves it.
- [ ] **P24.3** The server side: the Claude API from Rails (current model ids from the official documentation when building), streamed to the page with Turbo Streams, per-visitor caps, and the key only in the server's credentials.
- [ ] **P24.4** Retrieval over cleared content whose AI-use permission allows it (Research finding 12), with citations that link into the site.
- [ ] **P24.5** Text integrity: the model emits reference tags, and the site renders Scripture and prayer-book text from its own store; generated text is never shown as Scripture or as a book's text.
- [ ] **P24.6** An evaluation suite of 150 or more cases (faithfulness to the creeds, fairness among Anglican traditions and to other Christians, refusing to speak as God or a saint, crisis responses, citation accuracy, humility), run on every prompt or model change.
- [ ] **P24.7** The assistant page: sources under each answer, an "AI study assistant, not a priest" label, report an answer, and delete a conversation. The full site keeps the conversation in the margin beside the text being studied; the phone gives it its own page.
- [ ] **P24.8** Its own decision entry for any gem it needs (decision 29).

## Phase 25: Accounts and sync

- [ ] **P25.1 [OWNER]** Decide whether the site needs accounts at all; if not, mark this phase not needed and stop.
- [ ] **P25.2** Accounts with Rails' authentication generator: email and password or passkeys, opaque sessions, the minimum stored, rate-limited sign-in, and no third-party sign-in.
- [ ] **P25.3** Sync of favorites, plans, the rule, and (only if the person turns it on) intercessions, between their browsers; confession notes never leave the browser.
- [ ] **P25.4** Account deletion that deletes everything at once, and an export first.
- [ ] **P25.5** Update the privacy policy and cookie statement (P20.3, P20.4). **[OWNER]** approves.

## Phase 26: Donations and sustainability [GATE D7]

- [ ] **P26.1** Research the giving routes open to an individual (and a nonprofit, if the owner forms one) and record the approach.
- [ ] **P26.2** A quiet "Support this work" page: what gifts pay for, never on a prayer page, never with urgency.
- [ ] **P26.3 [OWNER]** Set up the giving route.
- [ ] **P26.4** Per-visitor caps for the AI assistant and other costly services, with honest messages when a cap is reached.

## Phase 27: Operations and annual maintenance

- [ ] **P27.1** Write `docs/operations.md`: the incident runbook, a quarterly backup-restore drill, log rotation, and the support inbox routine.
- [ ] **P27.2** Annual verification: each autumn, compare next year's computed calendars and lectionaries with printed tables and fix discrepancies with tests.
- [ ] **P27.3** Keep current: Ruby and Rails patch releases as they come (bundler-audit flags security ones), a minor or major upgrade each year with `bin/ci` green, and the server's Ubuntu updates.
- [ ] **P27.4** A yearly rights review: every license's term, territory, and credit line still current.
- [ ] **P27.5** An errata routine: readers' reports of text errors checked against the page images and fixed with a note in `SOURCES.md`.
- [ ] **P27.6 [OWNER]** Renew prayerbookatlas.com and prayerbook-atlas.com before **October 28** each year (Cloudflare; auto-renew recommended).
- [ ] **P27.7 [OWNER]** Renew prayerbookatlas.org before **October 29** each year.
- [ ] **P27.8** Watch the TLS certificates Caddy manages and the uptime of `/up`, with a check the owner controls (no third-party tracking).

## Phase 28: Future directions

The owner decides priority; promoted items become full phases.

- [ ] **P28.1 [RIGHTS]** Other languages with cleared liturgical texts (for example Spanish, French, Swahili, and Chinese editions of the books) and parallel bilingual display.
- [ ] **P28.2 [RIGHTS]** Hymns: public-domain texts keyed to the day, with tunes named; modern hymnals only by license.
- [ ] **P28.3 [RIGHTS]** Pointed psalters and Anglican chant settings.
- [ ] **P28.4 [RIGHTS]** Research the Anglican Breviary, the Monastic Diurnal, and the Anglican and English Missals (publication dates, renewals, and current holders) before considering them.
- [ ] **P28.5** Diocesan cycles of prayer, by permission.
- [ ] **P28.6** A curated parish directory, only with the churches' permission (D24).
- [ ] **P28.7** A public JSON API of the calendar and lectionary facts, for other Anglican projects, if the owner wishes.
- [ ] **P28.8** Native apps only if the owner reopens D27.

---

## Handoff notes

*Replaced each session; keep under 25 lines. History lives in Git.*

- **2026-10-29 pivot session:** the owner made the project a website only,
  in Ruby on Rails (D27). The iPhone app is removed and tagged
  `ios-archive` (`a9be149`); this plan was rewritten for the web.
- **This Mac:** mise's Ruby 4.0.9 is global, Rails 8.1.4 installed, Homebrew
  Ruby off the PATH (P1.1 has the details and the dotfile backups).
- **The app:** Rails 8.1.4 in the repository root. `SiteMode` picks the phone
  site or the full site; layouts `application.html.erb` (full) and
  `application.html+phone.erb`; five placeholder sections and About; tokens
  CSS generated from `design/tokens.json`; Cardo self-hosted as WOFF2; strict
  CSP. `bin/ci` passes. Run it with `bin/dev`.
- **Secrets:** `config/master.key` is local and gitignored; the server will
  need it as `RAILS_MASTER_KEY` (P5.3). Keep a copy somewhere safe.
- **Not deployed.** `docs/deploy.md` is written; P5.2 (`bin/deploy`) is next
  in that phase, and every server step waits for the owner.
- **Next:** P1.10 (dispatch the hosted workflow), P1.11 (system tests),
  P1.12 (web survey), then Phase 2 from P2.4, Phase 3, Phase 4, and P5.2.
- **Owner:** P0.6 (the retired App Store Connect record), P0.7 (optional),
  P0.8 (deferred), the [GATE DEMO] letters, and Phase 5's server steps.
