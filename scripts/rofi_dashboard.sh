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

if command -v pamixer &> /dev/null; then
    VOL_INFO=$(pamixer --get-volume)
    IS_MUTED=$(pamixer --get-mute)
    [ "$IS_MUTED" = "true" ] && VOL_ICON="" || VOL_ICON=""
else
    VOL_INFO="N/A"
    VOL_ICON=""
fi

PLAYER_STATUS=$(playerctl status 2>/dev/null)

if [ "$PLAYER_STATUS" == "Playing" ]; then
    ICON_STATE=" Pause"
    ARTIST=$(playerctl metadata artist 2>/dev/null)
    TITLE_SONG=$(playerctl metadata title 2>/dev/null)
    
    [ -z "$ARTIST" ] && ARTIST="Unknown"
    [ -z "$TITLE_SONG" ] && TITLE_SONG="Playing..."
    
elif [ "$PLAYER_STATUS" == "Paused" ]; then
    ICON_STATE=" Play"
    ARTIST="Music"
    TITLE_SONG="Paused"
else
    ICON_STATE=" Play"
    ARTIST="No Media"
    TITLE_SONG="Idle"
fi

ARTIST=${ARTIST:0:20}
TITLE_SONG=${TITLE_SONG:0:30}

ARTIST=$(echo "$ARTIST" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
TITLE_SONG=$(echo "$TITLE_SONG" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

HEADER_TEXT="<span font_weight='bold' size='48pt' color='$THEME_COLOR'>$TIME</span>
<span font_weight='light' size='14pt' color='#ffffff'>$DATE</span>

<span font_family='Monospace' size='11pt'>$CALENDAR</span>

<span size='10pt' color='#888888'>Now Playing ($VOL_ICON $VOL_INFO%):</span>
<span font_weight='bold' size='12pt' color='$THEME_COLOR'>$TITLE_SONG</span>
<span font_weight='light' size='9pt' color='#cccccc'>$ARTIST</span>"

OPTIONS=" Prev\n$ICON_STATE\n Next\n Vol -\n Mute\n Vol +"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "$TITLE" -theme "$ROFI_THEME" -mesg "$HEADER_TEXT")

case "$CHOICE" in
    *Play) playerctl play ;;
    *Pause) playerctl pause ;;
    *Prev) playerctl previous ;;
    *Next) playerctl next ;;
    *Vol\ -) pamixer -d 5 ;;
    *Vol\ +) pamixer -i 5 ;;
    *Mute) pamixer -t ;;
esac