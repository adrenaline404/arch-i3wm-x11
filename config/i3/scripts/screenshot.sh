#!/usr/bin/env bash
set -euo pipefail

if ! command -v maim >/dev/null 2>&1; then
    notify-send -u critical "Screenshot" "maim is not installed"
    exit 1
fi

if ! command -v xclip >/dev/null 2>&1; then
    notify-send -u critical "Screenshot" "xclip is not installed"
    exit 1
fi

if maim -s | xclip -selection clipboard -t image/png 2>/dev/null; then
    notify-send -t 2000 "󰄀 Screenshot" "Selection copied to clipboard" || true
else
    notify-send -u critical "Screenshot" "Failed to take screenshot"
    exit 1
fi
