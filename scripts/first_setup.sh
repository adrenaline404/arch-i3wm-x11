#!/bin/bash
SETUP_FLAG="$HOME/.config/i3/.setup_done"

if [ -f "$SETUP_FLAG" ]; then exit 0; fi

sleep 3
notify-send -u critical -t 10000 "Welcome :)" "Preparing your i3 environment for the first time. Please select your default web browser."

BROWSER=$(echo -e "firefox\nbrave\nchromium" | rofi -dmenu -p "Select Browser:" -theme ~/.config/rofi/config.rasi)

if [ -n "$BROWSER" ]; then
    xdg-settings set default-web-browser "${BROWSER}.desktop"
    notify-send "Setup Complete" "Default browser set to $BROWSER."
fi

touch "$SETUP_FLAG"