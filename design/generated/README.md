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

Every file is at its requested size. The 15 landscape images are 1536×1024 and the portrait share frame is 1024×1536, as generated. The generator returned the 38 square images at 1254×1254 despite the prompts requesting 1024×1024, so on 2026-10-28 they were resized to 1024×1024 with ImageMagick (Lanczos filter). The native square files, which carry the generator's embedded C2PA Content Credentials, remain in commit 2232e7f; the registry keeps their hashes as `original_sha256` and records each export step. The exports drop that metadata, because a manifest bound to the native file would no longer match.

Every requested transparent image has a real alpha channel. The black symbols, empty states, ornaments, and 404 drawing have no opaque white paper fills, so they can be tinted with an alpha mask. Black line art may appear black against a black image-viewer background; the gallery shows it on a checkerboard and as ivory on soot. The night samples use CSS masking and do not change the PNGs.

The tinted icon (`icon-app-tinted.png`) has a rebuilt mask: the generated outline, traced at its 50% alpha edge, re-rendered at 8× and reduced to 1024×1024, in pure white. The faint haze around the book and the partial alpha inside the cross are gone; the outline matches the generated one to within 76 of 1,048,576 pixels. The gallery shows it on the night colour. The separate book and ribbon layers need final alignment verification in Icon Composer.

## Next uses

- Assemble A4 and A5 over the solid day/night background in Icon Composer (P21.8).
- Custom SF Symbols from B1–B16 wait on the owner (decision 20): agents do not trace, redraw, or restyle them. The app uses SF Symbols meanwhile.
- Add only selected, cleared assets to the app and website; review the registry before release (P3.6).

No app, website, or release integration is claimed. `make check` and simulator flows are not available because this repository has no Makefile or app targets yet. The gallery was checked in a browser over local HTTP on 2026-10-28: all 54 images load at their recorded sizes, and the 31 night samples render.
