#!/bin/bash
SETUP_FLAG="$HOME/.config/i3/.setup_done"

if [ -f "$SETUP_FLAG" ]; then exit 0; fi

sleep 3
notify-send -u critical -t 10000 "Welcome to Arch-i3WM" "Inisialisasi awal sistem..."

BROWSER=$(echo -e "firefox\nbrave\nchromium" | rofi -dmenu -p "Pilih Browser Default Anda:" -theme ~/.config/rofi/config.rasi)

if [ -n "$BROWSER" ]; then
    xdg-settings set default-web-browser "${BROWSER}.desktop"
    notify-send "Setup Selesai" "Browser default diset ke $BROWSER."
fi

touch "$SETUP_FLAG"