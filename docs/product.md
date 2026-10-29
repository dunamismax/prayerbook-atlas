# Product rules

How Prayerbook Atlas is shaped, screen by screen. BUILD.md's
[Product principles](../BUILD.md#product-principles) say what the app is for; this file turns
them into rules an agent can check a screen against. AGENTS.md §3 and SOUL.md govern the faith
and voice behind them. Where a rule rests on an open owner decision, it names the decision and
follows its recommendation until the owner answers.

## 1. Information architecture

Five tabs, each with its own navigation stack, plus the system search tab. Settings opens from
a toolbar button on every tab's root screen; it is not a tab.

| Tab | SF Symbol (placeholder until P2.5) | Holds |
| --- | --- | --- |
| **Today** | `sun.horizon` | The day's name in the chosen book (other books one tap away), the season's ribbon, holy days, fasts and abstinence, the office for the hour, the collect, the psalms and lessons, my rule, the reading-plan portion, the next holy day |
| **Pray** | `book.closed` | The offices, the Litany, prayers and thanksgivings, Holy Communion, the pastoral offices, devotions, my prayers, intercessions, confession preparation |
| **Bible** | `text.book.closed` | The Bible reader, the day's lessons, each book's Psalter, lectionaries, reading plans |
| **Kalendar** | `calendar` | Month and year views, holy days and commemorations, fasts, the Easter tables |
| **Atlas** | `map` | The books and their pages, compare, "where is this prayer?", the lineage map, Learn |
| Search | `magnifyingglass` | Every text, prayer, collect, psalm, and Learn page, filtered by book and kind (P3.9) |

"Kalendar" keeps the prayer books' own spelling as the tab's name; its screens explain the word
once, in plain English, for the newcomer.

On iPhone the tab bar shows all six (five tabs and search). On iPad a sidebar shows the same
destinations in the same order. Nothing important lives only in a gesture or a long press.

## 2. Navigation

- **Every destination has a route** (`AppRoute`, P2.7) and a URL
  (`prayerbookatlas://…`), so widgets, notifications, Siri, links in the Atlas, and UI tests
  reach any screen the same way.
- **The tab and the path are restored** on relaunch (P2.6). A person who closed the app halfway
  through Evening Prayer finds it where they left it.
- **Back always goes back.** No screen replaces the navigation stack except a tap on a tab.
  Deep links push onto the right tab's stack rather than presenting over everything.
- **Sheets are for short, dismissible things**: a source note, a choice between alternatives,
  sharing. A whole office or service is never a sheet.
- **No modal stands between a person and prayer.** First-launch setup is a skippable card
  (D4's recommendation), never a blocking modal; nothing is required before praying.
- **Today is the home.** The app opens on Today unless the person was in the middle of
  something.

## 3. Each book on its own terms

These are the rules that make the app trustworthy; BUILD.md D8 and AGENTS.md §6 give the
reasons.

- **The chosen book governs the screen.** Today, the offices, and the Kalendar use the person's
  chosen book (D4) and its own names for the day ("The Fourth Sunday after Trinity" in 1662,
  "Proper 9" in 1979), its own calendar, rubrics, lectionary, and Psalter.
- **No silent borrowing.** If a book lacks something (1662 has no Compline), the screen says so
  plainly ("Not in the 1662 book") and may offer the books that have it, each labeled. It never
  fills the gap with another book's text.
- **Book, printing, and page on every text.** Every liturgical block shows, one tap away, the
  book, the printing it was transcribed from, and the printed page (P2.8, P2.9). Page numbers
  in the margin are a reading setting.
- **No ranking of books.** Lists of books are in a stable order (by date), described in their
  own churches' terms. No book is labeled "traditional", "modern", "correct", or "best" by the
  app; differences are described, not judged.
- **Labels for everything that is not the book's text**: the app's own notes, colours where the
  book prescribes none (P4.8), and every "app convention".

## 4. Prayer screens are quiet

A prayer screen is any screen that sets out an office, a service, a prayer, a psalm, or a
lesson to be prayed or read.

- No badges, banners, pop-ups, rating prompts, tips, promotions, or "what's new" on a prayer
  screen.
- No animation that is not the direct result of the person's own action; Reduce Motion
  removes even those.
- The screen may stay awake while praying (a reading setting, P2.10).
- Choices the book offers ("or this") are inline and quiet, and remember the person's last
  choice where the book allows it.
- Nothing on a prayer screen asks for anything: no sign-in, no donation, no notification
  permission. Those belong in Settings or at a natural pause, and are always declinable.

## 5. Tone

The app's own words follow AGENTS.md §3 and SOUL.md §5: warm, direct, and plain; learned
without showing off; reverent without theatrical diction. In the interface that means:

- Short labels in sentence case. Plain English first, the prayer book's term second where the
  term matters ("Evening Prayer (Evensong)").
- Explain a term the first time a newcomer will meet it, in a sentence, with a link to Learn.
- No exclamation marks, no urgency, no flattery, no factional or denominational slogans.
- The app never speaks as God, a saint, a priest, or the owner, and never claims faith or a
  prayer life of its own. Original teaching is labeled as drafted with AI assistance and
  reviewed before release.
- **The app is not a priest.** No absolution, blessing, dispensation, or direction. Fasts and
  abstinence appear as each book's rule, with a plain line that one's parish priest may counsel
  differently.

## 6. No guilt mechanics

From D16 and AGENTS.md §3; these hold everywhere, not only on prayer screens.

- No streaks, points, levels, badges, leaderboards, completion percentages, or countdowns.
- A private record of offices prayed exists only if the person turns it on (D16's
  recommendation), shows no count of consecutive days, and never mentions a missed day.
- Notifications invite and never scold: "Evening Prayer is ready", not "You haven't prayed
  today". They are off until the person turns them on.
- A missed day is simply a day. Reading plans move to today's portion without marking anything
  as behind, and offer to continue where the person left off.
- No paywall on prayer, ever (D7).

## 7. Privacy by design

- No analytics, advertising, tracking, or crash-reporting SDKs (decision 15). The privacy
  manifest and App Store label declare no data collected.
- Intercession names, journals, a personal rule, and favourites stay on the device unless the
  person turns on iCloud sync. **Confession notes never leave the device**: never synced,
  never backed up to iCloud, never shared or exported.
- Sharing always shows what will be shared, with its source and attribution, before it goes.
- The network is for sync, audio downloads, the Grace & Footnotes feed, and (later) the AI
  study assistant. Nothing needed for prayer waits on it.

## 8. The newcomer

- Every screen makes sense to someone who has never held a prayer book: the office for the
  hour is one tap from Today, with nothing to look up.
- Learn (Phase 15) explains Mattins, Evensong, collects, rubrics, the seasons, and how to follow
  along in church with a printed book, and each explanation is reachable from where the term
  appears.
- The app points toward a parish and a priest (D24), never toward itself as a substitute for
  either.

## 9. Accessibility

- Dynamic Type through the largest accessibility size (AX5) on every screen; layouts reflow
  rather than truncate.
- VoiceOver announces role labels ("Officiant", "People") and reads rubrics as instructions.
- Colour is never the only carrier of meaning: red-letter days, ribbons, and fasts always
  have words or symbols too.
- Contrast meets WCAG AA in both appearances (tested, P2.3).
