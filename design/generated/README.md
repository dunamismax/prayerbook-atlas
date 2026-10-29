# Generated image sources

All 54 requested PNGs are in this folder. Open [the gallery](index.html) to browse them, or open a PNG directly. The [prompt set](../image-prompts.md) and [image registry](../image-registry.json) record every source and the actual generation prompts.

These are design sources for the **Ribbon proposal**. D15 remains open; generating the set does not approve the design, assemble an Icon Composer file, create SF Symbols, or enable seasonal plates on Today.

| Family | Files |
| --- | ---: |
| A. App icon, layers, appearances, seasonal versions, small mark | 12 |
| B. Custom symbol glyphs | 16 |
| C. Empty states | 7 |
| D. Ornaments and frames | 7 |
| E. Illustrated plates and website images | 12 |

## Export state

The 15 landscape images are 1536×1024 and the portrait share frame is 1024×1536. The generator returned the 38 square images at 1254×1254 despite the prompts requesting 1024×1024. Their native files are retained pending approval for local export resizing.

Every requested transparent image has a real alpha channel. The black symbols, empty states, ornaments, and 404 drawing have no opaque white paper fills, so they can be tinted with an alpha mask. Black line art may appear black against a black image-viewer background; the gallery shows it on a checkerboard and as ivory on soot. The night samples use CSS masking and do not change the PNGs.

The tinted icon (`icon-app-tinted.png`) is a draft: some alpha edges and the transparent cross still need deterministic cleanup. The separate book and ribbon layers need final alignment verification in Icon Composer.

## Next uses

- Assemble A4 and A5 over the solid day/night background in Icon Composer (P21.8).
- Trace B1–B16 to SVG and custom SF Symbols, harmonizing weight and padding (P2.5).
- Add only selected, cleared assets to the app and website; review the registry before release (P3.6).

No app, website, or release integration is claimed. `make check` and simulator flows are not available because this repository has no Makefile or app targets yet. Browser visual review was unavailable because local browser use is disabled in Work settings; opacity diagnostics and direct PNG inspection were used.
