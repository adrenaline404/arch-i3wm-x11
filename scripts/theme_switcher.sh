#!/bin/bash

THEME=$1
THEME_ROOT="$HOME/.config/i3/themes"
LINK_TARGET="$THEME_ROOT/current"

if [ -z "$THEME" ] || [ "$THEME" == "gui" ]; then
    OPTIONS="Void Red\nVoid Blue"
    CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Select Theme")
    case "$CHOICE" in
        "Void Red") THEME="void-red" ;;
        "Void Blue") THEME="void-blue" ;;
        *) exit 0 ;;
    esac
fi

if [ ! -d "$THEME_ROOT/$THEME" ]; then
    echo "Error: Theme $THEME not found."
    exit 1
fi

rm -rf "$LINK_TARGET"
ln -s "$THEME_ROOT/$THEME" "$LINK_TARGET"

if [ -f "$LINK_TARGET/wallpaper.jpg" ]; then
    nitrogen --set-zoom-fill "$LINK_TARGET/wallpaper.jpg" --save
fi

~/.config/polybar/launch.sh
i3-msg reload

notify-send "Theme Active" "$THEME"