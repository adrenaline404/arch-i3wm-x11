#!/bin/bash
THEME_FILE="$HOME/.config/current_theme"
[ -f "$THEME_FILE" ] && THEME=$(cat "$THEME_FILE") || THEME="ocean"
WALLPAPER="$HOME/arch-i3wm-x11/themes/$THEME/wallpaper.jpg"

sleep 1
if command -v nitrogen &> /dev/null; then
    nitrogen --set-zoom-fill "$WALLPAPER" --save
else
    feh --bg-fill "$WALLPAPER"
fi