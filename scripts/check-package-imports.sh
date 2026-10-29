#!/bin/sh
# Fail if a package under Packages/ or Tools/ imports a module outside the allowlist.
#
# Packages must build on Linux for the future server, web app, and any
# Android port (AGENTS.md §5; docs/decisions.md entry 5), so they may import only Foundation and the toolchain modules that ship
# on Linux, plus the local packages themselves. `make test-linux` then proves
# that the Foundation APIs they use exist there. To allow another module, add
# it here with a decision-log entry explaining why it is available on Linux.
#
# SQLite3 is the one exception, for the content database (decision entry 4):
# Apple platforms ship it as a module and Linux does not, so every
# `import SQLite3` must sit directly under `#if canImport(SQLite3)`. How the
# Linux side reads the database is decided, and logged, when P3.7 writes the
# reader.

set -eu

cd "$(dirname "$0")/.."

# Tools/ arrives with the content compiler (P3.3).
roots=$(for d in Packages Tools; do if [ -d "$d" ]; then echo "$d"; fi; done)

allowed="Foundation FoundationEssentials FoundationInternationalization Dispatch Synchronization SQLite3"
allowed_in_tests="Testing"
# Every local package's modules may import one another.
local_modules=$(find $roots -path '*/Sources/*' -type d -mindepth 3 -maxdepth 3 -exec basename {} \; | sort -u | tr '\n' ' ')

status=0
for file in $(find $roots -name '*.swift' -not -path '*/.build/*' -not -name Package.swift | sort); do
    if grep -q '^[[:space:]]*import SQLite3' "$file" \
        && ! awk '/canImport\(SQLite3\)/ { guarded = 1 } /^[[:space:]]*import SQLite3/ { if (!guarded) exit 1 }' "$file"; then
        echo "error: $file imports SQLite3 outside #if canImport(SQLite3)" >&2
        status=1
    fi
    case "$file" in
        */Tests/*) extra="$allowed_in_tests" ;;
        *) extra="" ;;
    esac
    # Matches `import X`, `@testable import X`, `import struct X.Y`, and the like.
    modules=$(sed -n -E 's/^[[:space:]]*(@[A-Za-z_]+[[:space:]]+)*import[[:space:]]+((typealias|struct|class|enum|protocol|let|var|func)[[:space:]]+)?([A-Za-z_][A-Za-z0-9_]*).*/\4/p' "$file")
    for module in $modules; do
        case " $allowed $extra $local_modules " in
            *" $module "*) ;;
            *)
                echo "error: $file imports $module, which is not allowed in a package (see scripts/check-package-imports.sh)" >&2
                status=1
                ;;
        esac
    done
done

if [ "$status" -eq 0 ]; then
    echo "Package imports are Linux-safe"
fi
exit "$status"
