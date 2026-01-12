#!/usr/bin/env bash
set -euo pipefail

THEME_STATE="$HOME/.config/.theme_state"
THEME="catppuccin"
if [[ -f "$THEME_STATE" ]]; then
    THEME=$(cat "$THEME_STATE" | tr -d '\n')
fi

killall -q picom polybar dunst 2>/dev/null || true

while pgrep -u "$UID" -x picom >/dev/null 2>&1; do
    sleep 0.1
done
while pgrep -u "$UID" -x polybar >/dev/null 2>&1; do
    sleep 0.1
done

WALLPAPER="$HOME/Pictures/${THEME}.jpg"
if [[ -f "$WALLPAPER" ]]; then
    if command -v feh >/dev/null 2>&1; then
        feh --bg-fill "$WALLPAPER" 2>/dev/null || true
    fi
fi

if command -v picom >/dev/null 2>&1; then
    picom --config ~/.config/picom/picom.conf --daemon 2>/dev/null || true
fi

if command -v polybar >/dev/null 2>&1; then
    ~/.config/polybar/launch.sh 2>/dev/null || true
fi

if command -v dunst >/dev/null 2>&1; then
    dunst 2>/dev/null || true
fi

if command -v nm-applet >/dev/null 2>&1; then
    nm-applet 2>/dev/null || true
fi

if command -v blueman-applet >/dev/null 2>&1; then
    blueman-applet 2>/dev/null || true
fi
