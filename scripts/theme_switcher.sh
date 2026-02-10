#!/bin/bash

THEME=$1
THEME_ROOT="$HOME/.config/i3/themes"
LINK_TARGET="$THEME_ROOT/current"

DUNST_COLORS="$HOME/.config/dunst/colors.ini"
STARSHIP_CONFIG="$HOME/.config/starship.toml"
LOCK_CONFIG="$HOME/.config/i3/scripts/lock_colors.rc"
GTK_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"

if [ -z "$THEME" ] || [ "$THEME" == "gui" ]; then
    OPT_RED="  Void Red"
    OPT_BLUE="  Void Blue"
    OPTIONS="$OPT_RED\n$OPT_BLUE"
    HEADER="<span color='#888888'>SELECT SYSTEM THEME STYLE</span>"
    
    CHOICE_INDEX=$(echo -e "$OPTIONS" | rofi -dmenu -i -format d -p "Theme" -mesg "$HEADER" -theme ~/.config/rofi/theme_select.rasi)
    
    case "$CHOICE_INDEX" in
        1) THEME="void-red" ;;
        2) THEME="void-blue" ;;
        *) exit 0 ;;
    esac
fi

if [ ! -d "$THEME_ROOT/$THEME" ]; then
    notify-send "Error" "Theme '$THEME' not found!"
    exit 1
fi

if [ "$THEME" == "void-red" ]; then
    ACCENT="#ff5555"
    ICON_COLOR="red"
    STARSHIP_PALETTE="void_red"
elif [ "$THEME" == "void-blue" ]; then
    ACCENT="#2e9ef4"
    ICON_COLOR="blue"
    STARSHIP_PALETTE="void_blue"
else
    ACCENT="#ffffff"
    ICON_COLOR="blue"
fi

rm -rf "$LINK_TARGET"
ln -s "$THEME_ROOT/$THEME" "$LINK_TARGET"
papirus-folders -C "$ICON_COLOR" --theme Papirus-Dark &

cat > "$DUNST_COLORS" <<EOF
[urgency_low]
    background = "#101010F2"
    foreground = "#888888"
    frame_color = "$ACCENT"
    timeout = 5

[urgency_normal]
    background = "#101010F2"
    foreground = "#ffffff"
    frame_color = "$ACCENT"
    timeout = 5

[urgency_critical]
    background = "#101010F2"
    foreground = "#ff5555"
    frame_color = "#ff5555"
    timeout = 0
EOF

sed -i "s/^palette = .*/palette = \"$STARSHIP_PALETTE\"/" "$STARSHIP_CONFIG"

echo "# Dynamic Lockscreen for $THEME" > "$LOCK_CONFIG"
echo "LOCK_RING=\"${ACCENT}cc\"" >> "$LOCK_CONFIG"
echo "LOCK_TEXT=\"${ACCENT}ee\"" >> "$LOCK_CONFIG"
echo 'LOCK_INSIDE="#00000000"' >> "$LOCK_CONFIG"
echo 'LOCK_WRONG="#880000bb"' >> "$LOCK_CONFIG"
echo 'LOCK_VERIFY="#ffffffbb"' >> "$LOCK_CONFIG"

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

if [ -f "$LINK_TARGET/wallpaper.jpg" ]; then
    nitrogen --set-zoom-fill "$LINK_TARGET/wallpaper.jpg" --save
fi

~/.config/polybar/launch.sh &
i3-msg reload >/dev/null

killall -q dunst
sleep 0.5
dunst &

notify-send "System Synced" "Theme applied: $THEME (Frame Color: $ACCENT)"