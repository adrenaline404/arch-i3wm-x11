#!/usr/bin/env bash
set -euo pipefail

if ! command -v brightnessctl >/dev/null 2>&1; then
    notify-send -u critical "Brightness Control" "brightnessctl is not installed"
    exit 1
fi

if ! brightnessctl info >/dev/null 2>&1; then
    notify-send -u critical "Brightness Control" "No backlight device found"
    exit 1
fi

case "${1:-}" in
    up)
        brightnessctl set +10% 2>/dev/null || true
        BRIGHTNESS=$(brightnessctl get)
        MAX=$(brightnessctl max)
        PERCENT=$((BRIGHTNESS * 100 / MAX))
        notify-send -t 1000 -h string:x-canonical-private-synchronous:brightness "󰃠 Brightness" "${PERCENT}%" || true
        ;;
    down)
        brightnessctl set 10%- 2>/dev/null || true
        BRIGHTNESS=$(brightnessctl get)
        MAX=$(brightnessctl max)
        PERCENT=$((BRIGHTNESS * 100 / MAX))
        notify-send -t 1000 -h string:x-canonical-private-synchronous:brightness "󰃠 Brightness" "${PERCENT}%" || true
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac
