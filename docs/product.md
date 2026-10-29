# Product rules

How Prayerbook Atlas is shaped, page by page. BUILD.md's
[Product principles](../BUILD.md#product-principles) say what the site is for; this file turns
them into rules an agent can check a page against. AGENTS.md §3 and SOUL.md govern the faith
and voice behind them.

## 1. Two modes, five sections

The site is drawn in one of two modes (BUILD.md D27, docs/decisions.md entry 24). Both have the
same five sections, the same URLs, and the same texts; they differ in how much they set beside
the text and how a person moves around.

| Section | Holds |
| --- | --- |
| **Today** | The day's name in the chosen book (other books one click away), the season's ribbon, holy days, fasts and abstinence, the office for the hour, the collect, the psalms and lessons, my rule, the reading-plan portion, the next holy day |
| **Pray** | The offices, the Litany, prayers and thanksgivings, Holy Communion, the pastoral offices, devotions, my prayers, intercessions, confession preparation |
| **Bible** | The Bible reader, the day's lessons, each book's Psalter, lectionaries, reading plans |
| **Kalendar** | Month and year views, holy days and commemorations, fasts, the Easter tables |
| **Atlas** | The books and their pages, compare, "where is this prayer?", the lineage map, Learn |

"Kalendar" keeps the prayer books' own spelling as the section's name; its pages explain the
word once, in plain English, for the newcomer.

### The full site (desktop and tablet browsers)

The complete experience, designed first.

- **Masthead**: the wordmark, the five sections, and (from P3.9) search and Settings.
- **Three columns**: the section's **contents** on the left (an office's parts, a book's
  contents, a month's days), the **reading column** in the middle at a measure of about 40rem,
  and the **margin** on the right for sources, printed page numbers, notes, alternatives, and
  the same passage in another book.
- **More side by side**: the Atlas compares up to three books in columns; the Kalendar is a
  month grid; the Bible can show a second translation or the cross references in the margin;
  the lectionary comparison sets every book's readings for a day in a table.
- **Keyboard**: arrow keys between days, keys for the next and previous part of an office, `/`
  for search, `?` for the list of keys (P7.5, P18.6). Every key has a visible equivalent.
- **Print**: any office or service prints as a clean booklet with its sources (P18.3).
- **A narrow window** folds the margin under the text first, then the contents below it; the
  full site never becomes the phone site because a window was resized.

### The phone site (phone browsers)

A dedicated design for the hand, not the full site squeezed.

- **Phone bar** at the top with the wordmark (search and Settings join it).
- **One column**, with a slightly smaller display scale, margins of 1.375rem, and room for the
  safe areas of the screen.
- **Tab bar** of the five sections fixed along the bottom, within reach of a thumb, each
  labeled in words.
- **The margin folds under the text** as "Notes and sources", a native disclosure that opens
  without JavaScript; a source note opens in place.
- **Fewer things at once**: compare shows two books, one above the other, or one with a
  switch; the Kalendar is a list with a month heading; the Bible shows one translation with a
  switch.
- **Swipe** between days as an enhancement of the previous and next links (P6.3).
- **Install and offline**: the phone site can be added to the Home Screen and keeps the pages a
  person has prayed for offline use (P18.1, P18.2).

### How the mode is chosen

- The server chooses before it draws the page: the phone site when the browser says it is a
  mobile device (`Sec-CH-UA-Mobile: ?1`), or, when it does not say, when its user agent is a
  phone's; otherwise the full site. Tablets get the full site.
- **The person can always choose.** Every page's footer says which site is in use and offers
  the other ("Use the full site" or "Use the phone site"); once chosen, "Choose for this device
  automatically" undoes it. The choice is a first-party cookie holding only "phone" or "full".
- A feature added to one mode says in its BUILD.md item what the other mode does instead. A
  text, a source, or a choice the book offers is never available in only one mode.

## 2. URLs and navigation

- **Every destination has a readable URL** (P2.7, `docs/urls.md`), the same in both modes, so a
  link sent from a phone opens the same page on a desktop. A day, an office in a book on a date,
  a prayer in the Atlas, and a compare all have their own.
- **Plain links and forms first.** Navigation is links; settings are forms that post and
  redirect. Turbo makes them quicker; nothing depends on it.
- **Back always goes back.** No page traps the browser's history; settings return the person to
  where they were.
- **No modal stands between a person and prayer.** The first-visit choice of book is a skippable
  card on Today (D4), never a blocking dialog; nothing is required before praying.
- **Today is the home page.** `/` is Today, in the person's book.

## 3. Each book on its own terms

These are the rules that make the site trustworthy; BUILD.md D8 and AGENTS.md §6 give the
reasons.

- **The chosen book governs the page.** Today, the offices, and the Kalendar use the person's
  chosen book (D4) and its own names for the day ("The Fourth Sunday after Trinity" in 1662,
  "Proper 9" in 1979), its own calendar, rubrics, lectionary, and Psalter.
- **No silent borrowing.** If a book lacks something (1662 has no Compline), the page says so
  plainly ("Not in the 1662 book") and may offer the books that have it, each labeled. It never
  fills the gap with another book's text.
- **Book, printing, and page on every text.** Every liturgical block shows, one click away, the
  book, the printing it was transcribed from, and the printed page (P2.8, P2.9). On the full
  site page numbers sit in the margin; on the phone they are inline. Both are a reading setting.
- **No ranking of books.** Lists of books are in a stable order (by date), described in their
  own churches' terms. No book is labeled "traditional", "modern", "correct", or "best" by the
  site; differences are described, not judged.
- **Labels for everything that is not the book's text**: the site's own notes, colours where the
  book prescribes none (P4.8), and every "app convention".

## 4. Prayer pages are quiet

A prayer page is any page that sets out an office, a service, a prayer, a psalm, or a lesson to
be prayed or read.

- No badges, banners, pop-ups, rating prompts, tips, promotions, cookie banners, or "what's new"
  on a prayer page. (No cookie needs consent, so no banner is needed anywhere: P20.4.)
- No animation that is not the direct result of the person's own action; reduced motion removes
  even those.
- The screen may stay awake while praying (a reading setting, P2.10).
- Choices the book offers ("or this") are inline and quiet, and remember the person's last
  choice where the book allows it.
- Nothing on a prayer page asks for anything: no sign-in, no donation, no notification
  permission. Those belong in Settings or at a natural pause, and are always declinable.

## 5. Tone

The site's own words follow AGENTS.md §3 and SOUL.md §5: warm, direct, and plain; learned
without showing off; reverent without theatrical diction. In the interface that means:

- Short labels in sentence case. Plain English first, the prayer book's term second where the
  term matters ("Evening Prayer (Evensong)").
- Explain a term the first time a newcomer will meet it, in a sentence, with a link to Learn.
- No exclamation marks, no urgency, no flattery, no factional or denominational slogans.
- The site never speaks as God, a saint, a priest, or the owner, and never claims faith or a
  prayer life of its own. Original teaching is labeled as drafted with AI assistance and
  reviewed before release.
- **The site is not a priest.** No absolution, blessing, dispensation, or direction. Fasts and
  abstinence appear as each book's rule, with a plain line that one's parish priest may counsel
  differently.

## 6. No guilt mechanics

From D16 and AGENTS.md §3; these hold everywhere, not only on prayer pages.

- No streaks, points, levels, badges, leaderboards, completion percentages, or countdowns.
- A private record of offices prayed exists only if the person turns it on (D16), shows no count
  of consecutive days, and never mentions a missed day.
- Reminders invite and never scold: "Evening Prayer is ready", not "You haven't prayed today".
  They are off until the person sets them up.
- A missed day is simply a day. Reading plans move to today's portion without marking anything
  as behind, and offer to continue where the person left off.
- No paywall on prayer, ever (D7).

## 7. Privacy by design

- No analytics, advertising, tracking, or crash-reporting code, and nothing loaded from another
  host (decisions 15 and 31).
- Intercession names, journals, a personal rule, and favourites stay in the person's own browser
  unless they later turn on account sync (D29, Phase 25). **Confession notes never leave the
  browser**: never synced, never sent, never exported.
- Cookies are first-party and strictly necessary: the session that protects forms, and
  preferences the server needs to draw the page (the mode, the book, reading settings,
  appearance, the time zone). None identifies or follows anyone.
- Sharing always shows what will be shared, with its source and attribution, before it goes.
- The server's logs keep what Puma and Caddy need for operation, rotated (P27.1); no log is
  joined with anything else.

## 8. The newcomer

- Every page makes sense to someone who has never held a prayer book: the office for the hour
  is one click from Today, with nothing to look up.
- Learn (Phase 16) explains Mattins, Evensong, collects, rubrics, the seasons, and how to follow
  along in church with a printed book, and each explanation is reachable from where the term
  appears.
- The site points toward a parish and a priest (D24), never toward itself as a substitute for
  either.

## 9. Accessibility

- WCAG 2.2 AA in both modes and both appearances (Phase 21).
- Text follows the browser's size settings; pages reflow at 200% text and 400% zoom without
  horizontal scrolling.
- Everything works from the keyboard, with a visible focus and a "Skip to the text" link.
- Screen readers hear landmarks, headings, role labels ("Officiant", "People"), and rubrics as
  instructions; the current section is marked with `aria-current`.
- Colour is never the only carrier of meaning: red-letter days, ribbons, and fasts always have
  words or symbols too.
- Contrast meets WCAG AA in day and night (docs/design.md §3).
