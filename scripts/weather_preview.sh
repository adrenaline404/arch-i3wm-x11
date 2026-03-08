#!/bin/bash

notify-send -t 2000 "Weather" "Fetching detailed forecast..."

INFO=$(curl -s --max-time 5 "https://wttr.in/?format=Location:+%l\nCondition:+%C+%c\nTemp:+%t+(Feels+like+%f)\nWind:+%w\nHumidity:+%h\nMoon:+%m")

if [ $? -eq 0 ] && [[ ! "$INFO" == *"<"* ]]; then
    notify-send -u normal -t 8000 "⛅ Weather Forecast" "$INFO"
else
    notify-send -u critical "Weather Error" "Network timeout or server is down."
fi