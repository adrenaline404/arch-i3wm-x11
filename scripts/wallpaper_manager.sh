#!/bin/bash

THEME_DIR=$(readlink -f ~/.config/i3/themes/current)
WALL_DIR="$THEME_DIR"
ROFI_CONF="~/.config/rofi/wallpaper.rasi"

add_wallpaper() {
    NEW_IMG=$(zenity --file-selection --title="Select Wallpaper Image" --file-filter="Images | *.jpg *.jpeg *.png *.webp")
    
    if [ -n "$NEW_IMG" ]; then
        FILENAME=$(basename "$NEW_IMG")
        TARGET="$WALL_DIR/$FILENAME"
        
        cp "$NEW_IMG" "$TARGET"
        
        notify-send "Wallpaper Manager" "Added: $FILENAME"
        
        exec "$0"
    fi
}

MENU_ENTRIES="  Add New\0icon\x1fview-refresh\n"

for img in "$WALL_DIR"/*.{jpg,jpeg,png,webp}; do
    if [ -f "$img" ]; then
        NAME=$(basename "$img")
        MENU_ENTRIES+="$NAME\0icon\x1f$img\n"
    fi
done

CHOICE=$(echo -e "$MENU_ENTRIES" | rofi -dmenu -i -show-icons -p "Wallpaper" -theme "$ROFI_CONF")

if [ -z "$CHOICE" ]; then
    exit 0
elif [ "$CHOICE" == "  Add New" ]; then
    add_wallpaper
else
    SELECTED_IMG="$WALL_DIR/$CHOICE"
    
    if [ -f "$SELECTED_IMG" ]; then
        nitrogen --set-zoom-fill "$SELECTED_IMG" --save
        
        cp "$SELECTED_IMG" "$WALL_DIR/wallpaper.jpg"
        
        notify-send "Wallpaper Changed" "$CHOICE"
    else
        notify-send "Error" "Image not found!"
    fi
fi