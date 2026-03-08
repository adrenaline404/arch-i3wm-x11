#!/bin/bash
SETUP_FLAG="$HOME/.config/i3/.setup_done"

if [ -f "$SETUP_FLAG" ]; then exit 0; fi

sleep 3

rm -rf ~/.cache/fastfetch
notify-send -u normal -t 3000 "System Setup" "Clearing old caches & preparing environment..."

sleep 1

notify-send -u critical -t 10000 "Welcome to Pro Dark :)" "Please select your default web browser to complete the setup."

BROWSER=$(echo -e "firefox\nbrave\nchromium" | rofi -dmenu -p "Browser" -theme ~/.config/rofi/config.rasi)

if [ -n "$BROWSER" ]; then
    xdg-settings set default-web-browser "${BROWSER}.desktop"
    notify-send "Setup Complete" "Default browser set to $BROWSER. Enjoy your new workspace!"
fi

touch "$SETUP_FLAG"