#!/bin/bash

CACHE_FILE="/tmp/weather_cache"
CACHE_TIMEOUT=900

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

WEATHER=$(curl -s --max-time 5 "https://wttr.in/?format=%c+%t")

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