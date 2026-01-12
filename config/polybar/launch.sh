#!/usr/bin/env bash
set -euo pipefail

if ! command -v polybar >/dev/null 2>&1; then
    echo "Error: polybar is not installed" >&2
    exit 1
fi

THEME_STATE="$HOME/.config/.theme_state"
THEME="catppuccin"
if [[ -f "$THEME_STATE" ]]; then
    THEME=$(cat "$THEME_STATE" | tr -d '\n')
fi

killall -q polybar 2>/dev/null || true

while pgrep -u "$UID" -x polybar >/dev/null 2>&1; do
    sleep 0.1
done

THEME_FILE="$HOME/.config/polybar/themes/${THEME}.ini"
if [[ ! -f "$THEME_FILE" ]]; then
    echo "Warning: Theme file $THEME_FILE not found, using default" >&2
    THEME="catppuccin"
    THEME_FILE="$HOME/.config/polybar/themes/${THEME}.ini"
fi

CONFIG_FILE="$HOME/.config/polybar/config.ini"
if [[ -f "$CONFIG_FILE" ]] && [[ -f "$THEME_FILE" ]]; then
    TEMP_CONFIG=$(mktemp)
    {
        echo "include-file = $THEME_FILE"
        echo ""
        grep -v "^include-file" "$CONFIG_FILE" | grep -v "^;.*include-file"
    } > "$TEMP_CONFIG"
    
    polybar -q main -c "$TEMP_CONFIG" &
    (sleep 2 && rm -f "$TEMP_CONFIG") &
else
    polybar -q main -c "$CONFIG_FILE" &
fi
