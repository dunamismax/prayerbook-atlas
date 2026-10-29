#!/bin/sh
# Bring App/Resources/Localizable.xcstrings up to date with the interface strings the
# Swift compiler extracted in the last build (SWIFT_EMIT_LOC_STRINGS), using Xcode's
# xcstringstool. xcodebuild compiles the catalog but, unlike the Xcode editor, never
# writes new strings back into it, so `make strings` does.
#
# Usage: scripts/sync-strings.sh [--check] <derived-data-path>
#   --check  fail if the catalog is not up to date, without changing it (make check)

set -eu

check=0
if [ "${1:-}" = "--check" ]; then
    check=1
    shift
fi
derived="$1"
catalog="App/Resources/Localizable.xcstrings"
objects="$derived/Build/Intermediates.noindex/PrayerbookAtlas.build/Debug-iphonesimulator/App.build/Objects-normal"

set --
for file in "$objects"/*/*.stringsdata; do
    [ -e "$file" ] || continue
    case "$(basename "$file")" in
        ExtractedAppShortcutsMetadata.stringsdata) continue ;;
    esac
    # Skip leftovers from source files that no longer exist.
    source=$(sed -n 's/^  "source" : "\(.*\)",$/\1/p' "$file")
    [ -n "$source" ] && [ ! -e "$source" ] && continue
    set -- "$@" --stringsdata "$file"
done

if [ "$#" -eq 0 ]; then
    echo "error: no .stringsdata in $objects; build the app first (make build)" >&2
    exit 1
fi

if [ "$check" -eq 1 ]; then
    scratch=$(mktemp -d)
    trap 'rm -rf "$scratch"' EXIT
    cp "$catalog" "$scratch/Localizable.xcstrings"
    xcrun xcstringstool sync "$scratch/Localizable.xcstrings" "$@"
    if ! cmp -s "$catalog" "$scratch/Localizable.xcstrings"; then
        diff -u "$catalog" "$scratch/Localizable.xcstrings" | head -40 >&2 || true
        echo "error: $catalog is out of date; run make strings and commit it" >&2
        exit 1
    fi
    echo "$catalog is up to date"
else
    xcrun xcstringstool sync "$catalog" "$@"
    echo "Synced $catalog"
fi
