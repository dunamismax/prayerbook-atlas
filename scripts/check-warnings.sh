#!/bin/sh
# Fail if an xcodebuild result bundle recorded any warning or error.
#
# xcodebuild prints warnings only for files it recompiles, so `make build`
# and `make test-app` write a fresh result bundle and check it here.
#
# Usage: scripts/check-warnings.sh path/to/Result.xcresult

set -eu

bundle="$1"
summary=$(xcrun xcresulttool get build-results --path "$bundle")
warnings=$(printf '%s\n' "$summary" | sed -n 's/^  "warningCount" : \([0-9]*\),*$/\1/p')
errors=$(printf '%s\n' "$summary" | sed -n 's/^  "errorCount" : \([0-9]*\),*$/\1/p')

if [ -z "$warnings" ] || [ -z "$errors" ]; then
    echo "error: could not read warning and error counts from $bundle" >&2
    exit 1
fi

if [ "$warnings" -ne 0 ] || [ "$errors" -ne 0 ]; then
    printf '%s\n' "$summary" | sed -n '/"warnings" : \[/,/^  \]/p'
    echo "error: $warnings warning(s) and $errors error(s) in $bundle" >&2
    exit 1
fi

echo "No warnings in $bundle"
