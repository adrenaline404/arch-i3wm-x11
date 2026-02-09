#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/dashboard.rasi"
TITLE="Dashboard"

THEME_COLOR=$(grep 'LOCK_RING' $HOME/.config/i3/scripts/lock_colors.rc | cut -d'"' -f2 | cut -c1-7)
if [[ ! "$THEME_COLOR" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
    THEME_COLOR="#FFFFFF"
fi

FONT="font_family='JetBrainsMono Nerd Font Mono'"

safe_text() {
    echo "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g'
}

TIME_NOW=$(date "+%H:%M")
DATE_NOW=$(date "+%A, %d %B %Y")
TODAY=$(date +%-d)

W_RAW=$(curl -s --connect-timeout 2 "wttr.in/?format=%l\n%C\n%t\n%w&m")

if [ -z "$W_RAW" ] || [ $(echo "$W_RAW" | wc -l) -lt 4 ]; then
    W_LOC="Local System"
    W_COND="Offline"
    W_TEMP="--°C"
    W_WIND="No Data"
else
    mapfile -t W_DATA <<< "$W_RAW"
    W_LOC=$(safe_text "${W_DATA[0]}")
    W_COND=$(safe_text "${W_DATA[1]}")
    W_TEMP=$(safe_text "${W_DATA[2]}")
    W_WIND=$(safe_text "${W_DATA[3]}")
    
    W_LOC=${W_LOC:0:22}
fi

RAW_CAL=$(LC_ALL=C cal | sed '/^$/d')

CAL_DISPLAY=$(echo "$RAW_CAL" | sed -r "s/(^| )($TODAY)($| )/\1<span background='$THEME_COLOR' color='#000000' weight='bold'> \2 <\/span>\3/")

SECTION_TIME="<span weight='heavy' size='36pt' color='$THEME_COLOR'>$TIME_NOW</span>"

SECTION_DATE="<span size='11pt' color='#cccccc'>$DATE_NOW</span>"

SECTION_WEATHER="<span size='12pt' color='$THEME_COLOR'> $W_LOC</span>
<span size='10pt'>$W_COND ($W_TEMP)</span>
<span size='10pt' color='#888888'> $W_WIND</span>"

SECTION_CAL="<span weight='bold'>$CAL_DISPLAY</span>"

FINAL_TEXT="$SECTION_TIME\n$SECTION_DATE\n\n$SECTION_WEATHER\n\n$SECTION_CAL"

FINAL_TEXT="<span $FONT size='11pt'>$FINAL_TEXT</span>"

echo "" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$FINAL_TEXT" > /dev/null 2>&1