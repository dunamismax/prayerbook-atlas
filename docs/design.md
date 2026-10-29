# Design: Engraved Plate

**Status: decided.** The owner chose **B · Engraved Plate** for D15 on 2026-10-29, in the
design session (BUILD.md P2.2a), over Ribbon and Quiet Page; the book face is Cardo
(docs/decisions.md entry 18). The values here are the ones the owner saw on the design canvas,
with the additions noted in §2 and §4.

`design/tokens.json` holds every value; this file explains them. Views use named tokens only,
never raw colours (AGENTS.md §5). Change a value in the tokens first, run `make tokens`, and
let the contrast tests judge it.

## 1. The idea

The atlas everywhere: an engraved plate from an old atlas, printed on chart paper in iron-blue
ink. Cards are framed by a double rule, labels are set in small capitals, corners are square,
and one cartographer's blue marks rubrics and the primary action. The season's colour appears
only on the ribbon marker. At night the plate becomes a night chart: deep blue-black paper and
pale ink. It should feel like a careful map of the prayer books, not a game, a poster, or a
stained-glass gradient.

## 2. Colour tokens

| Token | Day | Night | Use |
|---|---|---|---|
| `paper` | `#F3F1EA` | `#0E131A` | Page background |
| `card` | `#F8F7F2` | `#151C26` | Raised surfaces, plates, and sheets |
| `wash` | `#ECEAE2` | `#121821` | Grouped backgrounds, chips, wells, the tab bar's ground |
| `line` | `#B9BCC2` | `#2F3B4C` | Hairlines, borders, card frames; never text |
| `ink` | `#1A2230` | `#E4E8EE` | Body text, headings, the atlas plate's frame |
| `muted` | `#545C6A` | `#9AA5B4` | Secondary text, captions, sources, small-capital labels, faint ribbons' edge |
| `rubric` | `#2A4A7F` | `#8FB1E3` | The one accent: rubrics, initials, red-letter days, role labels, source marks, differences in compare, the primary action |
| `onRubric` | `#F8F7F2` | `#0E131A` | Text on rubric |

**One accent.** The token keeps the name `rubric` because it marks what a printed book prints
in red (rubrics, initials, red-letter days), but in this design its colour is the
cartographer's blue. It also marks the one primary action on a screen. It is never used for
warnings or errors, which use words and the system's own treatment. Where the Kalendar marks a
red-letter day, it says so in words or a symbol as well (§11), so nobody is misled by a blue
"red-letter" day.

**No gilt.** Ribbon's `gilt` ornament token is gone: Engraved Plate draws its ornament with
rules (§7). `onRubric` is new; the canvas showed no filled buttons, but sheets and selected
chips need it.

## 3. Contrast

WCAG 2 ratios, computed 2026-10-29 (all text pairs pass AA, 4.5:1):

| Pair | Day | Night |
|---|---|---|
| `ink` on `paper` / `card` / `wash` | 14.13 / 14.88 / 13.25 | 15.16 / 13.93 / 14.49 |
| `muted` on `paper` / `card` / `wash` | 5.96 / 6.28 / 5.60 | 7.47 / 6.86 / 7.14 |
| `rubric` on `paper` / `card` / `wash` | 7.79 / 8.21 / 7.31 | 8.49 / 7.80 / 8.12 |
| `onRubric` on `rubric` | 8.21 | 8.49 |

`ColorContrastTests` recomputes this table from the compiled asset catalog, so a token change
that breaks a pair fails `make check`. `line` (about 1.6:1) is never used for text or for
anything that must be seen to be understood. With Increase Contrast on, `muted` text is drawn
in `ink`.

## 4. Ribbons

Season markers, from `ribbon` in the tokens. A ribbon always appears beside the season's or
colour's name: colour is never the only carrier of meaning (§11). Most prayer books prescribe
no liturgical colours, so the app labels the sequence as custom and makes it optional (P4.8).
The ribbon is drawn as a short square-ended band, as on the canvas.

