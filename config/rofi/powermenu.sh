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

THEME_FILE="$HOME/.config/rofi/powermenu-${THEME}.rasi"
if [[ ! -f "$THEME_FILE" ]]; then
    THEME_FILE="$HOME/.config/rofi/powermenu.rasi"
fi

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "󰐥 Power" -theme "$THEME_FILE" -selected-row 0)

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
            CONF=$(printf "No\nYes" | rofi -dmenu -p "Confirm reboot?" -theme "$THEME_FILE" -selected-row 0)
            if [[ "$CONF" == "Yes" ]]; then
                systemctl reboot
            fi
        else
            notify-send -u critical "Power Menu" "systemctl not available"
        fi
        ;;
    *Shutdown)
        if command -v systemctl >/dev/null 2>&1; then
            CONF=$(printf "No\nYes" | rofi -dmenu -p "Confirm shutdown?" -theme "$THEME_FILE" -selected-row 0)
            if [[ "$CONF" == "Yes" ]]; then
                systemctl poweroff
            fi
        else
            notify-send -u critical "Power Menu" "systemctl not available"
        fi
        ;;
    *)
        exit 0
        ;;
esac
