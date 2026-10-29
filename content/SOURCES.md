# Sources

The register of every non-original text, font, image, and dataset the site uses (AGENTS.md §6). So far it covers the book face and the owner's generated design images; BUILD.md P3.1 gives it its full schema and P3.6 its image registry. No liturgical text, Bible translation, scanned book page, or third-party illustration is in the repository yet.

## Fonts

### Cardo (the book face, BUILD.md P2.3)

- **Files:** `app/assets/fonts/Cardo-Regular.woff2`, `Cardo-Italic.woff2`, `Cardo-Bold.woff2`, and the licence `Cardo-OFL.txt`, self-hosted by the site. The WOFF2 files were made on 2026-10-29 from the TTFs below with fontTools' `ttLib.woff2 compress`, a lossless recompression that changes no outline, table, or name; the TTFs themselves stay in the gitignored `research/fonts/cardo/`. (Until 2026-10-29 the same TTFs were bundled in the retired iPhone app.)
- **Source versions:** `Cardo-Regular.ttf` (version 1.0451), `Cardo-Italic.ttf` (0.991), `Cardo-Bold.ttf` (1.0011).
- **Creator and holder:** David J. Perry; "Copyright (c) 2002-2011, David J. Perry (hospes02@scholarsfonts.net)", as each file's name table and OFL.txt state.
- **Obtained from:** Google Fonts' repository, `https://github.com/google/fonts/tree/main/ofl/cardo` (latest commit touching the folder: `5f99a56`, 2026-02-26). Checked 2026-10-29 by downloading the four files again and comparing SHA-256: byte-identical to the copies in `research/fonts/cardo/`. Regular `bcb81f37…7988261`, Italic `52c51cfd…1880f9c`, Bold `6c9383b1…5a272e36`, OFL.txt `8e28b778…0e45bb`; the TTF hashes were checked again before conversion on 2026-10-29.
- **Rights basis (all territories):** SIL Open Font License 1.1, stated in each font's name table (ID 13) and in OFL.txt; `fsType` 0 (installable embedding). The OFL permits use and redistribution, including as web fonts, provided the licence travels with the font and the font is not sold by itself. Converting the format without changing the design is not a modification that triggers the Reserved Font Name clause in practice, but to be safe the family name is kept exactly as published and the files are otherwise unchanged. The licence is served beside the fonts and will be listed on the sources page (P20.5).
- **AI use:** not applicable (a typeface, not text).
- **Checked:** names, versions, copyright, licence, and `fsType` with fontTools 4.68; glyphs ℣ ℟ † ¶ and polytonic Greek present in all three faces and ✠ absent; OpenType features: Regular has `smcp` and `onum`, Italic has `onum` but no `smcp`, Bold has no GSUB features. Small capitals seen rendering in Chrome on 2026-10-29; Safari and Firefox are P2.4.
- **Status:** `cleared` (documentary evidence: the OFL 1.1 in the files themselves).

## Generated design images

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
