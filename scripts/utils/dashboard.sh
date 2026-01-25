#!/bin/bash

exec 1>>/tmp/dashboard.log 2>&1

killall rofi || true

TIME=$(date "+%H:%M")
DATE=$(date "+%A, %d %B %Y")
WEATHER=$(curl -s --max-time 2 "wttr.in/?format=%C+%t")
[ -z "$WEATHER" ] && WEATHER="Offline"

if playerctl status 2>/dev/null | grep -q "Playing"; then
    SONG=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
    MUSIC="🎵  $SONG"
else
    MUSIC="⏸️  No Music Playing"
fi

echo -e "$MUSIC\nOpen Notifications\nClose" | rofi -dmenu \
    -p "$TIME" \
    -mesg "$DATE  |  $WEATHER" \
    -theme ~/.config/rofi/config.rasi \
    -lines 4 \
    -location 2 \
    -yoffset 60 \
    -width 30