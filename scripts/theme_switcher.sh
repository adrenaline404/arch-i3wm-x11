#!/bin/bash

THEME=$1
THEME_ROOT="$HOME/.config/i3/themes"
LINK_TARGET="$THEME_ROOT/current"
DUNSTRC="$HOME/.config/dunst/dunstrc_base"

if [ -z "$THEME" ] || [ "$THEME" == "gui" ]; then
    OPT_RED="  Void Red"
    OPT_BLUE="  Void Blue"
    OPT_PYWAL="  Pywal Custom"
    OPTIONS="$OPT_RED\n$OPT_BLUE\n$OPT_PYWAL"
    HEADER="<span color='#888888'>SELECT SYSTEM THEME STYLE</span>"
    
    CHOICE_INDEX=$(echo -e "$OPTIONS" | rofi -dmenu -i -format d -p "Theme" -mesg "$HEADER" -theme ~/.config/rofi/theme_select.rasi)
    
    case "$CHOICE_INDEX" in
        1) THEME="void-red" ;;
        2) THEME="void-blue" ;;
        3) THEME="pywal-custom" ;;
        *) exit 0 ;;
    esac
fi

if [ ! -d "$THEME_ROOT/$THEME" ]; then
    notify-send "Error" "Theme '$THEME' not found!"
    exit 1
fi

if [ "$THEME" == "void-red" ]; then
    ACCENT="#ff5555"
    ICON_THEME="red"
    STARSHIP_PALETTE="void_red"
    BG_COLOR="#101010F2"
elif [ "$THEME" == "void-blue" ]; then
    ACCENT="#2e9ef4"
    ICON_THEME="blue"
    STARSHIP_PALETTE="void_blue"
    BG_COLOR="#101010F2"
elif [ "$THEME" == "pywal-custom" ]; then
    ACCENT=$(grep "primary:" "$THEME_ROOT/$THEME/rofi.rasi" | cut -d'#' -f2 | cut -d';' -f1)
    ACCENT="#$ACCENT"
    ICON_THEME="blue" # Default fallback
    STARSHIP_PALETTE="void_blue"
    BG_COLOR="#101010F2"
fi

# Update Dunstrc in-place
if grep -q "# ==THEME_START==" "$DUNSTRC"; then
    sed -i "/# ==THEME_START==/,/# ==THEME_END==/c\\# ==THEME_START==\n\
    background = \"$BG_COLOR\"\n\
    frame_color = \"$ACCENT\"\n\
# ==THEME_END==" "$DUNSTRC"
    cp "$DUNSTRC" "$HOME/.config/dunst/dunstrc"
fi

# Lockscreen Export
cat > "$HOME/.config/i3/scripts/lock_colors.rc" <<EOF
export LOCK_RING="${ACCENT}cc"
export LOCK_TEXT="${ACCENT}ee"
export LOCK_INSIDE="#00000000"
export LOCK_WRONG="#880000bb"
export LOCK_VERIFY="#ffffffbb"
EOF

# Starship
sed -i "s/^palette = .*/palette = \"$STARSHIP_PALETTE\"/" "$HOME/.config/starship.toml"

# Symlink & Wallpaper
rm -rf "$LINK_TARGET"
ln -s "$THEME_ROOT/$THEME" "$LINK_TARGET"
papirus-folders -C "$ICON_THEME" --theme Papirus-Dark &

if [ -f "$LINK_TARGET/wallpaper.jpg" ]; then
    nitrogen --set-zoom-fill "$LINK_TARGET/wallpaper.jpg" --save
fi

~/.config/polybar/launch.sh &
i3-msg reload >/dev/null

killall -9 dunst 2>/dev/null; sleep 1; dunst &
notify-send "System Synced" "Theme applied: $THEME"