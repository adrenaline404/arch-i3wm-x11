#!/bin/bash

I3_CONF="$HOME/.config/i3/config"
ROFI_THEME="$HOME/.config/rofi/config.rasi"

ACCENT=$(grep '^primary =' "$HOME/.config/i3/themes/current/colors.ini" | awk '{print $3}')
if [ -z "$ACCENT" ]; then ACCENT="#CBA6F7"; fi

OUTPUT=$(awk '
    BEGIN { count=1 }
    /^##/ { desc=substr($0, 4); next } 
    /^[ \t]*bindsym/ {
        cmd=$0; 
        sub(/^[ \t]*bindsym[ \t]+/, "", cmd); 
        if(desc) { 
            printf "%02d. %s|%s\n", count, desc, cmd; 
            desc=""; 
            count++;
        }
    }' "$I3_CONF" | column -t -s '|' --output-separator '  │  ')

if [ -z "$OUTPUT" ]; then
    rofi -e "Format '## Description' not found!
Please ensure you write '## Description' directly above the 'bindsym' line in ~/.config/i3/config"
    exit 1
fi

HEADER="<span color='$ACCENT'><b>   I3WM SHORTCUT REFERENCE CARD </b></span>\n<span color='#898c95' font='JetBrainsMono Nerd Font 9'> Type a number, action name, or key (e.g., 'Return' or '05') to filter the list below.</span>"

OVERRIDES="window {width: 1200px;} listview {lines: 18; spacing: 4px;} element {padding: 6px 10px;} element-text {font: \"JetBrainsMono Nerd Font 10\";}"

echo -e "$OUTPUT" | rofi -dmenu -i -p "Search" \
    -theme "$ROFI_THEME" \
    -theme-str "$OVERRIDES" \
    -mesg "$HEADER"