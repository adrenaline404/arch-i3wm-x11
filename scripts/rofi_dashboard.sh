#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/dashboard.rasi"

CURRENT_PALETTE=$(grep 'palette =' $HOME/.config/starship.toml | cut -d'"' -f2)

if [ "$CURRENT_PALETTE" == "void_blue" ]; then
    ACCENT="#2e9ef4"
else
    ACCENT="#FF5555"
fi

ICON_PLAY=""
ICON_PAUSE=""
ICON_PREV=""
ICON_NEXT=""

TIME_BIG=$(date "+%H:%M")
DATE_LONG=$(date "+%A, %d %B %Y")
DAY_NUM=$(date "+%-d")

CAL_HEAD=$(LC_ALL=C cal | head -n1)
CAL_BODY=$(LC_ALL=C cal | tail -n+2 | sed -r "s/(^| )($DAY_NUM)($| )/\1<span color='$ACCENT' weight='bold'>\2<\/span>\3/")

PLAYER_STATUS=$(playerctl status 2>/dev/null)

if [ "$PLAYER_STATUS" == "Playing" ]; then
    BTN_PLAY="$ICON_PAUSE"
else
    BTN_PLAY="$ICON_PLAY"
fi

SECTION_HEADER="<span font='JetBrainsMono Nerd Font ExtraBold 48' color='$ACCENT'>$TIME_BIG</span>
<span font='JetBrainsMono Nerd Font 12' color='#ffffff'>$DATE_LONG</span>"

SECTION_CALENDAR="<span font='JetBrainsMono Nerd Font 10' color='#cccccc'>$CAL_HEAD</span>
<span font='JetBrainsMono Nerd Font 10' color='#888888'>$CAL_BODY</span>"

SPACER1="<span size='20pt'>\n</span>"

SPACER2="<span size='10pt'> </span>"

FINAL_MESSAGE="$SECTION_HEADER
$SPACER2
$SECTION_CALENDAR
$SPACER1"

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