| Ribbon | Day | Night | Edge |
|---|---|---|---|
| Violet | `#5B3A78` | `#9677B8` | |
| White | `#FBF8EF` | `#EDE7DB` | muted (day) |
| Green | `#3F6B3A` | `#76A26A` | |
| Red | `#8F1D24` | `#D65A50` | |
| Rose | `#B86A7C` | `#DC9AA8` | |
| Black | `#1D1A17` | `#4A433C` | muted (night) |
| Sarum blue | `#3A5CC0` | `#4F6CC8` | |
| Lenten array | `#CDBF9F` | `#A89A7E` | muted (day) |

White and Lenten array by day, and black by night, fall below 3:1 against `paper`
(1.06, 1.61, and 1.92), so the ribbon component draws those with a hairline edge in `muted`
(at least 3.9:1 against the ribbon). Every other ribbon reaches 3:1 against paper in both
appearances. Sarum blue was moved from Ribbon's `#2E4E8C` to a brighter ultramarine because the
old value was nearly the accent (1.1:1 against `rubric`); a blue ribbon must not read as a
rubric mark.

## 5. Type

- **The book face is Cardo** (SIL Open Font License 1.1, David J. Perry), bundled in Regular,
  Italic, and Bold (P2.4, `App/Resources/Fonts/`, recorded in `content/SOURCES.md`). Views set
  it with `.typeStyle(_:)` (`App/Design/TypeStyle.swift`), never by font name. It sets liturgical text, Scripture, titles, headings, small-capital
  labels, role labels, and page numbers. It has true small capitals (`smcp`, the 1979 Psalter's
  LORD), old-style figures (`onum`), ℣ ℟ † ¶, and polytonic Greek. It has no ✠ (U+2720),
  which falls back to the system's symbol font. EB Garamond is Beautiful Corner's face and is
  avoided.
- **SF Pro** sets the interface: buttons, settings, form controls, and the system tab bar.

The scale (sizes at the default text size; each follows its Dynamic Type text style to AX5):

| Style | Face | Size | Text style | Use |
|---|---|---|---|---|
| display | Cardo | 31 | largeTitle | The day's name on Today; screen titles |
| title | Cardo | 26 | title | Office and section titles |
| heading | Cardo | 22 | title2 | Headings within an office |
| reading | Cardo | 20 | body | Prayers, psalms, canticles, Scripture |
| rubric | Cardo italic, rubric | 17 | callout | Rubrics, in colour or italic by setting |
| initial | Cardo, rubric | two lines | — | The initial that opens a prayer |
| eyebrow | Cardo, small caps, muted | 13 | footnote | Labels above headings and on plates |
| role | Cardo, small caps, rubric | 13 | footnote | Minister, Priest, Officiant, People, Answer |
| tab | Cardo, small caps | 12 | caption | Plate-style labels the app draws |
| pageNumber | Cardo italic, old-style, muted | 13 | footnote | Printed page numbers |
| source | Cardo italic, muted | 14 | subheadline | Book, printing, and page lines |
| sourceMark | Cardo italic, rubric | 13 | footnote | The mark that opens a source sheet |
| action | SF semibold, uppercase, rubric | 14 | subheadline | The primary action |

Small capitals are set from lower-case text with the face's `smcp` feature, never by
shrinking capitals. Only Cardo Regular has `smcp` (Italic and Bold have none), and Bold has no
old-style figures, so small-capital labels are set in Regular, letter-spaced for weight, and
page numbers in Italic. Reading text has a measure of about 640 points; wider screens add margins,
not longer lines.

## 6. Motifs

- **The initial** opens each prayer or section, two lines deep, in rubric; at accessibility
  sizes it becomes an inline capital so lines never break oddly.
- **The rubric**, in colour or in italic (a reading setting), and hideable.
- **The source mark** and **source sheet**: a small italic mark after a text that opens its
  book, printing, and page (P2.5).
- **The printed page number**, in italic old-style figures, set right.
- **Role labels** in small capitals, with the words each book prints.
- **The Psalter's half-verse mark**, colon or asterisk, as each book prints it.
- **The ribbon marker** (§4).
- **The double rule** under an office's title, and around cards and plates (§7).
- **Red-letter days** in the Kalendar, in rubric and marked by a symbol and words too.
- **Differences in compare**, underlined in rubric with a line offset below the text, and
  announced in words to VoiceOver.

