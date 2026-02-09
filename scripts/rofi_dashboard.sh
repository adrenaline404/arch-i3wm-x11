#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/dashboard.rasi"
CACHE_WEATHER="/tmp/dashboard_weather.txt"
CACHE_MUSIC="/tmp/dashboard_music.txt"

THEME_COLOR=$(grep 'LOCK_RING' $HOME/.config/i3/scripts/lock_colors.rc | cut -d'"' -f2 | cut -c1-7)
if [[ ! "$THEME_COLOR" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
    THEME_COLOR="#FF5555"
fi

ICON_PLAY=""
ICON_PAUSE=""
ICON_PREV=""
ICON_NEXT=""
ICON_MUSIC=""

safe_text() {
    echo "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g'
}

TIME_BIG=$(date "+%H:%M")
DATE_LONG=$(date "+%A, %d %B %Y")
DAY_NUM=$(date "+%-d")

if [ ! -f "$CACHE_WEATHER" ] || [ $(find "$CACHE_WEATHER" -mmin +30) ]; then
    curl -s --max-time 3 "wttr.in/?format=%l|%C|%t|%w&m" > "$CACHE_WEATHER" || echo "Offline|NA|--|--" > "$CACHE_WEATHER"
fi

IFS='|' read -r W_LOC W_COND W_TEMP W_WIND < "$CACHE_WEATHER"
if [[ "$W_LOC" == *"html"* ]]; then
    W_LOC="Offline"; W_COND="No Data"; W_TEMP="--"; W_WIND="--"
fi
W_LOC=${W_LOC:0:15}

CAL_HEAD=$(LC_ALL=C cal | head -n1)
CAL_BODY=$(LC_ALL=C cal | tail -n+2 | sed -r "s/(^| )($DAY_NUM)($| )/\1<span color='$THEME_COLOR' weight='bold'>\2<\/span>\3/")

PLAYER_STATUS=$(playerctl status 2>/dev/null)
if [ "$?" -eq 0 ] && [ "$PLAYER_STATUS" != "Stopped" ]; then
    ARTIST=$(playerctl metadata artist 2>/dev/null | sed 's/&/and/g')
    TITLE=$(playerctl metadata title 2>/dev/null | sed 's/&/and/g')
    
    if [ ${#TITLE} -gt 25 ]; then TITLE="${TITLE:0:23}.."; fi
    if [ ${#ARTIST} -gt 25 ]; then ARTIST="${ARTIST:0:23}.."; fi
    
    MUSIC_INFO="$ICON_MUSIC  $TITLE\n<span size='small' color='#888888'>$ARTIST</span>"
    
    if [ "$PLAYER_STATUS" == "Playing" ]; then
        BTN_PLAY="$ICON_PAUSE"
    else
        BTN_PLAY="$ICON_PLAY"
    fi
else
    MUSIC_INFO="No Media Playing"
    BTN_PLAY="$ICON_PLAY"
fi

SECTION_HEADER="<span font='JetBrainsMono Nerd Font ExtraBold 42' color='$THEME_COLOR'>$TIME_BIG</span>
<span font='JetBrainsMono Nerd Font 12' color='#ffffff'>$DATE_LONG</span>"

SECTION_MIDDLE="
<span font='JetBrainsMono Nerd Font 10' color='#cccccc'>$CAL_HEAD</span>
<span font='JetBrainsMono Nerd Font 10' color='#888888'>$CAL_BODY</span>

<span font='JetBrainsMono Nerd Font 10' color='$THEME_COLOR'>  $W_LOC</span>
<span font='JetBrainsMono Nerd Font 9'>$W_TEMP ($W_COND)</span>"

SECTION_MUSIC="<span font='JetBrainsMono Nerd Font 11' weight='bold'>$MUSIC_INFO</span>"

FINAL_MESSAGE="$SECTION_HEADER
$SECTION_MIDDLE
________________________________
$SECTION_MUSIC"

OPT_PREV="$ICON_PREV"
OPT_TOGGLE="$BTN_PLAY"
OPT_NEXT="$ICON_NEXT"

CHOSEN=$(echo -e "$OPT_PREV\n$OPT_TOGGLE\n$OPT_NEXT" | rofi -dmenu \
    -p "Dashboard" \
    -theme "$ROFI_THEME" \
    -mesg "$FINAL_MESSAGE" \
    -selected-row 1)

case "$CHOSEN" in
    "$ICON_PREV")
        playerctl previous
        exec "$0"
        ;;
    "$ICON_PLAY")
        playerctl play
        exec "$0"
        ;;
    "$ICON_PAUSE")
        playerctl pause
        exec "$0"
        ;;
    "$ICON_NEXT")
        playerctl next
        exec "$0"
        ;;
esac