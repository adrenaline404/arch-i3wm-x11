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
    echo "[WARN] Wallpaper spesifik tidak ditemukan. Mencari alternatif..."
    WALLPAPER_PATH=$(find "$HOME/arch-i3wm-x11/themes" -name "*.jpg" | head -n 1)
fi

if [ -z "$WALLPAPER_PATH" ] || [ ! -f "$WALLPAPER_PATH" ]; then
    echo "[ERROR] Tidak ada file wallpaper yang ditemukan."
    exit 1
fi

echo "Setting wallpaper: $WALLPAPER_PATH"
if command -v nitrogen &> /dev/null; then
    nitrogen --set-zoom-fill "$WALLPAPER_PATH" --save
elif command -v feh &> /dev/null; then
    feh --bg-fill "$WALLPAPER_PATH"
else
    echo "[ERROR] Neither 'nitrogen' nor 'feh' is installed."
    exit 1
fi