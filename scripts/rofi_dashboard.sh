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
RAW_CAL=$(LC_ALL=C cal)
mapfile -t CAL_LINES <<< "$RAW_CAL"

W_RAW=$(curl -s --connect-timeout 3 "wttr.in/?format=%l\n%C\n%t\n%w&m")

if [ -z "$W_RAW" ] || [ $? -ne 0 ]; then
    LOC="System Local"
    COND="Offline"
    TEMP="--°C"
    WIND="No Data"
else
    mapfile -t W_DATA <<< "$W_RAW"
    LOC=$(safe_text "${W_DATA[0]}")
    COND=$(safe_text "${W_DATA[1]}")
    TEMP=$(safe_text "${W_DATA[2]}")
    WIND=$(safe_text "${W_DATA[3]}")
    
    LOC=${LOC:0:20}
fi

SP="   │   " 

L1=$(printf "%-22s%s<span weight='heavy' size='24pt' color='%s'>%s</span>" "${CAL_LINES[0]}" "$SP" "$THEME_COLOR" "$TIME_NOW")

L2=$(printf "%-22s%s<span color='#aaaaaa'>%s</span>" "" "$SP" "$DATE_NOW")

L3=$(printf "%-22s%s<span color='%s'> </span> %s" "${CAL_LINES[2]}" "$SP" "$THEME_COLOR" "$LOC")

L4=$(printf "%-22s%s<span color='%s'> </span> %s" "${CAL_LINES[3]}" "$SP" "$THEME_COLOR" "$COND")

L5=$(printf "%-22s%s<span color='%s'> </span> %s" "${CAL_LINES[4]}" "$SP" "$THEME_COLOR" "$TEMP")

L6=$(printf "%-22s%s<span color='%s'> </span> %s" "${CAL_LINES[5]}" "$SP" "$THEME_COLOR" "$WIND")

L7=$(printf "%-22s%s" "${CAL_LINES[6]}" "$SP")

FINAL_TEXT="$L1\n$L2\n\n$L3\n$L4\n$L5\n$L6\n$L7"

FINAL_TEXT="<span $FONT size='12pt'>$FINAL_TEXT</span>"

FINAL_TEXT=$(echo "$FINAL_TEXT" | sed -r "s/(^| )($TODAY)($| )/\1<span background='$THEME_COLOR' color='#000000' weight='bold'> \2 <\/span>\3/")

echo "" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$FINAL_TEXT" > /dev/null 2>&1