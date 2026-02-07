#!/bin/bash

THEME_DIR=$(readlink -f ~/.config/i3/themes/current)
CUSTOM_DIR="$HOME/Wallpapers"
ROFI_CONF="$HOME/.config/rofi/wallpaper.rasi"

if [ ! -d "$CUSTOM_DIR" ]; then
    mkdir -p "$CUSTOM_DIR"
fi

import_wallpaper() {
    NEW_IMG=$(zenity --file-selection --title="Import New Wallpaper" --filename="$HOME/Pictures/" --file-filter="Images | *.jpg *.jpeg *.png *.webp")
    
    if [ -n "$NEW_IMG" ]; then
        FILENAME=$(basename "$NEW_IMG")
        TARGET="$CUSTOM_DIR/$FILENAME"
        
        cp "$NEW_IMG" "$TARGET"
        
        if [ $? -eq 0 ]; then
            notify-send "Wallpaper Manager" "Successfully imported: $FILENAME"
            exec "$0"
        else
            notify-send "Error" "Failed to import image."
        fi
    fi
}

MENU_ENTRIES="  Import New Wallpaper\0icon\x1fview-refresh\n"

shopt -s nullglob

for img in "$THEME_DIR"/*.{jpg,jpeg,png,webp}; do
    NAME=$(basename "$img")
    MENU_ENTRIES+="[Theme] $NAME\0icon\x1f$img\n"
done

CUSTOM_COUNT=0
for img in "$CUSTOM_DIR"/*.{jpg,jpeg,png,webp}; do
    NAME=$(basename "$img")
    MENU_ENTRIES+="$NAME\0icon\x1f$img\n"
    ((CUSTOM_COUNT++))
done

if [ "$CUSTOM_COUNT" -eq 0 ]; then
    MENU_ENTRIES+="  No custom wallpapers yet\0icon\x1finfo\n"
fi

CHOICE=$(echo -e "$MENU_ENTRIES" | rofi -dmenu -i -show-icons -p "Gallery" -theme "$ROFI_CONF")

if [ -z "$CHOICE" ]; then
    exit 0

elif [[ "$CHOICE" == "  Import New Wallpaper" ]]; then
    import_wallpaper

elif [[ "$CHOICE" == "  No custom wallpapers yet" ]]; then
    exit 0

else

    CLEAN_NAME=$(echo "$CHOICE" | sed 's/\[Theme\] //')
    
    if [ -f "$THEME_DIR/$CLEAN_NAME" ]; then
        TARGET_IMG="$THEME_DIR/$CLEAN_NAME"
    elif [ -f "$CUSTOM_DIR/$CLEAN_NAME" ]; then
        TARGET_IMG="$CUSTOM_DIR/$CLEAN_NAME"
    fi
    
    if [ -f "$TARGET_IMG" ]; then
        nitrogen --set-zoom-fill "$TARGET_IMG" --save
        
        cp "$TARGET_IMG" "$THEME_DIR/wallpaper.jpg"
        
        notify-send "Wallpaper Changed" "$CLEAN_NAME applied."
    else
        notify-send "Error" "Image file not found!"
    fi
fi