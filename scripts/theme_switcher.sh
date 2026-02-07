#!/bin/bash

THEME=$1
THEME_ROOT="$HOME/.config/i3/themes"
LINK_TARGET="$THEME_ROOT/current"
DUNST_CONFIG="$HOME/.config/dunst/dunstrc"
LOCK_CONFIG="$HOME/.config/i3/scripts/lock_colors.rc"
GTK_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"

# GUI SELECTION
if [ -z "$THEME" ] || [ "$THEME" == "gui" ]; then
    OPTIONS="🔴  Void Red\n🔵  Void Blue"
    
    CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Theme" -theme ~/.config/rofi/theme_select.rasi)
    
    case "$CHOICE" in
        *"Void Red") THEME="void-red" ;;
        *"Void Blue") THEME="void-blue" ;;
        *) exit 0 ;;
    esac
fi

# Update Symlink
rm -rf "$LINK_TARGET"
ln -s "$THEME_ROOT/$THEME" "$LINK_TARGET"

# Update GTK & Dunst & Icons
if [ "$THEME" == "void-red" ]; then
    papirus-folders -C red --theme Papirus-Dark &
    sed -i 's/frame_color = "#[0-9a-fA-F]*"/frame_color = "#ff5555"/g' "$DUNST_CONFIG"
    
elif [ "$THEME" == "void-blue" ]; then
    papirus-folders -C blue --theme Papirus-Dark &
    sed -i 's/frame_color = "#[0-9a-fA-F]*"/frame_color = "#2e9ef4"/g' "$DUNST_CONFIG"
fi

# Update GTK 3.0 Settings
mkdir -p "$HOME/.config/gtk-3.0"
cat > "$GTK_SETTINGS" <<EOF
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrainsMono Nerd Font 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialiasing=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintmedium
EOF

# Update Lockscreen Colors
echo "# Dynamic Lockscreen for $THEME" > "$LOCK_CONFIG"
if [ "$THEME" == "void-red" ]; then
    echo 'LOCK_RING="#FF0000cc"' >> "$LOCK_CONFIG"
    echo 'LOCK_TEXT="#FF0000ee"' >> "$LOCK_CONFIG"
    echo 'LOCK_INSIDE="#00000000"' >> "$LOCK_CONFIG"
    echo 'LOCK_WRONG="#880000bb"' >> "$LOCK_CONFIG"
    echo 'LOCK_VERIFY="#ff5555bb"' >> "$LOCK_CONFIG"
elif [ "$THEME" == "void-blue" ]; then
    echo 'LOCK_RING="#2e9ef4cc"' >> "$LOCK_CONFIG"
    echo 'LOCK_TEXT="#2e9ef4ee"' >> "$LOCK_CONFIG"
    echo 'LOCK_INSIDE="#00000000"' >> "$LOCK_CONFIG"
    echo 'LOCK_WRONG="#ff5555bb"' >> "$LOCK_CONFIG"
    echo 'LOCK_VERIFY="#50fa7bbb"' >> "$LOCK_CONFIG"
fi

# Apply Wallpaper
if [ -f "$LINK_TARGET/wallpaper.jpg" ]; then
    nitrogen --set-zoom-fill "$LINK_TARGET/wallpaper.jpg" --save
fi

# Reload Services
~/.config/polybar/launch.sh
i3-msg reload
killall dunst && dunst &

# Notification
notify-send "System Synced" "Theme: $THEME\nGTK, Icons, & Borders Updated."