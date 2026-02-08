#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/dashboard.rasi"
TITLE="Dashboard"

THEME_COLOR=$(grep 'LOCK_RING' $HOME/.config/i3/scripts/lock_colors.rc | cut -d'"' -f2 | cut -c1-7)
[ -z "$THEME_COLOR" ] && THEME_COLOR="#FFFFFF"

RAW_CAL=$(cal | sed 's/..$//')
TODAY=$(date +%-d)

mapfile -t CAL_ARRAY <<< "$(cal)"

TIME_BIG=$(date "+%H:%M")
DATE_FULL=$(date "+%A")
DATE_NUM=$(date "+%d %B %Y")

W_RAW=$(curl -s --connect-timeout 2 "wttr.in/?format=%c%t|%C|%w|%h&m")
if [ -z "$W_RAW" ]; then
    W_L1="  Offline"
    W_L2="No Internet"
    W_L3="Check Conn."
    W_L4=""
else
    IFS='|' read -r W_TEMP W_COND W_WIND W_HUMID <<< "$W_RAW"
    W_L1="${W_TEMP}"
    W_L2="${W_COND}"
    W_L3=" ${W_WIND}"
    W_L4=" ${W_HUMID}"
fi

UPTIME=$(uptime -p | sed 's/up //;s/ hours/h/;s/ minutes/m/')
KERNEL=$(uname -r | cut -d'-' -f1)

SEP="<span color='#444444'> │ </span>"

print_row() {
    printf "%-22s%b%-28s%b%-22s\n" "$1" "$SEP" "$2" "$SEP" "$3"
}

center_text() {
    local text="$1"
    local width=28
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%${padding}s%s%${padding}s" "" "$text" ""
}

L1=$(print_row "${CAL_ARRAY[0]}" "$(center_text "$TIME_BIG")" "$W_L1")

L2=$(print_row "${CAL_ARRAY[2]}" "$(center_text "$DATE_FULL")" "$W_L2")

L3=$(print_row "${CAL_ARRAY[3]}" "$(center_text "$DATE_NUM")" "$W_L3")

L4=$(print_row "${CAL_ARRAY[4]}" "" "$W_L4")

L5=$(print_row "${CAL_ARRAY[5]}" "$(center_text "Uptime:")" " $UPTIME")

L6=$(print_row "${CAL_ARRAY[6]}" "$(center_text "$UPTIME")" " $KERNEL")

[ ! -z "${CAL_ARRAY[7]}" ] && L7=$(print_row "${CAL_ARRAY[7]}" "" "")

FINAL_TEXT="$L1\n$L2\n$L3\n$L4\n$L5\n$L6\n$L7"

FINAL_TEXT=$(echo "$FINAL_TEXT" | sed "s/$TIME_BIG/<span weight='heavy' size='xx-large' color='$THEME_COLOR'>$TIME_BIG<\/span>/")

FINAL_TEXT=$(echo "$FINAL_TEXT" | sed -r "s/(^| )($TODAY)($| )/\1<span weight='heavy' background='$THEME_COLOR' color='#000000'> \2 <\/span>\3/")

FINAL_TEXT="${FINAL_TEXT//${W_TEMP}/<span weight='bold' color='$THEME_COLOR'>${W_TEMP}</span>}"

OPTIONS=" Refresh\n Wifi\n Close"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$FINAL_TEXT")

case "$CHOICE" in
    *Refresh) ~/.config/i3/scripts/rofi_dashboard.sh & ;;
    *Wifi) nm-connection-editor & ;;
    *Close) exit 0 ;;
esac