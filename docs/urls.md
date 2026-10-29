# URLs

Every destination on the site has a readable, stable URL, the same in both modes, so a link
sent from a phone opens the same page on a desktop (docs/product.md §2, BUILD.md P2.7). This
file is the plan; `config/routes.rb` follows it. A destination whose phase has not arrived is
already routed to an honest placeholder that says what will be there and that nothing is ready
yet, so its address never changes when the real page arrives.

## Rules

- **Lower case, words joined by hyphens**: `/pray/bcp1662/morning-prayer`.
- **Stable identifiers.** Prayer books by their content id (`PrayerBook`: `bcp1662`,
  `bcp1928us`, `bcp1979us`; books added by permission get new ids); Bible translations by
  theirs (`Translation`: `kjva`, `web`). These ids never change once released.
- **Dates are ISO 8601** (`2027-03-28`), a civil date with no time or zone (decision 30). A date
  that does not exist (`2027-02-30`) is a 404, never a guess.
- **The person's choices are not in the path.** The prayer book in use, the translation, and
  reading settings come from preferences; a URL that names a book or translation shows that
  one, so shared links show what the sender saw.
- **Query strings are for views of a page, not for what the page is**: `?date=` and `?book=` on
  Today, `?translation=` in the Bible, `?q=` for search. Nothing personal ever goes in a URL.
- **No trailing slashes, no file extensions** except feeds and calendars (`.ics`, `.atom`).
- **Unknown ids are 404s**: an unknown book, office, or translation does not fall back to
  another one.

## Today

| URL | Page | Phase |
|---|---|---|
| `/` | Today in the person's book | P6.2 |
| `/?date=2027-03-28` | Today's page for another day (tests, screenshots, shared links) | P6.1 |
| `/?book=bcp1979us` | Today in another book, without changing the preference | P6.2 |

## Pray

| URL | Page | Phase |
|---|---|---|
| `/pray` | The offices, prayers, and services of the person's book; personal prayer | P7 |
| `/pray/bcp1662` | One book's contents for prayer | P7 |
| `/pray/bcp1662/morning-prayer` | An office today; the offices are `morning-prayer`, `evening-prayer`, `noonday-prayer`, `compline`, `family-prayer`, `litany`, and `holy-communion`. A book without one says so (P7.1) | P7, P13 |
| `/pray/bcp1662/morning-prayer/2027-03-28` | An office on a date | P7 |
| `/pray/bcp1662/collects/advent-1` | A collect, by the content's own key | P8.3, P9 |
| `/pray/bcp1662/prayers/for-rain` | A prayer or thanksgiving, by key | P8.2, P9 |
| `/pray/bcp1662/offices/burial` | A pastoral office, for study and preparation | P8.7, P13.3 |
| `/pray/intercessions` | The intercession list, kept in the browser | P14.3 |
| `/pray/my-prayers` | The person's own prayers, kept in the browser | P14.10 |
| `/pray/confession` | Preparation for confession, kept in the browser and never sent | P14.6 |

## Bible

| URL | Page | Phase |
|---|---|---|
| `/bible` | The reader's start: books, the day's lessons, plans | P10.3 |
| `/bible/john/3` | A chapter, in the person's translation | P10.3 |
| `/bible/john/3/16-21` | A passage (verses `16`, `16-21`) | P10.3 |
| `/bible/john/3?translation=web` | The same in a named translation | P10.3 |
| `/bible/psalter/bcp1662` | A book's own Psalter | P10.4 |
| `/bible/psalter/bcp1662/23` | A psalm in that book's Psalter, by that book's numbering | P10.4 |
| `/bible/psalter/bcp1662/day/4` | A day of that book's Psalter cycle | P10.4 |
| `/bible/lectionaries/bcp1979us-daily-office` | A lectionary | P11 |
| `/bible/plans/mcheyne` | A reading plan | P11.3 |

Bible books are named in the path by lower-case English names with hyphens (`genesis`,
`1-kings`, `song-of-solomon`, `wisdom`); `Scripture::` (P10.1) owns the list and its
abbreviations, and an unknown name becomes a 404 there.

## Kalendar

| URL | Page | Phase |
|---|---|---|
| `/kalendar` | This month | P6.4 |
| `/kalendar/2027` | A year | P6.4 |
| `/kalendar/2027/03` | A month | P6.4 |
| `/kalendar/2027-03-28` | A day, in every launch book | P6.5 |
| `/kalendar/easter/2027` | Easter and the moveable feasts for a year, with the tables | P6.6 |
| `/kalendar/bcp1662.ics` | A book's holy days as a calendar subscription | P18.4 |

## Atlas

| URL | Page | Phase |
|---|---|---|
| `/atlas` | The books, compare, the lineage map, Learn | P12 |
| `/atlas/books/bcp1662` | A book's page: who authorized it, where it is used, the printing followed | P12.3 |
| `/atlas/prayers/general-confession` | Where is this prayer? Its witnesses in every book | P12.5 |
| `/atlas/compare/general-confession/bcp1662/bcp1979us` | Two or three witnesses side by side, in the order given | P12.2 |
| `/atlas/lineage` | The lineage map | P12.4 |
| `/atlas/learn` | Learn: the Anglican way | P16 |
| `/atlas/learn/the-daily-office` | A Learn page | P16 |

Works (`general-confession`) are named by the Atlas concordance (P12.1).

## Everywhere

| URL | Page | Phase |
|---|---|---|
| `/search?q=collect+for+purity` | Search | P3.9 |
| `/settings` | Settings | P2.6, P2.12 |
| `/about` | About the site | P1.8 |
| `/sources` | The register of sources, from the content database | P3.8, P20.5 |
| `/support`, `/privacy`, `/terms`, `/accessibility` | Public pages, routed by their own phase | P20 |
| `/up` | Rails' health check, for the deploy | P5.2 |
| `/dev/type`, `/dev/components` | Development aids, never routed in production | P2.4, P2.5 |
