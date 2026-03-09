#!/bin/bash

CACHE_FILE="/tmp/weather_cache"
CACHE_TIMEOUT=900
CITY_FILE="$HOME/.config/i3/scripts/.weather_city"
CITY=""

if [ -f "$CITY_FILE" ]; then
    CITY=$(cat "$CITY_FILE")
fi

if [ -z "$CITY" ]; then
    echo "󰖐 Set Location"
    exit 0
fi

read_cache() {
    cat "$CACHE_FILE"
}

if [ -f "$CACHE_FILE" ]; then
    CACHE_AGE=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE")))
    if [ "$CACHE_AGE" -lt "$CACHE_TIMEOUT" ]; then
        read_cache
        exit 0
    fi
fi

WEATHER=$(curl -s --max-time 10 "https://wttr.in/${CITY}?format=%c+%t")

if [ $? -eq 0 ] && [[ ! "$WEATHER" == *"<"* ]] && [[ ! "$WEATHER" == *"Unknown"* ]]; then
    echo "$WEATHER" > "$CACHE_FILE"
    echo "$WEATHER"
else
    if [ -f "$CACHE_FILE" ]; then
        echo "$(read_cache) [!]"
    else
        echo "󰖐 Offline"
    fi
fi