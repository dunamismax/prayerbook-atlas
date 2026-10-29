# Design: Engraved Plate

**Status: decided.** The owner chose **B · Engraved Plate** for D15 on 2026-10-29, in the
design session, over Ribbon and Quiet Page; the book face is Cardo (docs/decisions.md entry 18).
The design was made for the retired iPhone app and carries to the website unchanged in its
values (decision 21); this file describes it in CSS.

`design/tokens.json` holds every value; this file explains them. `bin/rails design:tokens`
turns the tokens into CSS custom properties in `app/assets/stylesheets/tokens.css`, which is
committed and never edited by hand. Every other stylesheet uses only those properties, never a
raw colour (AGENTS.md §5); `DesignTokensTest` fails if the generated file is stale or another
stylesheet writes a colour. Change a value in the tokens first, regenerate, and let the
contrast tests judge it.

## 1. The idea

The atlas everywhere: an engraved plate from an old atlas, printed on chart paper in iron-blue
ink. Cards are framed by a double rule, labels are set in small capitals, corners are square,
and one cartographer's blue marks rubrics and the primary action. The season's colour appears
only on the ribbon marker. At night the plate becomes a night chart: deep blue-black paper and
pale ink. It should feel like a careful map of the prayer books, not a game, a poster, or a
stained-glass gradient.

## 2. Colour tokens

| Token | CSS property | Day | Night | Use |
|---|---|---|---|---|
| `paper` | `--paper` | `#F3F1EA` | `#0E131A` | Page background |
| `card` | `--card` | `#F8F7F2` | `#151C26` | Raised surfaces, plates, the masthead, the phone and tab bars |
| `wash` | `--wash` | `#ECEAE2` | `#121821` | Grouped backgrounds, chips, wells, notices |
| `line` | `--line` | `#B9BCC2` | `#2F3B4C` | Hairlines, borders, card frames; never text |
| `ink` | `--ink` | `#1A2230` | `#E4E8EE` | Body text, headings, the atlas plate's frame |
| `muted` | `--muted` | `#545C6A` | `#9AA5B4` | Secondary text, captions, sources, small-capital labels, faint ribbons' edge |
| `rubric` | `--rubric` | `#2A4A7F` | `#8FB1E3` | The one accent: rubrics, initials, red-letter days, role labels, source marks, links, differences in compare, the primary action, focus rings |
| `onRubric` | `--on-rubric` | `#F8F7F2` | `#0E131A` | Text on rubric |

**One accent.** The token keeps the name `rubric` because it marks what a printed book prints
in red (rubrics, initials, red-letter days), but in this design its colour is the
cartographer's blue. It also marks links and the one primary action on a page. It is never used
for warnings or errors, which use words. Where the Kalendar marks a red-letter day, it says so
in words or a symbol as well (§11), so nobody is misled by a blue "red-letter" day.

## 3. Contrast

WCAG 2 ratios, computed 2026-10-29 (all text pairs pass AA, 4.5:1):

| Pair | Day | Night |
|---|---|---|
| `ink` on `paper` / `card` / `wash` | 14.13 / 14.88 / 13.25 | 15.16 / 13.93 / 14.49 |
| `muted` on `paper` / `card` / `wash` | 5.96 / 6.28 / 5.60 | 7.47 / 6.86 / 7.14 |
| `rubric` on `paper` / `card` / `wash` | 7.79 / 8.21 / 7.31 | 8.49 / 7.80 / 8.12 |
| `onRubric` on `rubric` | 8.21 | 8.49 |

`ContrastTest` recomputes every pair from `design/tokens.json` with the WCAG
relative-luminance formula and checks the ratios recorded there, so a token change that breaks
a pair fails `bin/ci`. `line` (about 1.6:1) is never used for text or for anything that must be
seen to be understood. Under `prefers-contrast: more`, `--muted` takes the value of `--ink` (`base.css`).

## 4. Ribbons

Season markers, from `ribbon` in the tokens (`--ribbon-violet` and so on). A ribbon always
appears beside the season's or colour's name: colour is never the only carrier of meaning
(§11). Most prayer books prescribe no liturgical colours, so the site labels the sequence as
custom and makes it optional (P4.8). The ribbon is drawn as a short square-ended band.

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

White and Lenten array by day, and black by night, fall below 3:1 against `paper` (1.06, 1.61,
and 1.92), so the ribbon is drawn with a 1px edge in `muted` for those, in both appearances
for simplicity (`--ribbon-<name>-edge`, generated; the others are edged in their own colour). Every other ribbon
reaches 3:1 against paper in both appearances. Sarum blue is a brighter ultramarine than the
accent so a blue ribbon never reads as a rubric mark.

