#!/bin/bash

THEME=$1
THEME_ROOT="$HOME/.config/i3/themes"
LINK_TARGET="$THEME_ROOT/current"
DUNST_CONFIG="$HOME/.config/dunst/dunstrc"
LOCK_CONFIG="$HOME/.config/i3/scripts/lock_colors.rc"

# GUI SELECTION
if [ -z "$THEME" ] || [ "$THEME" == "gui" ]; then
    OPTIONS="Void Red\nVoid Blue"
    CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Select Theme" -theme ~/.config/rofi/config.rasi)
    case "$CHOICE" in
        "Void Red") THEME="void-red" ;;
        "Void Blue") THEME="void-blue" ;;
        *) exit 0 ;;
    esac
fi

# VALIDATION
if [ ! -d "$THEME_ROOT/$THEME" ]; then
    notify-send "Error" "Theme $THEME not found!"
    exit 1
fi

# APPLY SYMLINKS (Polybar/Rofi)
rm -rf "$LINK_TARGET"
ln -s "$THEME_ROOT/$THEME" "$LINK_TARGET"

# APPLY WALLPAPER
if [ -f "$LINK_TARGET/wallpaper.jpg" ]; then
    nitrogen --set-zoom-fill "$LINK_TARGET/wallpaper.jpg" --save
fi

# APPLY DUNST COLORS
if [ "$THEME" == "void-red" ]; then
    sed -i 's/frame_color = "#[0-9a-fA-F]*"/frame_color = "#ff5555"/g' "$DUNST_CONFIG"
elif [ "$THEME" == "void-blue" ]; then
    sed -i 's/frame_color = "#[0-9a-fA-F]*"/frame_color = "#2e9ef4"/g' "$DUNST_CONFIG"
fi

# APPLY LOCKSCREEN COLORS
echo "# Dynamic Lockscreen Colors for $THEME" > "$LOCK_CONFIG"

if [ "$THEME" == "void-red" ]; then
    echo 'LOCK_RING="#FF0000cc"' >> "$LOCK_CONFIG"
    echo 'LOCK_INSIDE="#00000000"' >> "$LOCK_CONFIG"
    echo 'LOCK_TEXT="#FF0000ee"' >> "$LOCK_CONFIG"
    echo 'LOCK_WRONG="#880000bb"' >> "$LOCK_CONFIG"
    echo 'LOCK_VERIFY="#ff5555bb"' >> "$LOCK_CONFIG"
elif [ "$THEME" == "void-blue" ]; then
    echo 'LOCK_RING="#2e9ef4cc"' >> "$LOCK_CONFIG"
    echo 'LOCK_INSIDE="#00000000"' >> "$LOCK_CONFIG"
    echo 'LOCK_TEXT="#2e9ef4ee"' >> "$LOCK_CONFIG"
    echo 'LOCK_WRONG="#ff5555bb"' >> "$LOCK_CONFIG"
    echo 'LOCK_VERIFY="#50fa7bbb"' >> "$LOCK_CONFIG"
fi

# RELOAD SERVICES
~/.config/polybar/launch.sh
i3-msg reload
killall dunst && dunst &

notify-send "Theme Active" "$THEME (Lockscreen Updated)"