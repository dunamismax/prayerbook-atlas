#!/bin/sh
# Print the UDID of the simulator to build, test, and run on.
#
# By default it picks the newest available iPhone: the first iPhone listed
# under the newest iOS runtime. Set SIM_DEVICE to a device name (for example
# "iPhone 17 Pro"; the newest runtime that has it wins) or to a UDID to
# override the choice.
#
# Usage: scripts/sim-destination.sh                # prints the UDID
#        scripts/sim-destination.sh --destination  # prints an xcodebuild -destination value

set -eu

devices=$(xcrun simctl list devices available)

udid=$(printf '%s\n' "$devices" | awk -v want="${SIM_DEVICE:-}" '
    BEGIN { best = -1; key = -1 }
    /^-- iOS [0-9.]+ --$/ {
        split($3, v, ".")
        key = v[1] * 1000 + v[2]
        next
    }
    /^-- / { key = -1; next }
    key >= 0 && match($0, /\([0-9A-F-]{36}\)/) {
        id = substr($0, RSTART + 1, RLENGTH - 2)
        name = substr($0, 1, RSTART - 2)
        sub(/^[ \t]+/, "", name)
        if (want != "") {
            ok = (want == id || want == name)
        } else {
            ok = (name ~ /^iPhone/)
        }
        if (ok && key > best) { best = key; found = id }
    }
    END { if (found != "") print found }
')

if [ -z "$udid" ]; then
    if [ -n "${SIM_DEVICE:-}" ]; then
        echo "error: no available iOS simulator named or with UDID \"$SIM_DEVICE\"" >&2
    else
        echo "error: no available iPhone simulator; install an iOS runtime in Xcode" >&2
    fi
    exit 1
fi

if [ "${1:-}" = "--destination" ]; then
    echo "platform=iOS Simulator,id=$udid"
else
    echo "$udid"
fi
