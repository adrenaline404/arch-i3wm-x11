#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/dashboard.rasi"
TITLE="Dashboard"

THEME_COLOR=$(grep 'LOCK_RING' $HOME/.config/i3/scripts/lock_colors.rc | cut -d'"' -f2 | cut -c1-7)
[ -z "$THEME_COLOR" ] && THEME_COLOR="#FFFFFF"

FONT_MONO="font_family='Monospace'"

TIME_BIG=$(date "+%H:%M")
DATE_DAY=$(date "+%A")
DATE_FULL=$(date "+%d %B %Y")

TODAY=$(date +%-d)
RAW_CAL=$(LC_ALL=C cal)
mapfile -t CAL_LINES <<< "$RAW_CAL"

W_RAW=$(curl -s --connect-timeout 2 "wttr.in/?format=%c%t|%C|%w&m")

if [ -z "$W_RAW" ]; then
    W_L1=" Offline"
    W_L2="No Data"
    W_L3="Check Wifi"
else
    IFS='|' read -r W_L1 W_L2 W_L3 <<< "$W_RAW"
    W_L1=${W_L1:0:15}
    W_L2=${W_L2:0:15}
    W_L3=" ${W_L3:0:12}"
fi

UPTIME=$(uptime -p | sed 's/up //;s/ hours/h/;s/ minutes/m/')
UPTIME=${UPTIME:0:15}

make_row() {
    local left="$1"
    local center="$2"
    local right="$3"
    
    printf "%-22s │ %-30s │ %-20s\n" "$left" "$center" "$right"
}

center_t() {
    local text="$1"
    local width=30
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%${padding}s%s" "" "$text"
}

L1=$(make_row "${CAL_LINES[0]}" "$(center_t "$TIME_BIG")" " $W_L1")

L2=$(make_row "${CAL_LINES[2]}" "$(center_t "$DATE_DAY")" " $W_L2")

L3=$(make_row "${CAL_LINES[3]}" "$(center_t "$DATE_FULL")" " $W_L3")

L4=$(make_row "${CAL_LINES[4]}" "" "")
L5=$(make_row "${CAL_LINES[5]}" "$(center_t "Uptime:")" "")
L6=$(make_row "${CAL_LINES[6]}" "$(center_t "$UPTIME")" "")

FINAL_STR="$L1\n$L2\n$L3\n$L4\n$L5\n$L6"

FINAL_STR="<span $FONT_MONO size='11pt'>$FINAL_STR</span>"

FINAL_STR=$(echo "$FINAL_STR" | sed "s/$TIME_BIG/<span weight='heavy' size='28pt' color='$THEME_COLOR'>$TIME_BIG<\/span>/")

FINAL_STR=$(echo "$FINAL_STR" | sed -r "s/(^| )($TODAY)($| )/\1<span background='$THEME_COLOR' color='#000000' weight='bold'> \2 <\/span>\3/")

FINAL_STR="${FINAL_STR//$W_L1/<span color='$THEME_COLOR' weight='bold'>$W_L1</span>}"

OPTIONS=" Refresh\n Wifi\n Close"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$FINAL_STR")

case "$CHOICE" in
    *Refresh) ~/.config/i3/scripts/rofi_dashboard.sh & ;;
    *Wifi) nm-connection-editor & ;;
    *Close) exit 0 ;;
esac