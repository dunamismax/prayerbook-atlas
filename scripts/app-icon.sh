#!/bin/sh
# Copy the placeholder app icon into the asset catalog, or check that the copy
# still matches its design sources.
#
# The placeholder (BUILD.md P1.11) is the generated Ribbon icon in
# design/generated/: light (A1), dark (A2), and tinted (A3). Those files are
# design sources with status pending in design/image-registry.json; they are
# never edited, only copied. The final icon is P21.8.
#
# Usage: scripts/app-icon.sh          # copy the three PNGs into AppIcon.appiconset
#        scripts/app-icon.sh --check  # fail if a copy differs from its source (make check)

set -eu

cd "$(dirname "$0")/.."

source_dir="design/generated"
icon_set="App/Resources/Assets.xcassets/AppIcon.appiconset"
status=0

for appearance in light dark tinted; do
    source="$source_dir/icon-app-$appearance.png"
    copy="$icon_set/icon-$appearance.png"
    if [ "${1:-}" = "--check" ]; then
        if ! cmp -s "$source" "$copy"; then
            echo "error: $copy differs from $source; run make icon" >&2
            status=1
        fi
    else
        cp "$source" "$copy"
        echo "Copied $source"
    fi
done

if [ "${1:-}" = "--check" ] && [ "$status" -eq 0 ]; then
    echo "The app icon matches its design sources"
fi
exit "$status"
