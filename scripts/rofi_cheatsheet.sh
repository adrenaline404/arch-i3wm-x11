#!/bin/bash

I3_CONF="$HOME/.config/i3/config"
ROFI_THEME="$HOME/.config/rofi/config.rasi"

ACCENT=$(grep '^primary =' "$HOME/.config/i3/themes/current/colors.ini" | awk '{print $3}')
if [ -z "$ACCENT" ]; then ACCENT="#CBA6F7"; fi

OUTPUT=$(awk '/^##/ {desc=substr($0, 4); next} 
     /^[ \t]*bindsym/ {
         cmd=$0; 
         sub(/^[ \t]*bindsym[ \t]+/, "", cmd); 
         if(desc) { printf "%-40s | %s\n", desc, cmd; desc="" }
     }' "$I3_CONF" | column -t -s '|')

if [ -z "$OUTPUT" ]; then
    rofi -e "Format '## Description' not found!
Please ensure you write '## Description' directly above the 'bindsym' line in ~/.config/i3/config"
    exit 1
fi

HEADER="<span color='$ACCENT'><b>      SHORTCUT DESCRIPTION      </b></span> <span color='#6C7086'>|</span> <span color='$ACCENT'><b>     BUTTONS & EXECUTION COMMANDS     </b></span>"

OVERRIDES="window {width: 1000px;} listview {lines: 16;} element-text {font: \"JetBrainsMono Nerd Font 11\";}"

echo -e "$OUTPUT" | rofi -dmenu -i -p "Cheatsheet" -theme "$ROFI_THEME" -theme-str "$OVERRIDES" -mesg "$HEADER"