#!/bin/bash
I3_CONF="$HOME/.config/i3/config"
ROFI_THEME="$HOME/.config/rofi/config.rasi"

awk '/^##/ {desc=substr($0, 4); next} 
     /^bindsym/ {
         cmd=$0; 
         sub(/^bindsym[ \t]+/, "", cmd); 
         if(desc) { printf "%-40s | %s\n", desc, cmd; desc="" }
     }' "$I3_CONF" | \
column -t -s '|' | \
rofi -dmenu -i -p "Shortcuts" -theme "$ROFI_THEME" -width 60 -lines 15