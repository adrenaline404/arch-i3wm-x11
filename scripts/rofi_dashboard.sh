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

W_RAW=$(curl -s --max-time 3 "wttr.in/?format=%l|%C|%t|%w&m")

if [[ "$W_RAW" == *"|"* ]] && [[ "$W_RAW" != *"html"* ]]; then
    IFS='|' read -r LOC COND TEMP WIND <<< "$W_RAW"
    LOC=$(safe_text "$LOC")
    COND=$(safe_text "$COND")
    TEMP=$(safe_text "$TEMP")
    WIND=$(safe_text "$WIND")
    if [ ${#LOC} -gt 20 ]; then
        LOC="${LOC:0:18}.."
    fi
else
    LOC="System Offline"
    COND="No Connection"
    TEMP="--°C"
    WIND="--"
fi

RAW_CAL=$(LC_ALL=C cal | sed '/^$/d')
CAL_DISPLAY=$(echo "$RAW_CAL" | sed -r "s/(^| )($TODAY)($| )/\1<span background='$THEME_COLOR' color='#000000' weight='bold'> \2 <\/span>\3/")

printf -v SECTION_TIME "<span weight='heavy' size='36pt' color='%s'>%s</span>" "$THEME_COLOR" "$TIME_NOW"
printf -v SECTION_DATE "<span size='11pt' color='#cccccc'>%s</span>" "$DATE_NOW"
printf -v SECTION_WEATHER "<span size='12pt' color='%s'> %s</span>\n<span size='10pt'>%s (%s)</span>\n<span size='10pt' color='#888888'> %s</span>" "$THEME_COLOR" "$LOC" "$COND" "$TEMP" "$WIND"
printf -v SECTION_CAL "<span weight='bold'>%s</span>" "$CAL_DISPLAY"

FINAL_TEXT="$SECTION_TIME
$SECTION_DATE

$SECTION_WEATHER

$SECTION_CAL"

FINAL_TEXT="<span $FONT size='11pt'>$FINAL_TEXT</span>"

echo "" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$FINAL_TEXT" > /dev/null 2>&1