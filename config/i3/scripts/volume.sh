#!/usr/bin/env bash
set -euo pipefail

if ! command -v pamixer >/dev/null 2>&1; then
    notify-send -u critical "Volume Control" "pamixer is not installed"
    exit 1
fi

case "${1:-}" in
    up)
        pamixer -i 5 --allow-boost 2>/dev/null || true
        VOLUME=$(pamixer --get-volume-human)
        notify-send -t 1000 -h string:x-canonical-private-synchronous:volume "󰕾 Volume" "$VOLUME" || true
        ;;
    down)
        pamixer -d 5 2>/dev/null || true
        VOLUME=$(pamixer --get-volume-human)
        notify-send -t 1000 -h string:x-canonical-private-synchronous:volume "󰕾 Volume" "$VOLUME" || true
        ;;
    mute)
        pamixer -t 2>/dev/null || true
        if pamixer --get-mute | grep -q "true"; then
            notify-send -t 1000 -h string:x-canonical-private-synchronous:volume "󰝟 Volume" "Muted" || true
        else
            VOLUME=$(pamixer --get-volume-human)
            notify-send -t 1000 -h string:x-canonical-private-synchronous:volume "󰕾 Volume" "$VOLUME" || true
        fi
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac
