#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/dashboard.rasi"
TITLE="Dashboard"

THEME_COLOR=$(grep 'LOCK_RING' $HOME/.config/i3/scripts/lock_colors.rc | cut -d'"' -f2 | cut -c1-7)
if [[ -z "$THEME_COLOR" || "$THEME_COLOR" != \#* ]]; then 
    THEME_COLOR="#FFFFFF"
fi

TIME=$(date "+%H:%M")
DATE=$(date "+%A, %d %B %Y")

RAW_CAL=$(TERM=dumb cal | col -bx)
TODAY=$(date +%-d)
CALENDAR=$(echo "$RAW_CAL" | sed -r "s/(^| )($TODAY)($| )/\1<span weight='heavy' color='$THEME_COLOR'>\2<\/span>\3/")

W_RAW=$(curl -s --connect-timeout 2 "wttr.in/?format=%c%t|%C|%w|%h&m")

if [ -z "$W_RAW" ]; then
    W_MAIN="  Offline"
    W_DESC="No Internet Connection"
    W_EXTRA="Check Network"
else
    IFS='|' read -r W_MAIN W_DESC W_WIND W_HUMID <<< "$W_RAW"
    
    W_EXTRA=" $W_WIND  •   $W_HUMID"
fi

HEADER_TEXT="<span font_weight='bold' size='48pt' color='$THEME_COLOR'>$TIME</span>
<span font_weight='light' size='14pt' color='#ffffff'>$DATE</span>

<span font_family='Monospace' size='11pt'>$CALENDAR</span>

<span size='10pt' color='#888888'>Current Weather:</span>
<span font_weight='bold' size='16pt' color='$THEME_COLOR'>$W_MAIN</span>
<span font_weight='normal' size='11pt' color='#cccccc'>$W_DESC</span>
<span font_weight='light' size='9pt' color='#999999'>$W_EXTRA</span>"

OPTIONS=" Refresh\n Wifi\n Close"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$HEADER_TEXT")

case "$CHOICE" in
    *Refresh)
        ~/.config/i3/scripts/rofi_dashboard.sh &
        ;;
    *Wifi)
        nm-connection-editor &
        ;;
    *Close) 
        exit 0 
        ;;
esac