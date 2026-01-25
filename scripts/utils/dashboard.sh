#!/bin/bash

TIME=$(date "+%H:%M")
DATE=$(date "+%A, %d %B %Y")

WEATHER=$(curl -s --max-time 2 "wttr.in/?format=%C+%t")
if [ -z "$WEATHER" ]; then WEATHER="Offline"; fi

if playerctl status 2>/dev/null | grep -q "Playing"; then
    ARTIST=$(playerctl metadata artist 2>/dev/null)
    TITLE=$(playerctl metadata title 2>/dev/null)
    TITLE=$(echo "$TITLE" | cut -c 1-30)
    MUSIC="🎵 $ARTIST - $TITLE"
else
    MUSIC="⏸️ No Music Playing"
fi

rofi_cmd() {
    rofi -dmenu \
        -p "$TIME" \
        -mesg "  $DATE   |     $WEATHER" \
        -theme ~/.config/rofi/config.rasi \
        -lines 3 \
        -location 2 \
        -yoffset 40
}

OPTIONS="$MUSIC\n  Open Notifications\n  Close Menu"

CHOSEN=$(echo -e "$OPTIONS" | rofi_cmd)

case "$CHOSEN" in
    *"🎵"*) playerctl play-pause ;;
    *"⏸️"*) playerctl play-pause ;;
    *"Notifications"*) dunstctl history-pop ;;
    *) exit 0 ;;
esac