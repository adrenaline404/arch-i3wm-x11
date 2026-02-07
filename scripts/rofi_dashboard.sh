#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/dashboard.rasi"
TITLE="Dashboard"

THEME_COLOR=$(grep 'LOCK_RING' $HOME/.config/i3/scripts/lock_colors.rc | cut -d'"' -f2 | cut -c1-7)

if [ -z "$THEME_COLOR" ]; then THEME_COLOR="#FFFFFF"; fi

TODAY=$(date +%-d)
CALENDAR=$(cal --color=always | sed -r "s/(^| )($TODAY)($| )/\1<span weight='bold' color='$THEME_COLOR'>\2<\/span>\3/")

TIME=$(date "+%H:%M")
DATE=$(date "+%A, %d %B %Y")

PLAYER_STATUS=$(playerctl status 2>/dev/null)
if [ "$PLAYER_STATUS" == "Playing" ]; then
    ICON_STATE=" Pause"
    SONG_INFO=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
    if [ -z "$SONG_INFO" ]; then SONG_INFO="Playing..."; fi
elif [ "$PLAYER_STATUS" == "Paused" ]; then
    ICON_STATE=" Play"
    SONG_INFO=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
    if [ -z "$SONG_INFO" ]; then SONG_INFO="Paused"; fi
else
    ICON_STATE=" Play"
    SONG_INFO="No Media"
fi
SONG_INFO=${SONG_INFO:0:35}

HEADER_TEXT="<span size='45000' weight='bold' color='$THEME_COLOR'>$TIME</span>
<span size='large'>$DATE</span>

<span font_family='JetBrainsMono Nerd Font'>$CALENDAR</span>

<span size='small' color='#888888'>Now Playing:</span>
<span weight='bold' color='$THEME_COLOR'>$SONG_INFO</span>"

OPTIONS="$ICON_STATE\n Previous\n Next"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$HEADER_TEXT")

case "$CHOICE" in
    *Play) playerctl play ;;
    *Pause) playerctl pause ;;
    *Previous) playerctl previous ;;
    *Next) playerctl next ;;
esac