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

RAW_CAL=$(LC_ALL=C cal | sed '/^$/d')
mapfile -t CAL_LINES <<< "$RAW_CAL"

W_RAW=$(curl -s --connect-timeout 2 "wttr.in/?format=%l\n%C\n%t\n%w&m")

if [ -z "$W_RAW" ] || [ $(echo "$W_RAW" | wc -l) -lt 4 ]; then
    LOC="Local System"
    COND="Offline / Error"
    TEMP="--°C"
    WIND="No Data"
else
    mapfile -t W_DATA <<< "$W_RAW"
    LOC=$(safe_text "${W_DATA[0]}")
    COND=$(safe_text "${W_DATA[1]}")
    TEMP=$(safe_text "${W_DATA[2]}")
    WIND=$(safe_text "${W_DATA[3]}")
    
    LOC=${LOC:0:18}
fi

SP="   │   "

get_cal_line() {
    local line="${CAL_LINES[$1]}"
    if [ -z "$line" ]; then
        printf "%-22s" " "
    else
        printf "%-22s" "$line"
    fi
}

ROW1=$(printf "%s%s<span weight='heavy' size='22pt' color='%s'>%s</span>" "$(get_cal_line 0)" "$SP" "$THEME_COLOR" "$TIME_NOW")

ROW2=$(printf "%s%s<span color='#aaaaaa'>%s</span>" "$(get_cal_line 1)" "$SP" "$DATE_NOW")

ROW3=$(printf "%s%s<span color='%s'> </span> %s" "$(get_cal_line 2)" "$SP" "$THEME_COLOR" "$LOC")

ROW4=$(printf "%s%s<span color='%s'> </span> %s" "$(get_cal_line 3)" "$SP" "$THEME_COLOR" "$COND")

ROW5=$(printf "%s%s<span color='%s'> </span> %s" "$(get_cal_line 4)" "$SP" "$THEME_COLOR" "$TEMP")

ROW6=$(printf "%s%s<span color='%s'> </span> %s" "$(get_cal_line 5)" "$SP" "$THEME_COLOR" "$WIND")

ROW7=$(printf "%s%s" "$(get_cal_line 6)" "$SP")

ROW8=$(printf "%s%s" "$(get_cal_line 7)" "$SP")

FINAL_TEXT="$ROW1\n$ROW2\n\n$ROW3\n$ROW4\n$ROW5\n$ROW6\n$ROW7\n$ROW8"

FINAL_TEXT="<span $FONT size='11pt'>$FINAL_TEXT</span>"

FINAL_TEXT=$(echo "$FINAL_TEXT" | sed -r "s/(^| )($TODAY)($| )/\1<span background='$THEME_COLOR' color='#000000' weight='bold'> \2 <\/span>\3/")

echo "" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$FINAL_TEXT" > /dev/null 2>&1