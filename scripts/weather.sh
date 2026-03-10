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

WEATHER_RAW=$(curl -s --max-time 10 "https://wttr.in/${CITY}?format=%C|%t")

if [ $? -eq 0 ] && [[ ! "$WEATHER_RAW" == *"<"* ]] && [[ ! "$WEATHER_RAW" == *"Unknown"* ]]; then
    CONDITION=$(echo "$WEATHER_RAW" | awk -F '|' '{print $1}' | tr '[:upper:]' '[:lower:]' | xargs)
    TEMP=$(echo "$WEATHER_RAW" | awk -F '|' '{print $2}' | xargs)

    case "$CONDITION" in
        *"clear"*|*"sunny"*) ICON="󰖙" ;;
        *"partly cloudy"*) ICON="󰖕" ;;
        *"cloudy"*|*"overcast"*) ICON="󰖐" ;;
        *"drizzle"*|*"rain"*) ICON="󰖗" ;;
        *"thunderstorm"*|*"storm"*) ICON="󰖓" ;;
        *"snow"*|*"ice"*) ICON="󰖘" ;;
        *"fog"*|*"mist"*) ICON="󰖑" ;;
        *) ICON="󰖐" ;;
    esac

    WEATHER_FINAL="$ICON $TEMP"
    echo "$WEATHER_FINAL" > "$CACHE_FILE"
    echo "$WEATHER_FINAL"
else
    if [ -f "$CACHE_FILE" ]; then
        read_cache
    else
        echo "󰖐 Offline"
    fi
fi