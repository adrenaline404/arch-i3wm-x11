#!/bin/bash

THEME_FILE="$HOME/.config/current_theme"
if [ -f "$THEME_FILE" ]; then
    THEME=$(cat "$THEME_FILE")
else
    THEME="ocean"
fi

WALLPAPER_PATH="$HOME/.config/i3/themes/$THEME/wallpaper.jpg"
if [ ! -f "$WALLPAPER_PATH" ]; then
    WALLPAPER_PATH="$HOME/arch-i3wm-x11/themes/$THEME/wallpaper.jpg"
fi

if [ ! -f "$WALLPAPER_PATH" ]; then
    WALLPAPER_PATH=$(find "$HOME/arch-i3wm-x11/themes" -name "*.jpg" | head -n 1)
fi

echo "Setting wallpaper: $WALLPAPER_PATH"

if command -v feh &> /dev/null; then
    feh --bg-fill "$WALLPAPER_PATH"
elif command -v nitrogen &> /dev/null; then
    nitrogen --set-zoom-fill "$WALLPAPER_PATH" --save &> /dev/null
else
    echo "[ERROR] Install 'feh' untuk pengalaman terbaik."
    exit 1
fi