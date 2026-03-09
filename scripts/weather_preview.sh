#!/bin/bash

CITY_FILE="$HOME/.config/i3/scripts/.weather_city"
CITY=""

if [ -f "$CITY_FILE" ]; then
    CITY=$(cat "$CITY_FILE")
fi

if [ -z "$CITY" ]; then
    notify-send -u normal -t 5000 "⛅ Weather Info" "Location not set.\nPlease Right-Click the weather icon in Polybar to set your city."
    exit 0
fi

notify-send -t 2000 "Weather" "Fetching weather data for $CITY..."

INFO=$(curl -s --max-time 10 "https://wttr.in/${CITY}?format=Location:+%l\nCondition:+%C+%c\nTemp:+%t+(Feels+like+%f)\nWind:+%w\nHumidity:+%h\nMoon:+%m")

if [ $? -eq 0 ] && [[ ! "$INFO" == *"<"* ]] && [[ ! "$INFO" == *"Unknown"* ]]; then
    notify-send -u normal -t 8000 "⛅ Weather Forecast" "$INFO"
else
    notify-send -u normal -t 5000 "Weather Error" "Server wttr.in is busy. Please try again later."
fi