#!/usr/bin/env bash
set -euo pipefail

notify() {
    local urgency=${2:-normal}
    notify-send -u "$urgency" "Brightness" "$1"
}

BACKLIGHT_CARD=""
if [ -d /sys/class/backlight ]; then
    for d in /sys/class/backlight/*; do
        [ -e "$d" ] || continue
        BACKLIGHT_CARD=$(basename "$d")
        break
    done
fi

set_brightness_via_sysfs() {
    local card=$1
    local new=$2
    local path="/sys/class/backlight/$card/brightness"
    if [ -w "$path" ]; then
        echo "$new" > "$path" 2>/dev/null || true
        return 0
    fi
    echo "$new" | sudo tee "$path" >/dev/null 2>&1 || return 1
}

usage() {
    echo "Usage: $0 {up|down}" >&2
    exit 1
}

case "${1:-}" in
    up)
        if command -v brightnessctl >/dev/null 2>&1; then
            if [ -n "$BACKLIGHT_CARD" ]; then
                brightnessctl -d "$BACKLIGHT_CARD" set +10% 2>/dev/null || brightnessctl set +10% 2>/dev/null || true
            else
                brightnessctl set +10% 2>/dev/null || true
            fi
            BRIGHTNESS=$(brightnessctl ${BACKLIGHT_CARD:+-d "$BACKLIGHT_CARD"} get 2>/dev/null || brightnessctl get 2>/dev/null || echo 0)
            MAX=$(brightnessctl ${BACKLIGHT_CARD:+-d "$BACKLIGHT_CARD"} max 2>/dev/null || brightnessctl max 2>/dev/null || echo 1)
            PERCENT=$((BRIGHTNESS * 100 / MAX))
            notify "󰃠 ${PERCENT}%" normal
            exit 0
        fi

        if command -v xbacklight >/dev/null 2>&1; then
            xbacklight -inc 10 >/dev/null 2>&1 || true
            PERCENT=$(xbacklight -get 2>/dev/null | awk '{printf("%d\n",$1+0.5)}')
            notify "󰃠 ${PERCENT}%" normal
            exit 0
        fi

        if [ -n "$BACKLIGHT_CARD" ] && [ -r "/sys/class/backlight/$BACKLIGHT_CARD/brightness" ]; then
            BR=$(cat "/sys/class/backlight/$BACKLIGHT_CARD/brightness")
            MAX=$(cat "/sys/class/backlight/$BACKLIGHT_CARD/max_brightness")
            NEW=$((BR + (MAX / 10)))
            [ "$NEW" -gt "$MAX" ] && NEW=$MAX
            set_brightness_via_sysfs "$BACKLIGHT_CARD" "$NEW"
            PERCENT=$((NEW * 100 / MAX))
            notify "󰃠 ${PERCENT}%" normal
            exit 0
        fi

        notify "No backlight control available" critical
        exit 1
        ;;
    down)
        if command -v brightnessctl >/dev/null 2>&1; then
            if [ -n "$BACKLIGHT_CARD" ]; then
                brightnessctl -d "$BACKLIGHT_CARD" set 10%- 2>/dev/null || brightnessctl set 10%- 2>/dev/null || true
            else
                brightnessctl set 10%- 2>/dev/null || true
            fi
            BRIGHTNESS=$(brightnessctl ${BACKLIGHT_CARD:+-d "$BACKLIGHT_CARD"} get 2>/dev/null || brightnessctl get 2>/dev/null || echo 0)
            MAX=$(brightnessctl ${BACKLIGHT_CARD:+-d "$BACKLIGHT_CARD"} max 2>/dev/null || brightnessctl max 2>/dev/null || echo 1)
            PERCENT=$((BRIGHTNESS * 100 / MAX))
            notify "󰃠 ${PERCENT}%" normal
            exit 0
        fi

        if command -v xbacklight >/dev/null 2>&1; then
            xbacklight -dec 10 >/dev/null 2>&1 || true
            PERCENT=$(xbacklight -get 2>/dev/null | awk '{printf("%d\n",$1+0.5)}')
            notify "󰃠 ${PERCENT}%" normal
            exit 0
        fi

        if [ -n "$BACKLIGHT_CARD" ] && [ -r "/sys/class/backlight/$BACKLIGHT_CARD/brightness" ]; then
            BR=$(cat "/sys/class/backlight/$BACKLIGHT_CARD/brightness")
            MAX=$(cat "/sys/class/backlight/$BACKLIGHT_CARD/max_brightness")
            NEW=$((BR - (MAX / 10)))
            [ "$NEW" -lt 0 ] && NEW=0
            set_brightness_via_sysfs "$BACKLIGHT_CARD" "$NEW"
            PERCENT=$((NEW * 100 / MAX))
            notify "󰃠 ${PERCENT}%" normal
            exit 0
        fi

        notify "No backlight control available" critical
        exit 1
        ;;
    *)
        usage
        ;;
esac