## 7. Rules and the atlas plate

Engraved Plate draws its ornament with rules, from `rule` in the tokens:

- **Card frame**: a double rule (two 1-point hairlines, 1 point apart) in `line`, on `card`.
- **Atlas plate**: the same double rule in `ink`, for the Atlas tab's plates (compare, book
  pages, the lineage map), with small-capital labels in `muted` and the `background-graticule`
  texture faint behind map-like views. The generated frames (`frame-atlas-plate.png`,
  `frame-cartouche.png`) are design sources, not cleared assets; the app draws the plate in
  code from tokens unless a cleared image is chosen (P3.6).
- **Title rule**: a double rule in `ink` under an office's title.
- **Hairline**: a single 1-point rule in `line` between rows.

**No compass rose** anywhere: it is the Anglican Communion's emblem (Research finding 11). An
atlas without a compass rose is deliberate.

## 8. Layout and Liquid Glass

- Margins of 22 points on iPhone; content centred to the reading measure on wider screens.
- Spacing comes from `space` in the tokens (4, 8, 12, 16, 24, 32); cards pad 16.
- **Square corners** on everything the app draws: cards, plates, chips, and buttons.
- **The primary action** is an outlined button: a 1-point rule in rubric, uppercase SF
  semibold label in rubric, square, at least 44 points tall.
- **Liquid Glass only on the navigation layer**: the tab bar, toolbars, and sheets' chrome,
  which keep their system shapes. Page content is paper, never glass, so text always sits on
  an opaque, tested background.
- Prayer screens hide nonessential chrome while reading and bring it back on a tap.

## 9. Appearance

Automatic (follow the system), Day, or Night, chosen in Settings (P2.12). Night is a night
chart, deep blue-black and pale ink, not pure black and white. Every token has both values;
nothing is designed for one appearance only.

## 10. Symbols

SF Symbols for the interface while the app's own glyphs are traced (P2.5). The generated
symbol sources (B1–B16 in `design/generated/`, `pending`) were drawn for Ribbon and become
custom SF Symbols only after tracing, restyling as engraved line work, weight-matching, and
release review. No symbol imitates a church's seal, shield, or logo.

## 11. Accessibility

- Every style scales with Dynamic Type to AX5; layouts reflow rather than truncate.
- Contrast passes AA in both appearances (§3), tested.
- Colour never carries meaning alone: ribbons have names, red-letter days have a symbol and
  words, fasts have words, and differences in compare are underlined and announced.
- VoiceOver reads role labels and treats rubrics as instructions; decorative rules are hidden
  from it.
- Reduce Motion removes any non-essential animation; Reduce Transparency makes the navigation
  layer opaque.

## 12. Components

Built in P2.5 from these tokens: card (double-rule frame), eyebrow, initial, rubric, role
label, versicle and response, Amen, repetition, name chip, ribbon marker, title rule, atlas
plate, page-number mark, `SourceFootnote` and its source sheet, margin note, the outlined
primary action, and the empty, loading, and error states.

## 13. The app icon

A closed prayer book seen at an angle, a small cross on the cover, and one ribbon marker
trailing from the pages. The placeholder is the owner's generated icon set (A1–A3 in
`design/generated/`), copied into the asset catalog by `make icon` and checked by
`make guards`. An Engraved Plate version, if the owner wants one, is generated by the owner
from a prompt in `design/image-prompts.md`; agents write prompts and never draw or redraw
images themselves (decision 20). The final icon is P21.8, assembled in Icon Composer. Optional
seasonal icons are chosen by the person in Settings, never switched automatically. No compass
rose.

## 14. Research behind it

- The palette, the double-rule frames, small capitals, square corners, and the outlined action
  come from the owner's chosen artboard on the design canvas (P2.2a, 2026-10-29).
- Contrast: computed with the WCAG 2 relative-luminance formula on 2026-10-29 (§3).
- Face: Cardo was chosen after checking eight OFL faces with fontTools for ℣ ℟ ✠, Greek,
  `smcp`, and `onum` (decision 18). P2.4 records the licence from the font's own files.
- Emblems: the compass rose is the Anglican Communion's emblem; the churches have their own
  shields and marks (Research finding 11).
