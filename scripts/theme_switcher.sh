#!/bin/bash

THEME=$1
THEME_ROOT="$HOME/.config/i3/themes"
LINK_TARGET="$THEME_ROOT/current"
DUNSTRC="$HOME/.config/dunst/dunstrc_base"

if [ -z "$THEME" ] || [ "$THEME" == "gui" ]; then
    OPT_PRO="  Pro Dark (Default)"
    OPT_PYWAL="  Pywal (Dynamic)"
    OPTIONS="$OPT_PRO\n$OPT_PYWAL"
    HEADER="<span color='#888888'>SELECT SYSTEM THEME STYLE</span>"
    
    CHOICE_INDEX=$(echo -e "$OPTIONS" | rofi -dmenu -i -format d -p "Theme" -mesg "$HEADER" -theme ~/.config/rofi/theme_select.rasi)
    
    case "$CHOICE_INDEX" in
        1) THEME="pro-dark" ;;
        2) THEME="pywal-custom" ;;
        *) exit 0 ;;
    esac
fi

if [ ! -d "$THEME_ROOT/$THEME" ]; then
    notify-send "Error" "Theme '$THEME' not found!"
    exit 1
fi

if [ "$THEME" == "pro-dark" ]; then
    ACCENT="#CBA6F7"
    ICON_THEME="Papirus-Dark"
    STARSHIP_PALETTE="default"
    BG_COLOR="#1E1E2EF2"
elif [ "$THEME" == "pywal-custom" ]; then
    ACCENT=$(grep "primary:" "$THEME_ROOT/$THEME/rofi.rasi" | cut -d'#' -f2 | cut -d';' -f1)
    ACCENT="#$ACCENT"
    ICON_THEME="Papirus-Dark"
    STARSHIP_PALETTE="default"
    BG_COLOR="#0A0A0FF2"
fi

if grep -q "# ==THEME_START==" "$DUNSTRC"; then
    sed -i "/# ==THEME_START==/,/# ==THEME_END==/c\\# ==THEME_START==\n\
    background = \"$BG_COLOR\"\n\
    frame_color = \"$ACCENT\"\n\
# ==THEME_END==" "$DUNSTRC"
    cp "$DUNSTRC" "$HOME/.config/dunst/dunstrc"
fi

cat > "$HOME/.config/i3/scripts/lock_colors.rc" <<EOF
export LOCK_RING="${ACCENT}cc"
export LOCK_TEXT="${ACCENT}ee"
export LOCK_INSIDE="#00000000"
export LOCK_WRONG="#F38BA8bb"
export LOCK_VERIFY="#CDD6F4bb"
EOF

sed -i "s/^palette = .*/palette = \"$STARSHIP_PALETTE\"/" "$HOME/.config/starship.toml"

rm -rf "$LINK_TARGET"
ln -s "$THEME_ROOT/$THEME" "$LINK_TARGET"
papirus-folders -C blue --theme Papirus-Dark &

if [ -f "$LINK_TARGET/wallpaper.jpg" ]; then
    nitrogen --set-zoom-fill "$LINK_TARGET/wallpaper.jpg" --save
fi

~/.config/polybar/launch.sh &
i3-msg reload >/dev/null

killall -9 dunst 2>/dev/null; sleep 1; dunst &
notify-send "System Synced" "Theme applied: $THEME"