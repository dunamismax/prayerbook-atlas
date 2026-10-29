# Design: Ribbon

**Status: working default.** D15 (the visual identity) is open. This document records the
**Ribbon** proposal from BUILD.md as the working default (AGENTS.md §4), so the app can be
built in it now. The design session (P2.2a) still renders Ribbon beside two alternatives for
the owner to choose; if the owner chooses otherwise, `design/tokens.json` and this file change
first, and the generated colours follow (P2.3).

`design/tokens.json` holds every value; this file explains them. Views use named tokens only,
never raw colours (AGENTS.md §5).

## 1. The idea

A well-kept prayer book by lamplight: India paper, lamp-black ink, one rubric red, a gilt edge
drawn only as a hairline, and ribbon markers in the colours of the Church's year, the one
place the season's colour appears. The Atlas screens borrow the engraved plate of an old
atlas: double-rule frames, small-capital labels, fine hairlines. At night the page turns to
warm soot. It should feel like a fine prayer book, not a game, a poster, or a stained-glass
gradient.

## 2. Colour tokens

| Token | Day | Night | Use |
|---|---|---|---|
| `paper` | `#F6F2E9` | `#13110E` | Page background |
| `card` | `#FBF9F3` | `#1B1814` | Raised surfaces and sheets |
| `wash` | `#ECE6D8` | `#231F1A` | Grouped backgrounds, chips, wells |
| `line` | `#DCD3C1` | `#36302A` | Hairlines and borders; never text |
| `ink` | `#1D1A17` | `#EDE7DB` | Body text and headings |
| `muted` | `#675F55` | `#A69E91` | Secondary text, captions, sources |
| `rubric` | `#A42A1E` | `#E2765F` | Rubrics, initials, red-letter days, source marks, the primary action |
| `onRubric` | `#FBF9F3` | `#13110E` | Text on rubric |
| `gilt` | `#A3803A` | `#CFAE63` | Ornament only; never text |

**One accent.** Rubric red is the only accent colour. It marks what the printed book prints
in red (rubrics, initials, red-letter days) and the one primary action on a screen. It is never
used for warnings or errors, which use words and the system's own treatment.

## 3. Contrast

WCAG 2 ratios, computed 2026-10-28 (all text pairs pass AA, 4.5:1):

| Pair | Day | Night |
|---|---|---|
| `ink` on `paper` / `card` / `wash` | 15.50 / 16.45 / 13.92 | 15.31 / 14.36 / 13.30 |
| `muted` on `paper` / `card` / `wash` | 5.62 / 5.96 / 5.05 | 7.11 / 6.67 / 6.18 |
| `rubric` on `paper` / `card` / `wash` | 6.42 / 6.81 / 5.76 | 6.27 / 5.89 / 5.45 |
| `onRubric` on `rubric` | 6.81 | 6.27 |
| `gilt` on `paper` (ornament, needs 3) | 3.29 | 8.87 |

P2.3 turns this table into a test, so a token change that breaks a pair fails `make check`.
With Increase Contrast on, `muted` text is drawn in `ink`.

## 4. Ribbons

Season markers, from `ribbon` in the tokens. A ribbon always appears beside the season's or
colour's name: colour is never the only carrier of meaning (§11). Most prayer books prescribe
no liturgical colours, so the app labels the sequence as custom and makes it optional (P4.8).

| Ribbon | Day | Night | Edge |
|---|---|---|---|
| Violet | `#5B3A78` | `#9677B8` | |
| White | `#FBF8EF` | `#EDE7DB` | gilt (day) |
| Green | `#3F6B3A` | `#76A26A` | |
| Red | `#8F1D24` | `#D65A50` | |
| Rose | `#B86A7C` | `#DC9AA8` | |
| Black | `#1D1A17` | `#4A433C` | gilt (night) |
| Sarum blue | `#2E4E8C` | `#7393CF` | |
| Lenten array | `#CDBF9F` | `#A89A7E` | gilt (day) |

White and Lenten array by day, and black by night, fall below 3:1 against `paper`
(1.05, 1.63, and 1.94), so the ribbon component always draws those with a gilt hairline edge.
The liturgical red is a deeper crimson than `rubric`, so a red ribbon is never mistaken for a
rubric mark.

## 5. Type

