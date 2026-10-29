# Sources

The register of every non-original text, font, image, and dataset the site uses or wants (AGENTS.md §6, D14). Nothing is served unless its entry here is `cleared` for the readers it reaches. The content compiler (`bin/rails content:compile`, BUILD.md P3.3) reads this file: content that names a source not registered here, or not cleared, is refused.

No liturgical text or Bible translation is in the repository yet. The prayer books and Bibles below are `pending` candidates, researched and cleared in BUILD.md P8.1, P9.1, and P10.2.

## Schema

Each source is a level-three heading, a fenced block with the info string `source` holding `key: value` lines, and then the evidence in prose. The compiler reads only the fenced blocks; the prose is for people. One key per line; a value runs to the end of its line; `#` begins nothing special. Unknown keys are refused.

| Key | Required | Meaning |
|---|---|---|
| `id` | always | Stable identifier, lower case with hyphens. Content files name it as `source:` (and, for a prayer-book text, as `printing:`). Never reused. |
| `kind` | always | `printing` (a printing of a prayer book), `translation` (an edition of a Bible translation), `font`, `image`, `dataset` (calendar or lectionary facts, cross references), `quotation` (a book quoted from), `original` (the owner's original work), `code`, or `reference` (consulted, never served). |
| `title` | always | The title as the source gives it. |
| `book` | for `printing` | The prayer book's id (`bcp1662`, `bcp1928us`, `bcp1979us`, …). A printing belongs to one book (P3.4). |
| `translation` | for `translation` | The translation's id (`kjva`, `web`, …), as `Translation` knows it. |
| `printing` | for `printing`, `translation`, `quotation` | Which printing or edition: printer, place, year, impression. |
| `year` | when known | Year of the printing or edition. |
| `publisher` | when known | Publisher or printer. |
| `obtained_from` | always | URL, scan, or physical copy the transcription or file was made from. |
| `jurisdiction` | always | Where the source was published, and whose law governs its rights. |
| `rights_us` | always | The rights basis for readers in the United States. |
| `rights_uk` | always | The rights basis for readers in the United Kingdom (Research finding 4). |
| `rights_elsewhere` | always | The rights basis elsewhere, or `unassessed`. |
| `license` | always | `public-domain`, `open` (an open license, named in the rights keys), `permission` (written permission recorded), `none` (not yet available to us), or `not-applicable`. |
| `ai_use` | always | `yes`, `no`, or `not-applicable`, then a reason after a semicolon. |
| `status` | always | `wanted` (to be asked for, D6), `pending` (researched, not cleared), `cleared`, `reference` (consulted only; never served), or `refused`. |
| `cleared_in` | when `cleared` | The territories it is cleared for: `US`, `UK`, … or `all`. A source cleared for one territory is not cleared for another (D14). |
| `notice` | when the license requires one | The credit or notice that must appear wherever its text is shown. |
| `verse_limit` | for licensed Scripture | The most verses the license allows, or `none` when the license sets no ceiling. |
| `acknowledge` | optional | `yes` to list it in Settings' acknowledgements with its `notice` or title. |
| `checked` | always | What was checked, by whom (agent or owner), and when. |

The territories the site serves now are set in `config/content.yml` (`US` during development, D14). A release compile refuses any source a served text uses unless it is `cleared` in every one of them.

## Reference sources

Sources consulted, not served. Nothing from them reaches a page; they are recorded so that each use
as a cross-check can be cited (D20) and so that what may not be taken is plain.

### The Daily Office 2019 (BUILD.md D30, P2A.4)

```source
id: dailyoffice2019
kind: reference
title: The Daily Office 2019 (blocher/dailyoffice2019), commit 51e61877c941705f7fc44d7801642c6e94c8bea4
publisher: Benjamin Locher
year: 2026
obtained_from: https://github.com/blocher/dailyoffice2019 (cloned 2026-10-29 into research/dailyoffice2019/)
jurisdiction: United States
rights_us: code under the MIT License (Copyright 2020 Benjamin Locher); the texts it carries belong to their publishers
rights_uk: as rights_us
rights_elsewhere: as rights_us
license: open
ai_use: yes; its code and facts only, never the 2019 book's texts (Research finding 5)
status: reference
acknowledge: yes
notice: Inspired by The Daily Office 2019, by Benjamin Locher (MIT License).
checked: agent, 2026-10-29: LICENSE, import commands, SQL dump schema and row counts (BUILD.md P2A.1)
```

- **What:** the code and data of [The Daily Office 2019](https://www.dailyoffice2019.com), by
  Benjamin Locher; repository [blocher/dailyoffice2019](https://github.com/blocher/dailyoffice2019),
  commit `51e61877c941705f7fc44d7801642c6e94c8bea4` (2026-10-28), cloned on 2026-10-29 into the
  gitignored `research/dailyoffice2019/`.
- **Rights basis:** its code is under the MIT License ("Copyright 2020 Benjamin Locher"), kept in
  [THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md) for any file ported from it. The MIT License
  covers the code he wrote, not the texts the project carries, which belong to their publishers.
  Facts (names, dates, ranks, references) are not anyone's text, but under D20 they are used only
  as one of two independent cross-checks, cited by file and commit, after the book itself.
- **AI use:** its code, by the MIT License; its facts, as cross-checks. The 2019 book's texts: no,
  without Anglican House's written permission (Research finding 5), so agents do not read them
  from this repository either.
- **Checked:** the repository's `LICENSE`; the import commands (the calendar and lectionary come
  from Google Sheets); the schema and row counts of `site/dailyoffice_2020_04_18.sql`; the data
  files in `site/`. docs/dailyoffice2019.md §5c lists every table.
- **Usable as D20 cross-checks** (facts only, each cited as "The Daily Office 2019, `<table>`,
  `51e6187`"):
  - the `TEC_BCP1979_LFF2006` calendar in the 2020 SQL dumps: its ranks and precedence
    (`churchcal_commemorationrank`), moveable days (`churchcal_temporalecommemoration`, days from
    Easter), fixed days (`churchcal_sanctoralecommemoration`, the 1979 book's holy days only; the
    Lesser Feasts and Fasts 2006 selection is Church Publishing's and waits for P17.5),
    weekday-relative days (`churchcal_sanctoralebasedcommemoration`), and Proper date ranges
    (`churchcal_proper`), for 1979 (P4.3–P4.6);
  - the Eucharistic lectionary's references (`churchcal_massreading`, never its texts), for
    1979's Sunday lectionary (P9.4);
  - the thirty-day psalter table (`office_thirtydaypsalterday`), for 1662's monthly division
    (P8.4);
  - its Easter algorithm (`site/churchcal/utils.py`), as one computation beside our own tests
    and the 1662 tables (P4.2).
- **Not taken, with the reason:**
  - the 2019 Book of Common Prayer's prayers, rubrics, collects, and lectionary
    (`site/office/api/texts/`, `templates/office/`, `office_collect`, `office_officeday`): Anglican
    House's, no AI use without permission; it waits for P17.1;
  - the New Coverdale Psalter and the other psalter texts (`psalter_psalmverse`): the 2019 book's
    and other publishers';
  - its 1928 Psalter (`import_psalms_1928.py`): scraped from a web transcription, not page images
    of an identified printing (AGENTS.md §6);
  - the ESV and its cross references (`site/bible/esv/`) and the other translations in
    `office_scripture`: licensed (D5);
  - Lesser Feasts and Fasts 2024 (`site/churchcal/lff2024.csv` and the PDF in `site/`): Church
    Publishing's (P17.5);
  - hymn texts (`site/hymnal/`): Research finding 15;
  - commemoration biographies and every `ai_*` field: generated prose and images, not sourced
    texts (AGENTS.md §3, §6);
  - audio and synthetic voices: not ours (D22);
  - its look: Adobe Caslon Pro (commercial), icons, logo, and name (D15);
  - user, session, and admin-log tables in the SQL dumps: other people's personal data; never
    opened or loaded.
- **Status:** `reference` (code under MIT; facts for cross-checks only; nothing served).

## Fonts

### Cardo (the book face, BUILD.md P2.3)

```source
id: cardo
kind: font
title: Cardo (Regular 1.0451, Italic 0.991, Bold 1.0011)
publisher: David J. Perry
year: 2011
obtained_from: https://github.com/google/fonts/tree/main/ofl/cardo
jurisdiction: United States
rights_us: SIL Open Font License 1.1
rights_uk: SIL Open Font License 1.1
rights_elsewhere: SIL Open Font License 1.1
license: open
ai_use: not-applicable; a typeface
status: cleared
cleared_in: all
acknowledge: yes
notice: The book face is Cardo, by David J. Perry, under the SIL Open Font License 1.1.
checked: agent, 2026-10-29: names, versions, licence, fsType, glyphs, and file hashes
```

- **Files:** `app/assets/fonts/Cardo-Regular.woff2`, `Cardo-Italic.woff2`, `Cardo-Bold.woff2`, and the licence `Cardo-OFL.txt`, self-hosted by the site. The WOFF2 files were made on 2026-10-29 from the TTFs below with fontTools' `ttLib.woff2 compress`, a lossless recompression that changes no outline, table, or name; the TTFs themselves stay in the gitignored `research/fonts/cardo/`. (Until 2026-10-29 the same TTFs were bundled in the retired iPhone app.)
- **Source versions:** `Cardo-Regular.ttf` (version 1.0451), `Cardo-Italic.ttf` (0.991), `Cardo-Bold.ttf` (1.0011).
- **Creator and holder:** David J. Perry; "Copyright (c) 2002-2011, David J. Perry (hospes02@scholarsfonts.net)", as each file's name table and OFL.txt state.
- **Obtained from:** Google Fonts' repository, `https://github.com/google/fonts/tree/main/ofl/cardo` (latest commit touching the folder: `5f99a56`, 2026-02-26). Checked 2026-10-29 by downloading the four files again and comparing SHA-256: byte-identical to the copies in `research/fonts/cardo/`. Regular `bcb81f37…7988261`, Italic `52c51cfd…1880f9c`, Bold `6c9383b1…5a272e36`, OFL.txt `8e28b778…0e45bb`; the TTF hashes were checked again before conversion on 2026-10-29.
- **Rights basis (all territories):** SIL Open Font License 1.1, stated in each font's name table (ID 13) and in OFL.txt; `fsType` 0 (installable embedding). The OFL permits use and redistribution, including as web fonts, provided the licence travels with the font and the font is not sold by itself. Converting the format without changing the design is not a modification that triggers the Reserved Font Name clause in practice, but to be safe the family name is kept exactly as published and the files are otherwise unchanged. The licence is served beside the fonts and will be listed on the sources page (P20.5).
- **AI use:** not applicable (a typeface, not text).
- **Checked:** names, versions, copyright, licence, and `fsType` with fontTools 4.68; glyphs ℣ ℟ † ¶ and polytonic Greek present in all three faces and ✠ absent; OpenType features: Regular has `smcp` and `onum`, Italic has `onum` but no `smcp`, Bold has no GSUB features. Small capitals seen rendering in Chrome on 2026-10-29; Safari and Firefox are P2.4.
- **Status:** `cleared` (documentary evidence: the OFL 1.1 in the files themselves).

## Generated design images

```source
id: generated-images
kind: image
title: The owner's generated design images (design/image-registry.json)
publisher: the owner
year: 2026
obtained_from: design/image-prompts.md, generated at the owner's request on 2026-10-28
jurisdiction: United States
rights_us: pending release review
rights_uk: pending release review
rights_elsewhere: unassessed
license: not-applicable
ai_use: yes; generation authorized by the owner, no licensed text used
status: pending
checked: agent, 2026-10-28: decoding, transparency, subjects, sizes, recorded per image in the registry
```

- **Source:** [the owner-supplied image prompts](../design/image-prompts.md). The [image registry](../design/image-registry.json) records each exact prompt, generation prompt, supporting generated reference, file hash, dimensions, alpha checks, and limitations.
- **Creator:** AI image generation tool, used at the owner's request.
- **Date:** 2026-10-28.
- **Book, printing, printed page, publisher:** not applicable to these new visual sources.
- **Holder:** not assessed for release.
- **Rights basis:** generated from the project prompts; reference images were also generated for this project. No third-party source image was supplied.
- **Jurisdiction:** to be reviewed for every territory the site reaches (D14) before release.
- **AI use:** the owner authorized generation of this set; no licensed prayer-book text was used.
- **Checked:** all requested filenames; successful PNG decoding; transparency and absence of white paper fills in ink masks; subjects and prohibited-image constraints; native versus requested dimensions; the exact-size square exports and the tinted icon's rebuilt mask (2026-10-28), recorded per image in the registry.
- **Status:** `pending`, design sources only. D15 and release approval remain open.
- **Placeholder use (2026-10-29):** `public/icon.png` is A1 resized to 512×512 with ImageMagick (`-resize 512x512 -strip`) and otherwise unchanged, as the site's placeholder favicon and Home Screen icon for development. This does not clear it: it stays `pending` until release review (P20.7, P22.4). (From 2026-10-28 to 2026-10-29, A1–A3 were the retired iPhone app's placeholder icon.)

| Image ID | Title | File | Status |
| --- | --- | --- | --- |
| A1 | App icon, light (the master) | [icon-app-light.png](../design/generated/icon-app-light.png) | pending |
| A2 | App icon, dark appearance | [icon-app-dark.png](../design/generated/icon-app-dark.png) | pending |
| A3 | App icon, tinted mode | [icon-app-tinted.png](../design/generated/icon-app-tinted.png) | pending |
| A4 | Icon Composer layer: the book | [icon-layer-book.png](../design/generated/icon-layer-book.png) | pending |
| A5 | Icon Composer layer: the ribbon | [icon-layer-ribbon.png](../design/generated/icon-layer-ribbon.png) | pending |
| A6 | Seasonal icon: violet (Advent and Lent) | [icon-season-violet.png](../design/generated/icon-season-violet.png) | pending |
| A7 | Seasonal icon: white and gold (Christmas and Easter) | [icon-season-white.png](../design/generated/icon-season-white.png) | pending |
| A8 | Seasonal icon: green (the seasons after Epiphany and Trinity) | [icon-season-green.png](../design/generated/icon-season-green.png) | pending |
| A9 | Seasonal icon: rose (Gaudete and Laetare Sundays) | [icon-season-rose.png](../design/generated/icon-season-rose.png) | pending |
| A10 | Seasonal icon: Sarum blue (Advent) | [icon-season-blue.png](../design/generated/icon-season-blue.png) | pending |
| A11 | Seasonal icon: Lenten array | [icon-season-array.png](../design/generated/icon-season-array.png) | pending |
| A12 | Small mark (favicon and tiny sizes) | [mark-small.png](../design/generated/mark-small.png) | pending |
| B1 | The Atlas (tab) | [symbol-atlas.png](../design/generated/symbol-atlas.png) | pending |
| B2 | The prayer book (Pray tab, launch screen) | [symbol-prayerbook.png](../design/generated/symbol-prayerbook.png) | pending |
| B3 | The ribbon (season marker) | [symbol-ribbon.png](../design/generated/symbol-ribbon.png) | pending |
| B4 | Compare | [symbol-compare.png](../design/generated/symbol-compare.png) | pending |
| B5 | Lineage of the books | [symbol-lineage.png](../design/generated/symbol-lineage.png) | pending |
| B6 | The Psalter | [symbol-psalter.png](../design/generated/symbol-psalter.png) | pending |
| B7 | Red-letter day | [symbol-red-letter.png](../design/generated/symbol-red-letter.png) | pending |
| B8 | Fast day | [symbol-fast.png](../design/generated/symbol-fast.png) | pending |
| B9 | Day of abstinence | [symbol-abstinence.png](../design/generated/symbol-abstinence.png) | pending |
| B10 | Ember Days | [symbol-ember.png](../design/generated/symbol-ember.png) | pending |
| B11 | Rogation Days | [symbol-rogation.png](../design/generated/symbol-rogation.png) | pending |
| B12 | Vigil or eve | [symbol-vigil.png](../design/generated/symbol-vigil.png) | pending |
| B13 | Intercessions | [symbol-intercessions.png](../design/generated/symbol-intercessions.png) | pending |
| B14 | Preparation for confession | [symbol-confession.png](../design/generated/symbol-confession.png) | pending |
| B15 | The Litany | [symbol-litany.png](../design/generated/symbol-litany.png) | pending |
| B16 | Reading plan | [symbol-plan.png](../design/generated/symbol-plan.png) | pending |
| C1 | No favorites yet | [empty-favorites.png](../design/generated/empty-favorites.png) | pending |
| C2 | No intercessions yet | [empty-intercessions.png](../design/generated/empty-intercessions.png) | pending |
| C3 | No journal entries yet | [empty-journal.png](../design/generated/empty-journal.png) | pending |
| C4 | No search results | [empty-search.png](../design/generated/empty-search.png) | pending |
| C5 | Nothing appointed today | [empty-plan.png](../design/generated/empty-plan.png) | pending |
| C6 | Not in this book | [empty-not-in-book.png](../design/generated/empty-not-in-book.png) | pending |
| C7 | Something went wrong | [empty-error.png](../design/generated/empty-error.png) | pending |
| D1 | Divider | [ornament-divider.png](../design/generated/ornament-divider.png) | pending |
| D2 | Corner ornament | [ornament-corner.png](../design/generated/ornament-corner.png) | pending |
| D3 | Atlas plate frame | [frame-atlas-plate.png](../design/generated/frame-atlas-plate.png) | pending |
| D4 | Cartouche | [frame-cartouche.png](../design/generated/frame-cartouche.png) | pending |
| D5 | Share card frame, square | [frame-share-square.png](../design/generated/frame-share-square.png) | pending |
| D6 | Share card frame, portrait | [frame-share-portrait.png](../design/generated/frame-share-portrait.png) | pending |
| D7 | Map graticule (behind the lineage map) | [background-graticule.png](../design/generated/background-graticule.png) | pending |
| E1 | Welcome (first launch) | [plate-welcome.png](../design/generated/plate-welcome.png) | pending |
| E2 | Website hero | [web-hero.png](../design/generated/web-hero.png) | pending |
| E3 | Website sharing image (Open Graph) | [web-og.png](../design/generated/web-og.png) | pending |
| E4 | Website 404 page | [web-404.png](../design/generated/web-404.png) | pending |
| E5 | Advent | [plate-advent.png](../design/generated/plate-advent.png) | pending |
| E6 | Christmas | [plate-christmas.png](../design/generated/plate-christmas.png) | pending |
| E7 | Epiphany | [plate-epiphany.png](../design/generated/plate-epiphany.png) | pending |
| E8 | Lent | [plate-lent.png](../design/generated/plate-lent.png) | pending |
| E9 | Holy Week | [plate-holy-week.png](../design/generated/plate-holy-week.png) | pending |
| E10 | Easter | [plate-easter.png](../design/generated/plate-easter.png) | pending |
| E11 | Whitsunday or Pentecost | [plate-pentecost.png](../design/generated/plate-pentecost.png) | pending |
| E12 | The season after Trinity or Pentecost | [plate-trinity.png](../design/generated/plate-trinity.png) | pending |

## Original work

```source
id: original
kind: original
title: Original work of Prayerbook Atlas (notes, guides, glossary, interface text)
publisher: the owner
year: 2026
obtained_from: this repository
jurisdiction: United States
rights_us: the owner's; all rights reserved (LICENSE)
rights_uk: as rights_us
rights_elsewhere: as rights_us
license: not-applicable
ai_use: yes; drafted with AI assistance and reviewed before release (AGENTS.md §3)
status: cleared
cleared_in: all
checked: agent, 2026-10-29
```

Original texts are labeled as original in the data (`source: original`) and carry `review: pending` or `review: approved` (AGENTS.md §4, §6). Teaching pages say that they were researched and drafted with AI assistance and reviewed before release (P16.10).

## Prayer books: public-domain candidates

Each is `pending` until its printing is identified from page images, its title and copyright pages are read, and its rights are recorded per territory (BUILD.md P8.1, P9.1, P12.6, P17.2).

### The Book of Common Prayer (1662), Church of England (Research finding 4)

```source
id: bcp1662-candidate
kind: printing
book: bcp1662
title: The Book of Common Prayer (1662)
printing: to be identified in P8.1: a printing carrying the 1871 Revised Table of Lessons, and the current Cambridge text for comparison
obtained_from: to be identified (Internet Archive or HathiTrust page images)
jurisdiction: England
rights_us: public domain by age
rights_uk: Crown prerogative (Letters Patent); Cambridge University Press acts as the Crown's patentee, and reproduction needs its permission (Research finding 4)
rights_elsewhere: unassessed
license: public-domain
ai_use: yes; public domain in the US
status: pending
checked: agent, 2026-10-28: LibriVox's 1662 notice on the Crown's rights; no printing identified yet
```

### The Book of Common Prayer (1928), The Episcopal Church (Research finding 3)

```source
id: bcp1928us-candidate
kind: printing
book: bcp1928us
title: The Book of Common Prayer (1928), Protestant Episcopal Church in the United States of America
printing: to be identified in P9.1, with which revision of the tables of lessons it carries
obtained_from: to be identified (page images)
jurisdiction: United States
rights_us: public domain by age for the 1928 text (US works of 1928 entered the public domain on 1 January 2024); later printings with the revised lectionary need their own check; Canon II.3.6 to be read in P9.1
rights_uk: unassessed
rights_elsewhere: unassessed
license: public-domain
ai_use: yes; public domain in the US
status: pending
checked: agent, 2026-10-28: the rule for US works published in 1928; no printing identified yet
```

### The Book of Common Prayer (1979), The Episcopal Church (Research finding 3)

```source
id: bcp1979us-candidate
kind: printing
book: bcp1979us
title: The Book of Common Prayer (1979), The Episcopal Church
printing: candidate: the Episcopal Church's PDF of the 2007 printing, to be checked against a printed copy in P9.1
publisher: Church Publishing Incorporated, for The Episcopal Church
year: 2007
obtained_from: https://www.episcopalchurch.org/wp-content/uploads/2021/02/book-of-common-prayer-2006.pdf
jurisdiction: United States
rights_us: Canon II.3.6 makes authorized versions of the Book of Common Prayer public domain, per the explanation to General Convention 2024 resolution D038; the canon's own wording to be recorded in P9.1
rights_uk: unassessed
rights_elsewhere: unassessed
license: public-domain
ai_use: yes; if the canon makes it public domain
status: pending
checked: agent, 2026-10-28: resolution D038's explanation; the canon itself not yet read
```

### The Book of Common Prayer (1918), the Church of England in Canada (Research finding 7)

```source
id: bcp1918ca-candidate
kind: printing
book: bcp1918ca
title: The Book of Common Prayer (1918), Church of England in Canada
printing: to be identified (P17.2, the study layer)
obtained_from: to be identified (page images)
jurisdiction: Canada
rights_us: public domain by age
rights_uk: unassessed
rights_elsewhere: unassessed
license: public-domain
ai_use: yes; public domain in the US
status: pending
checked: agent, 2026-10-28: publication date only
```

## Scripture: public-domain candidates (Research finding 9, D5)

### The King James Version with the Apocrypha

```source
id: kjva-candidate
kind: translation
translation: kjva
title: The Holy Bible, Authorized (King James) Version, with the Apocrypha
printing: a digital edition to be identified and proofread on samples against a printed edition in P10.2
obtained_from: to be identified (for example eBible.org)
jurisdiction: England
rights_us: public domain
rights_uk: Crown prerogative (Letters Patent); Cambridge University Press acts as the Crown's patentee (Research finding 4)
rights_elsewhere: unassessed
license: public-domain
ai_use: yes; public domain in the US
status: pending
checked: agent, 2026-10-28: the Crown's rights in the UK; no edition chosen yet
```

### The World English Bible

```source
id: web-candidate
kind: translation
translation: web
title: World English Bible (with the deuterocanonical books)
printing: an eBible.org edition, to be identified with its date in P10.2
obtained_from: https://ebible.org (to be confirmed in P10.2)
jurisdiction: United States
rights_us: public domain, as its publisher dedicates it
rights_uk: public domain, as its publisher dedicates it
rights_elsewhere: public domain, as its publisher dedicates it
license: public-domain
ai_use: yes; public domain
status: pending
checked: agent, 2026-10-28: its public-domain dedication as reported; to be read at the source in P10.2
```

## Wanted (D6)

Asked for once the site is demoable ([GATE DEMO]; BUILD.md P0.12–P0.14). Each stays `wanted` until a written answer is recorded; none may be used before.

```source
id: bcp2019-acna
kind: printing
book: bcp2019acna
title: The Book of Common Prayer (2019), Anglican Church in North America, with the New Coverdale Psalter and its lectionaries
publisher: Anglican House Publishers
obtained_from: not yet; https://anglicanhousepublishers.org/permissions/
jurisdiction: United States
rights_us: copyright; apps and digital tools need the publisher's permission; no AI ingestion without written permission (Research finding 5)
rights_uk: copyright
rights_elsewhere: copyright
license: none
ai_use: no; forbidden without written permission
status: wanted
notice: Excerpts from The Book of Common Prayer (2019), Anglican Church in North America. Used by permission of Anglican House.
checked: agent, 2026-10-28: the permissions page
```

```source
id: bas1962-canada
kind: printing
book: bcp1962ca
title: The Book of Common Prayer (1962), Anglican Church of Canada
publisher: General Synod of the Anglican Church of Canada
obtained_from: not yet; https://www.anglican.ca/texts
jurisdiction: Canada
rights_us: copyright 1962, the General Synod (Research finding 7)
rights_uk: copyright
rights_elsewhere: copyright
license: none
ai_use: no; until permission says otherwise
status: wanted
checked: agent, 2026-10-28
```

```source
id: common-worship
kind: printing
book: cw
title: Common Worship, Church of England (Daily Prayer and the lectionary)
publisher: The Archbishops' Council
obtained_from: not yet; https://www.churchofengland.org/copyright
jurisdiction: England
rights_us: copyright; no use in software or apps without written permission (Research finding 6)
rights_uk: copyright; as rights_us
rights_elsewhere: copyright
license: none
ai_use: no; until permission says otherwise
status: wanted
checked: agent, 2026-10-28
```

```source
id: cup-crown-texts
kind: reference
title: The 1662 Book of Common Prayer and the King James Version for readers in the UK
publisher: Cambridge University Press, the Crown's patentee
obtained_from: not yet
jurisdiction: England
rights_us: public domain (not needed)
rights_uk: Crown prerogative; permission wanted (D14, P17.7)
rights_elsewhere: unassessed
license: none
ai_use: not-applicable; a permission, not a text
status: wanted
checked: agent, 2026-10-28
```

```source
id: rcl
kind: dataset
title: The Revised Common Lectionary
publisher: Consultation on Common Texts
obtained_from: not yet
jurisdiction: United States
rights_us: copyright; limited local non-commercial reproduction with a credit line; publishers and organizations ask permission (Research finding 8)
rights_uk: copyright
rights_elsewhere: copyright
license: none
ai_use: no; until permission says otherwise
status: wanted
checked: agent, 2026-10-28: the CCT sample notice
```

```source
id: church-publishing-supplements
kind: printing
book: tec-supplements
title: Lesser Feasts and Fasts, Enriching Our Worship, and the Book of Occasional Services
publisher: Church Publishing Incorporated
obtained_from: not yet
jurisdiction: United States
rights_us: presumed copyright until checked (Research finding 3)
rights_uk: copyright
rights_elsewhere: copyright
license: none
ai_use: no; until permission says otherwise
status: wanted
checked: agent, 2026-10-28
```

```source
id: rsv
kind: translation
translation: rsv
title: The Revised Standard Version
publisher: National Council of the Churches of Christ in the USA
obtained_from: not yet
jurisdiction: United States
rights_us: copyright; license wanted (D5)
rights_uk: copyright
rights_elsewhere: copyright
license: none
ai_use: no; until the license says otherwise
status: wanted
checked: agent, 2026-10-28
```

```source
id: esv
kind: translation
translation: esv
title: The English Standard Version
publisher: Crossway
obtained_from: not yet
jurisdiction: United States
rights_us: copyright; license wanted (D5)
rights_uk: copyright
rights_elsewhere: copyright
license: none
ai_use: no; until the license says otherwise
status: wanted
checked: agent, 2026-10-28
```

```source
id: nrsv
kind: translation
translation: nrsv
title: The New Revised Standard Version (and Updated Edition)
publisher: National Council of the Churches of Christ in the USA
obtained_from: not yet
jurisdiction: United States
rights_us: copyright; license wanted (D5)
rights_uk: copyright
rights_elsewhere: copyright
license: none
ai_use: no; until the license says otherwise
status: wanted
checked: agent, 2026-10-28
```
