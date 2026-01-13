#!/bin/bash

# Theme Switcher Script for arch-i3wm-x11
# Usage: ./switch-theme.sh [black|ocean]

THEME_DIR="$HOME/themes"
CONFIG_DIR="$HOME/.config"
XRESOURCES="$HOME/.Xresources"

if [ -z "$1" ]; then
    echo "Usage: $0 [black|ocean]"
    echo "Available themes: black, ocean"
    exit 1
fi

THEME="$1"

if [ "$THEME" != "black" ] && [ "$THEME" != "ocean" ]; then
    echo "Error: Invalid theme '$THEME'"
    echo "Available themes: black, ocean"
    exit 1
fi

echo "Switching to $THEME theme..."

if [ -f "$THEME_DIR/$THEME/colors/Xresources" ]; then
    cp "$THEME_DIR/$THEME/colors/Xresources" "$XRESOURCES"
    echo "✓ Xresources updated"
else
    echo "✗ Theme Xresources not found!"
    exit 1
fi

xrdb -merge "$XRESOURCES"
echo "✓ Xresources reloaded"

if [ "$THEME" = "black" ]; then
    sed -i 's/background: #[0-9a-fA-F]\{6,8\};/background: #0d0d0dee;/' "$CONFIG_DIR/rofi/config.rasi"
    sed -i 's/background-alt: #[0-9a-fA-F]\{6,8\};/background-alt: #1a1a1aaa;/' "$CONFIG_DIR/rofi/config.rasi"
    sed -i 's/foreground: #[0-9a-fA-F]\{6,8\};/foreground: #ffffff;/' "$CONFIG_DIR/rofi/config.rasi"
    sed -i 's/accent: #[0-9a-fA-F]\{6,8\};/accent: #5294e2;/' "$CONFIG_DIR/rofi/config.rasi"
elif [ "$THEME" = "ocean" ]; then
    sed -i 's/background: #[0-9a-fA-F]\{6,8\};/background: #0a192fee;/' "$CONFIG_DIR/rofi/config.rasi"
    sed -i 's/background-alt: #[0-9a-fA-F]\{6,8\};/background-alt: #112240aa;/' "$CONFIG_DIR/rofi/config.rasi"
    sed -i 's/foreground: #[0-9a-fA-F]\{6,8\};/foreground: #e6f1ff;/' "$CONFIG_DIR/rofi/config.rasi"
    sed -i 's/accent: #[0-9a-fA-F]\{6,8\};/accent: #64ffda;/' "$CONFIG_DIR/rofi/config.rasi"
fi
echo "✓ Rofi theme updated"

if [ "$THEME" = "black" ]; then
    sed -i "s/background: '#[0-9a-fA-F]\{6\}'/background: '#0d0d0d'/" "$CONFIG_DIR/alacritty/alacritty.yml"
    sed -i "s/foreground: '#[0-9a-fA-F]\{6\}'/foreground: '#ffffff'/" "$CONFIG_DIR/alacritty/alacritty.yml"
    sed -i "s/background: '#[0-9a-fA-F]\{6\}'/background: '#5294e2'/" "$CONFIG_DIR/alacritty/alacritty.yml" | tail -n 1
elif [ "$THEME" = "ocean" ]; then
    sed -i "s/background: '#[0-9a-fA-F]\{6\}'/background: '#0a192f'/" "$CONFIG_DIR/alacritty/alacritty.yml"
    sed -i "s/foreground: '#[0-9a-fA-F]\{6\}'/foreground: '#e6f1ff'/" "$CONFIG_DIR/alacritty/alacritty.yml"
    sed -i "s/background: '#[0-9a-fA-F]\{6\}'/background: '#64ffda'/" "$CONFIG_DIR/alacritty/alacritty.yml" | tail -n 1
fi
echo "✓ Alacritty colors updated"

if [ "$THEME" = "black" ]; then
    sed -i 's/background = "#[0-9a-fA-F]\{6,8\}"/background = "#0d0d0dee"/' "$CONFIG_DIR/dunst/dunstrc"
    sed -i 's/foreground = "#[0-9a-fA-F]\{6,8\}"/foreground = "#ffffff"/' "$CONFIG_DIR/dunst/dunstrc"
    sed -i '/\[urgency_low\]/,/\[urgency_normal\]/ s/frame_color = "#[0-9a-fA-F]\{6,8\}"/frame_color = "#5294e2"/' "$CONFIG_DIR/dunst/dunstrc"
    sed -i '/\[urgency_normal\]/,/\[urgency_critical\]/ s/frame_color = "#[0-9a-fA-F]\{6,8\}"/frame_color = "#5294e2"/' "$CONFIG_DIR/dunst/dunstrc"
elif [ "$THEME" = "ocean" ]; then
    sed -i 's/background = "#[0-9a-fA-F]\{6,8\}"/background = "#0a192fee"/' "$CONFIG_DIR/dunst/dunstrc"
    sed -i 's/foreground = "#[0-9a-fA-F]\{6,8\}"/foreground = "#e6f1ff"/' "$CONFIG_DIR/dunst/dunstrc"
    sed -i '/\[urgency_low\]/,/\[urgency_normal\]/ s/frame_color = "#[0-9a-fA-F]\{6,8\}"/frame_color = "#64ffda"/' "$CONFIG_DIR/dunst/dunstrc"
    sed -i '/\[urgency_normal\]/,/\[urgency_critical\]/ s/frame_color = "#[0-9a-fA-F]\{6,8\}"/frame_color = "#64ffda"/' "$CONFIG_DIR/dunst/dunstrc"
fi
echo "✓ Dunst colors updated"

killall dunst
dunst &
echo "✓ Dunst restarted"

$CONFIG_DIR/polybar/launch.sh &
echo "✓ Polybar reloaded"

killall picom
picom --config "$CONFIG_DIR/picom/picom.conf" &
echo "✓ Picom restarted"

i3-msg reload
echo "✓ i3 reloaded"

if [ -f "$THEME_DIR/$THEME/wallpapers/main.jpg" ]; then
    nitrogen --set-zoom-fill "$THEME_DIR/$THEME/wallpapers/main.jpg"
    echo "✓ Wallpaper updated"
fi

echo ""
echo "Theme switched to '$THEME' successfully!"
echo "You may need to restart some applications for full effect."