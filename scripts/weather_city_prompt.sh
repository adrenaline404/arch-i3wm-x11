#!/bin/bash

CITY=$(rofi -dmenu -p "󰖐 Enter City:" -lines 0 -theme-str 'window {width: 350px;} listview {lines: 0;}')

if [ -z "$CITY" ]; then exit 0; fi

SAFE_CITY=$(echo "$CITY" | sed 's/[^a-zA-Z0-9 ,-]//g' | sed 's/ /+/g')
echo "$SAFE_CITY" > ~/.config/i3/scripts/.weather_city
rm -f /tmp/weather_cache

notify-send -u normal -t 4000 "⛅ Location Updated" "Location set to: $CITY"