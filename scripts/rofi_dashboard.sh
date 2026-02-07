#!/bin/bash

ROFI_THEME="~/.config/rofi/dashboard.rasi"
TITLE="Dashboard"

TODAY=$(date +%-d)
CALENDAR=$(cal --color=always | sed -r "s/(^| )($TODAY)($| )/\1<b><u>\2<\/u><\/b>\3/")

TIME=$(date "+%H:%M")
DATE=$(date "+%A, %d %B %Y")

PLAYER_STATUS=$(playerctl status 2>/dev/null)

if [ "$PLAYER_STATUS" == "Playing" ]; then
    ICON_STATE=" Pause"
    SONG_INFO=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
    if [ -z "$SONG_INFO" ]; then SONG_INFO="Playing (No Info)"; fi
elif [ "$PLAYER_STATUS" == "Paused" ]; then
    ICON_STATE=" Play"
    SONG_INFO=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
    if [ -z "$SONG_INFO" ]; then SONG_INFO="Paused"; fi
else
    ICON_STATE=" Play"
    SONG_INFO="No Media Playing"
fi

SONG_INFO=${SONG_INFO:0:40}

HEADER_TEXT="<span size='xx-large' weight='bold'>$TIME</span>
<span size='medium'>$DATE</span>

<span font_family='JetBrainsMono Nerd Font'>$CALENDAR</span>

<span size='small' color='#888888'>Now Playing:</span>
<span weight='bold' color='@primary'>$SONG_INFO</span>"

OPTIONS="$ICON_STATE\n Previous\n Next"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$HEADER_TEXT")

case "$CHOICE" in
    *Play) playerctl play ;;
    *Pause) playerctl pause ;;
    *Previous) playerctl previous ;;
    *Next) playerctl next ;;
esac