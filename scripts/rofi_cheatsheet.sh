#!/bin/bash

I3_CONF="$HOME/.config/i3/config"
ROFI_THEME="$HOME/.config/rofi/config.rasi"

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

echo -e "$OUTPUT" | rofi -dmenu -i -p "Shortcuts" -theme "$ROFI_THEME"