#!/usr/bin/env bash
set -euo pipefail

if ! command -v rofi >/dev/null 2>&1; then
    notify-send -u critical "Power Menu" "rofi is not installed"
    exit 1
fi

THEME_STATE="$HOME/.config/.theme_state"
THEME="catppuccin"
if [[ -f "$THEME_STATE" ]]; then
    THEME=$(cat "$THEME_STATE" | tr -d '\n')
fi

OPTIONS="󰌾 Lock\n󰗽 Logout\n󰜉 Reboot\n󰐥 Shutdown"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "󰐥 Power" -theme ~/.config/rofi/powermenu.rasi -selected-row 0)

case "$CHOICE" in
    *Lock)
        if command -v xsecurelock >/dev/null 2>&1; then
            xsecurelock
        elif command -v i3lock >/dev/null 2>&1; then
            i3lock -c 000000
        else
            notify-send -u critical "Power Menu" "No lock screen available"
        fi
        ;;
    *Logout)
        i3-msg exit
        ;;
    *Reboot)
        if command -v systemctl >/dev/null 2>&1; then
            systemctl reboot
        else
            notify-send -u critical "Power Menu" "systemctl not available"
        fi
        ;;
    *Shutdown)
        if command -v systemctl >/dev/null 2>&1; then
            systemctl poweroff
        else
            notify-send -u critical "Power Menu" "systemctl not available"
        fi
        ;;
    *)
        exit 0
        ;;
esac
