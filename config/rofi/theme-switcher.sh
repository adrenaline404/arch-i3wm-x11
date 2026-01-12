#!/usr/bin/env bash
set -euo pipefail

if ! command -v rofi >/dev/null 2>&1; then
    notify-send -u critical "Theme Switcher" "rofi is not installed"
    exit 1
fi

THEME_STATE="$HOME/.config/.theme_state"

CURRENT_THEME="catppuccin"
if [[ -f "$THEME_STATE" ]]; then
    CURRENT_THEME=$(cat "$THEME_STATE" | tr -d '\n')
fi

CHOICE=$(printf "󰨞 Black\n󰨞 Catppuccin\n󰨞 Nord" | rofi -dmenu -p "󰨞 Select Theme" -theme ~/.config/rofi/launcher.rasi -selected-row 0)

case "$CHOICE" in
    *Black)
        NEW_THEME="black"
        ;;
    *Catppuccin)
        NEW_THEME="catppuccin"
        ;;
    *Nord)
        NEW_THEME="nord"
        ;;
    *)
        exit 0
        ;;
esac

echo "$NEW_THEME" > "$THEME_STATE"

WALLPAPER="$HOME/Pictures/${NEW_THEME}.jpg"
if [[ -f "$WALLPAPER" ]] && command -v feh >/dev/null 2>&1; then
    feh --bg-fill "$WALLPAPER" 2>/dev/null || true
fi

if command -v polybar >/dev/null 2>&1; then
    killall -q polybar 2>/dev/null || true
    sleep 0.2
    ~/.config/polybar/launch.sh 2>/dev/null || true
fi

if command -v dunst >/dev/null 2>&1; then
    killall -q dunst 2>/dev/null || true
    sleep 0.2
    dunst 2>/dev/null || true
fi

if command -v i3-msg >/dev/null 2>&1; then
    i3-msg reload 2>/dev/null || true
fi

notify-send -t 2000 "Theme Switcher" "Theme changed to: $NEW_THEME" || true
