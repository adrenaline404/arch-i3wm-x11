#!/bin/bash
# USAGE: ./theme_switcher.sh [void-red|void-blue]

THEME=$1
THEME_ROOT="$HOME/.config/i3/themes"
LINK_TARGET="$THEME_ROOT/current"
DUNST_CONFIG="$HOME/.config/dunst/dunstrc"

# GUI Select
if [ -z "$THEME" ] || [ "$THEME" == "gui" ]; then
    OPTIONS="Void Red\nVoid Blue"
    CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Theme" -theme ~/.config/rofi/config.rasi)
    case "$CHOICE" in
        "Void Red") THEME="void-red" ;;
        "Void Blue") THEME="void-blue" ;;
        *) exit 0 ;;
    esac
fi

# Validation
if [ ! -d "$THEME_ROOT/$THEME" ]; then
    notify-send "Error" "Theme $THEME not found!"
    exit 1
fi

# Update Symlink (Polybar & Rofi Colors)
rm -rf "$LINK_TARGET"
ln -s "$THEME_ROOT/$THEME" "$LINK_TARGET"

# Update Wallpaper
if [ -f "$LINK_TARGET/wallpaper.jpg" ]; then
    nitrogen --set-zoom-fill "$LINK_TARGET/wallpaper.jpg" --save
fi

# Update Dunst Color
if [ "$THEME" == "void-red" ]; then
    sed -i 's/frame_color = "#2e9ef4"/frame_color = "#ff5555"/g' "$DUNST_CONFIG"
    sed -i 's/frame_color = "#[0-9a-fA-F]*"/frame_color = "#ff5555"/g' "$DUNST_CONFIG"
elif [ "$THEME" == "void-blue" ]; then
    sed -i 's/frame_color = "#ff5555"/frame_color = "#2e9ef4"/g' "$DUNST_CONFIG"
fi

# Reload Services
~/.config/polybar/launch.sh
i3-msg reload
killall dunst && dunst &

notify-send "Theme Applied" "$THEME"