## 5. Type

- **The book face is Cardo** (SIL Open Font License 1.1, David J. Perry), self-hosted in
  Regular, Italic, and Bold as WOFF2 (`app/assets/fonts/`, with its OFL; `fonts.css`), recorded
  in `content/SOURCES.md`. It sets liturgical text, Scripture, titles, headings, small-capital
  labels, role labels, and page numbers, through `--face-book`. It has true small capitals
  (`smcp`, the 1979 Psalter's LORD), old-style figures (`onum`), ℣ ℟ † ¶, and polytonic Greek.
  It has no ✠ (U+2720). That one character is drawn by **Atlas Cross** (`fonts.css`), a
  `unicode-range` face made only of the system's own fonts through `local()`: STIX Two Math or
  STIXGeneral on macOS (serif crosses that sit well beside Cardo), then Segoe UI Symbol
  (Windows), DejaVu Serif (Linux), Noto Sans Symbols 2 (Android), and Zapf Dingbats (iOS).
  Nothing is downloaded, so no font needs clearing; where none of these is present, the browser
  takes the glyph from any font it has. The fallback stack, for the moment before Cardo loads,
  is Iowan Old Style, Palatino, and Georgia.
- **Checked in three engines** (P2.4, 2026-10-29, on `/dev/type`, the development-only type
  specimen): Chrome (the in-app browser, full and phone site, day and night, 200% text),
  Firefox 159 (headless screenshot), and WebKit, Safari's engine (`script/webkit_snapshot.swift`).
  All three draw Cardo's small capitals, old-style figures, ℣ ℟ † ¶, polytonic Greek, and the
  ✠ from Atlas Cross. Safari itself and the phones' browsers are checked in P21.5.
- **The interface face is the system's** (`--face-interface`: `system-ui` and its fallbacks):
  buttons, form controls, and the primary action.

Sizes come from the tokens' points divided by 16, so they are `rem` and follow the browser's
own text size. The scale, as generated (`--type-<style>-size`):

| Style | Face | Size | Use |
|---|---|---|---|
| display | Cardo | 1.9375rem | The day's name on Today; page titles (`h1`). The phone sets `h1` a step smaller, at the title size |
| title | Cardo | 1.625rem | Office and section titles (`h2`). The phone sets `h2` a step smaller, at the heading size |
| heading | Cardo | 1.375rem | Headings within an office (`h3`); the wordmark on the full site |
| reading | Cardo | 1.25rem, leading 1.55 | Prayers, psalms, canticles, Scripture; the body |
| rubric | Cardo italic, rubric | 1.0625rem | Rubrics, in colour or italic by setting (`.rubric`) |
| initial | Cardo, rubric | two lines | The initial that opens a prayer (P2.5) |
| eyebrow | Cardo small caps, muted | 0.8125rem, tracked 0.12em | Labels above headings and on plates (`.eyebrow`) |
| role | Cardo small caps, rubric | 0.8125rem | Minister, Priest, Officiant, People, Answer |
| tab | Cardo small caps | 0.75rem | The phone's tab bar |
| pageNumber | Cardo italic, old-style, muted | 0.8125rem | Printed page numbers |
| source | Cardo italic, muted | 0.875rem | Book, printing, and page lines (`.source`); the margin and the footer |
| sourceMark | Cardo italic, rubric | 0.8125rem | The mark that opens a source note |
| action | system-ui semibold, uppercase, rubric | 0.875rem | The primary action (`.primary-action`) |
| ui | system-ui | 1.0625rem | Interface text |

Small capitals are set from lower-case text with `text-transform: lowercase` and
`font-variant-caps: small-caps`, which uses Cardo's own `smcp`; never by shrinking capitals.
Only Cardo Regular has `smcp`, so small-capital labels are Regular. The body uses old-style
figures (`font-variant-numeric: oldstyle-nums`). Reading text keeps a measure of 40rem; wider
windows add space, not longer lines.

## 6. Motifs

- **The initial** opens each prayer or section, two lines deep, in rubric (`initial-letter`
  where supported, an enlarged first capital otherwise).
- **The rubric**, in colour or in italic (a reading setting), and hideable; marked for screen
  readers as an instruction.
- **The source mark** and **source note**: a small italic mark after a text that opens its book,
  printing, and page, through the HTML `popover` attribute, so it needs no script (P2.5).
- **The printed page number**, in italic old-style figures: in the margin on the full site,
  inline on the phone.
- **Role labels** in small capitals, with the words each book prints.
- **The Psalter's half-verse mark**, colon or asterisk, as each book prints it.
- **The ribbon marker** (§4).
- **The double rule** under a page's title (`.title-rule`), and around cards and plates (§7).
- **Red-letter days** in the Kalendar, in rubric and marked by a symbol and words too.
- **Differences in compare**, underlined in rubric with an offset underline, and announced in
  words to screen readers.

## 7. Rules and the atlas plate

Engraved Plate draws its ornament with rules, in CSS from `rule` in the tokens:

- **Card frame** (`.plate-card`): `border: 3px double var(--line)` on `--card`.
- **Atlas plate** (`.atlas-plate`): the same double rule in `--ink`, for compare, book pages,
  and the lineage map, with small-capital labels in `--muted`. The owner's generated frames
  (`frame-atlas-plate.png`, `frame-cartouche.png`) and the `background-graticule` texture are
  design sources, not cleared assets; the site draws the plate in CSS unless a cleared image is
  chosen (P3.6).
- **Title rule** (`.title-rule`): a double rule in `--ink` under a page's title.
- **Hairline** (`.hairline`): a 1px rule in `--line` between rows.
- The masthead, the phone bar, the tab bar, and the footer are set off from the page by a
  double rule in `--line`.

**No compass rose** anywhere: it is the Anglican Communion's emblem (Research finding 11). An
atlas without a compass rose is deliberate.

## 8. Layout in the two modes

`layout.css` holds both shells (docs/product.md §1).

**The full site** (`body.site--full`):

- The masthead on `--card`: the wordmark (with "the books of common prayer" in small capitals
  beneath) and the five sections in small capitals; the current one in rubric with a double
  underline.
- A grid of three columns within 82rem: contents (14rem), the reading column (flexible, its
  text held to 40rem), and the margin (17rem), with gaps of 2rem.
- Below 75rem wide the margin moves under the text; below 52rem the contents move to the end
  and the masthead wraps. The full site stays the full site; it only folds.

**The phone site** (`body.site--phone`):

- A sticky phone bar on `--card` with the wordmark.
- One column with side margins of 1.375rem or the screen's safe area, whichever is larger.
- `h1` at the title size and `h2` at the heading size: display and title a step smaller.
- A tab bar fixed to the bottom, five equal cells at least 3.5rem tall in small capitals, the
  current one in rubric with a rule along its top edge, padded for the home indicator
  (`env(safe-area-inset-bottom)`). The page is padded so the tab bar never covers text.
- The margin's content folds into a "Notes and sources" disclosure at the end of the text.

Both:

- Spacing comes from `--space-*` (0.25, 0.5, 0.75, 1, 1.5, 2rem); cards pad 1rem.
- **Square corners** on everything: cards, plates, chips, buttons, and focus rings.
- **The primary action** (`.primary-action`) is an outlined button: a 1px rule in rubric,
  uppercase semibold interface text in rubric, square, at least 2.75rem tall. `.quiet-action`
  is its secondary form, ruled in `--line`.
- Links are rubric, underlined with a 1px offset rule that thickens on hover. Focus is a 2px
  rubric outline, offset 2px.
- **Print** hides the masthead, bars, contents, and switches; P18.3 designs the booklet.

## 9. Appearance

Automatic (follow the system), Day, or Night. `tokens.css` sets the day values on `:root`, the
night values under `@media (prefers-color-scheme: dark)` unless `<html data-appearance="day">`,
and the night values again for `data-appearance="night"`. The server writes `data-appearance`
from the person's choice in Settings (P2.6), so a chosen appearance never flashes the other
first. The choice is a cookie holding only "day" or "night" (`AppearancePreference`);
Automatic deletes it and writes no attribute. The Appearance form is a full page load
(`data-turbo="false"`), because Turbo swaps the body and would leave `<html>` unchanged. `color-scheme` follows, so form controls and scrollbars match. Night is a night chart,
deep blue-black and pale ink, not pure black and white. Every token has both values; nothing is
designed for one appearance only.

## 10. Symbols and images

Words first: the sections, the mode switch, and every control are labeled in words, so no icon
is required to understand anything. Custom symbols come only from images the owner generates
and supplies (decision 20); agents write the prompts in `design/image-prompts.md` and never
draw, redraw, trace, or restyle a symbol or image, including as SVG. Agents may resize and
export the owner's files. No symbol imitates a church's seal, shield, or logo.

## 11. Accessibility

- Text sizes are `rem`, so they follow the browser's settings; layouts reflow at 200% text and
  400% zoom rather than scroll sideways.
- Contrast passes AA in both appearances (§3), tested.
- Colour never carries meaning alone: ribbons have names, red-letter days have a symbol and
  words, fasts have words, the current section has `aria-current` as well as colour, and
  differences in compare are underlined and announced.
- Screen readers get landmarks (`header`, `nav` with labels, `main`, `aside`, `footer`), one
  `h1` per page, role labels, and rubrics as instructions; decorative rules are borders, not
  content.
- A "Skip to the text" link is the first focusable element on every page.
- `prefers-reduced-motion: reduce` removes animation and transitions.

## 12. Components

In `components.css`, drawn by the helpers in `app/helpers/components_helper.rb` and the
`shared/_state` partial (P2.5). Each draws the same markup in both modes; the stylesheet places
it for the full site or the phone. No helper supplies a prayer book's words: the caller passes
the book's own text, labels, and page. `/dev/components` (development and test only) shows them
all.

| Component | Helper or partial | Class | Notes |
|---|---|---|---|
| Eyebrow | `eyebrow` | `.eyebrow` | Small capitals in `--muted` |
| Card, atlas plate | `plate_card(title, label:, plate:)` | `.plate-card`, `.atlas-plate` | Double rule in `--line` or `--ink`; labelled by its heading |
| Title rule, hairline | `title_rule` | `.title-rule`, `.hairline` | Rules, not images |
| Initial | `initial_paragraph` | `.has-initial` | Two lines deep in rubric: `initial-letter` where supported, an enlarged floated capital otherwise |
| Rubric | `rubric` | `.rubric` | Announced as "Instruction:" to screen readers |
| Role label | `role_label` | `.role-label` | Small capitals in rubric; ℣ and ℟ keep the text's size (`.role-label--mark`) |
| Versicles and responses | `versicles([label, text], ...)` | `.versicles`, `.versicle` | Each line with the label the book prints, hanging |
| Amen | `amen(text)` | `.amen` | As printed; never breaks inside |
| Repetition | `repetition` | `.repetition` | Set in; announced as "Repeated:" |
| Name chip | `name_chip(name)` | `.name-chip` | A person's name, or the book's own placeholder |
| Ribbon marker | `ribbon_marker(key)` | `.ribbon-marker`, `.ribbon--<key>` | The band and its name together (§4) |
| Page number | `page_mark(page)` | `.page-mark`, `.with-page-marks` | Hangs in a right gutter on the full site; inline on the phone and below 30rem |
| Source mark and note | `source_note { ... }` | `.source-mark`, `.source-note` | The `popover` attribute: opens without script, closes with Escape, a click outside, or Close; shown inline where popovers are unsupported |
| Margin note | `margin_note(title) { ... }` | `.margin-note` | The margin on the full site; "Notes and sources" on the phone |
| Empty, loading, error | `render "shared/state", kind:` | `.state`, `.state--<kind>` | Words first; the error is an `alert`, the others a `status` |
| Notice | — | `.notice` | A double rule at the left on `--wash`; always in words |
| Primary and quiet actions | — | `.primary-action`, `.quiet-action` | Square, outlined |
| Plain list | — | `.plain-list` | Hairlines between rows |
| Shells | — | `.masthead`, `.section-nav`, `.full-layout`, `.contents`, `.reading`, `.margin`, `.phone-bar`, `.tab-bar`, `.site-footer`, `.mode-switch` | `layout.css` |

## 13. Icons and the favicon

The placeholder favicon and Home Screen icon (`public/icon.png`) is the owner's generated app
icon A1, resized to 512×512 and otherwise unchanged; it stays `pending` like every generated
image until P20.7 and P22.4 settle the final set. The installable web app's icons (P18.1) come
from the same set. No compass rose.

## 14. Research behind it

- The palette, the double-rule frames, small capitals, square corners, and the outlined action
  come from the owner's chosen artboard on the design canvas (2026-10-29).
- Contrast: the WCAG 2 relative-luminance formula (§3), recomputed by `ContrastTest`.
- Face: Cardo was chosen after checking eight OFL faces with fontTools for ℣ ℟ ✠, Greek,
  `smcp`, and `onum` (decision 18). The WOFF2 files are lossless recompressions of the cleared
  TTFs (`content/SOURCES.md`).
- Emblems: the compass rose is the Anglican Communion's emblem; the churches have their own
  shields and marks (Research finding 11).