- **The book face** sets liturgical text, Scripture, titles, and headings. P2.4 chooses between
  Libre Caslon Text and Baskervville (each to be confirmed as SIL Open Font License 1.1), bundles it with its
  licence, and checks its glyphs: small capitals (the 1979 Psalter's LORD), ℣ ℟ ✠ † ¶, Greek,
  and old-style figures for page numbers. The story that John Baskerville printed the Book of
  Common Prayer at Cambridge is to be verified (edition and date) before it is told. EB
  Garamond is Beautiful Corner's face and is avoided. Until P2.4, the system serif (New York)
  stands in.
- **SF Pro** sets the interface: buttons, tabs, labels, settings, eyebrows, and source lines.

The scale (sizes at the default text size; each follows its Dynamic Type text style to AX5):

| Style | Face | Size | Text style | Use |
|---|---|---|---|---|
| display | book, 500 | 34 | largeTitle | The day's name on Today; screen titles |
| title | book, 500 | 28 | title | Office and section titles |
| heading | book, 500 | 22 | title2 | Headings within an office; card titles |
| reading | book, 400 | 20 | body | Prayers, psalms, canticles, Scripture |
| rubric | book, italic | 17 | callout | Rubrics, red or italic by setting |
| initial | book | two lines | — | The red initial |
| eyebrow | SF, 600, small caps | 12 | caption | Labels above headings |
| role | SF, 600, as printed | 12 | caption | Minister, Priest, Officiant, People, Answer |
| pageNumber | book, old-style | 13 | footnote | Printed page numbers in the margin |
| source | SF | 13 | footnote | Book, printing, and page lines |
| sourceMark | book, rubric | 13 | footnote | The mark that opens a source sheet |

Reading text has a measure of about 640 points; wider screens add margins, not longer lines.

## 6. Motifs

- **The red initial** opens each prayer or section, two lines deep; at accessibility sizes it
  becomes an inline red capital so lines never break oddly.
- **The rubric**, in red or in italic (a reading setting), and hideable.
- **The source mark** and **source sheet**: a small rubric mark after a text that opens its
  book, printing, and page (P2.5).
- **The printed page number** in the margin, in old-style figures.
- **Role labels** exactly as each book prints them.
- **The Psalter's half-verse mark**, colon or asterisk, as each book prints it.
- **The ribbon marker** (§4) and **the gilt hairline**, drawn at the hairline width only.
- **Red-letter days** in the Kalendar, in rubric red and marked by a symbol too.
- **The atlas plate** (§7).

## 7. The atlas plate

The Atlas tab's screens (book pages, compare, the lineage map) sit in an engraved-plate frame:
a double rule in `line` with a gilt hairline inside, small-capital labels in `muted`, and the
`background-graticule` texture faint behind map-like views. The generated frames
(`frame-atlas-plate.png`, `frame-cartouche.png`) are design sources, not cleared assets; the
app draws the plate in code from tokens unless a cleared image is chosen (P3.6). **No compass
rose** anywhere: it is the Anglican Communion's emblem (Research finding 11).

## 8. Layout and Liquid Glass

- Margins of 20 points on iPhone; content centred to the reading measure on wider screens.
- Spacing comes from `space` in the tokens (4, 8, 12, 16, 24, 32); corners from `radius` (8 for
  chips, 14 for cards, 22 for sheets).
- **Liquid Glass only on the navigation layer**: the tab bar, toolbars, and sheets' chrome. Page
  content is paper, never glass, so text always sits on an opaque, tested background.
- Prayer screens hide nonessential chrome while reading and bring it back on a tap.

## 9. Appearance

Automatic (follow the system), Day, or Night, chosen in Settings (P2.12). Night is warm soot and
lamplight, not pure black and white. Every token has both values; nothing is designed for one
appearance only.

## 10. Symbols

SF Symbols for the interface while the app's own glyphs are traced (P2.5). The generated
symbol sources (B1–B16 in `design/generated/`, `pending`) become custom SF Symbols only after
tracing, weight-matching, and release review. No symbol imitates a church's seal, shield, or
logo.

## 11. Accessibility

- Every style scales with Dynamic Type to AX5; layouts reflow rather than truncate.
- Contrast passes AA in both appearances (§3), tested.
- Colour never carries meaning alone: ribbons have names, red-letter days have a symbol, fasts
  have words.
- VoiceOver reads role labels and treats rubrics as instructions; decorative ornaments are
  hidden from it.
- Reduce Motion removes any non-essential animation; Reduce Transparency makes the navigation
  layer opaque.

## 12. Components

Built in P2.5 from these tokens: card, eyebrow, red initial, rubric, role label, versicle and
response, Amen, repetition, name chip, ribbon marker, gilt hairline, atlas plate, page-number
margin mark, `SourceFootnote` and its source sheet, margin note, and the empty, loading, and
error states.

## 13. The app icon

A closed prayer book seen at an angle, a small gilt cross on the cover, and one rubric-red
ribbon marker trailing from the pages, on paper (day) or soot (night), with a white tinted
silhouette. The generated sources are A1–A5 in `design/generated/` (light, dark, tinted, and
the book and ribbon layers for Icon Composer); copies of A1–A3 are the placeholder icon
(P1.11). `design/icon/` will hold the Icon Composer file when P21.8 assembles the final icon
from the layers. Optional seasonal icons (A6–A11) are chosen by the person in Settings, never
switched automatically. No compass rose.

## 14. Research behind it

- Contrast: computed with the WCAG 2 relative-luminance formula on 2026-10-28 (§3).
- Emblems: the compass rose is the Anglican Communion's emblem; the churches have their own
  shields and marks (Research finding 11). Their usage terms are to be confirmed before any
  page mentions them.
- Type: both candidate faces are understood to be distributed under the SIL OFL 1.1; P2.4
  confirms the licence from each font's own files, checks glyph coverage, and verifies the
  Baskerville printing history before either is bundled or the story is told.
