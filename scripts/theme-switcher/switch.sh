#!/bin/bash
THEME=$1
REPO_DIR="$HOME/arch-i3wm-x11"

if [[ ! -d "$REPO_DIR/themes/$THEME" ]]; then
    echo "Usage: ./switch.sh [black|ocean]"
    exit 1
fi

cp "$REPO_DIR/themes/$THEME/Xresources" "$HOME/.Xresources"
xrdb -merge "$HOME/.Xresources"

echo "$THEME" > "$HOME/.config/current_theme"
"$REPO_DIR/scripts/utils/set-wallpaper.sh"

BG=$(xrdb -query | grep "*background" | awk '{print $2}')
FG=$(xrdb -query | grep "*foreground" | awk '{print $2}')
ACC=$(xrdb -query | grep "*accent" | awk '{print $2}')

cat > "$HOME/.config/rofi/theme.rasi" <<EOF
* {
    bg: ${BG}E6;
    bg-alt: ${BG};
    fg: ${FG};
    accent: ${ACC};
    background-color: @bg;
    text-color: @fg;
}
EOF

i3-msg reload
"$HOME/.config/polybar/launch.sh" &
dunstify "Theme Switched" "Active: $THEME"