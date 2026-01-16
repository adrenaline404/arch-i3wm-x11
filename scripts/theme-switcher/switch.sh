#!/bin/bash

THEME=$1
REPO_DIR="$HOME/arch-i3wm-x11"
SCRIPT_DIR="$HOME/scripts"

if [ -z "$THEME" ]; then
    echo "Usage: $0 [ocean|black]"
    echo "Available themes: ocean, black"
    exit 1
fi

if [ ! -d "$REPO_DIR/themes/$THEME" ]; then
    echo "Error: Theme '$THEME' not found in $REPO_DIR/themes/"
    exit 1
fi

echo "Switching to $THEME theme..."

cp "$REPO_DIR/themes/$THEME/Xresources" "$HOME/.Xresources"
xrdb -merge "$HOME/.Xresources"

echo "$THEME" > "$HOME/.config/current_theme"

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

if [ -x "$SCRIPT_DIR/utils/set-wallpaper.sh" ]; then
    "$SCRIPT_DIR/utils/set-wallpaper.sh"
else
    echo "[WARN] set-wallpaper.sh not executable trying to run via bash..."
    bash "$SCRIPT_DIR/utils/set-wallpaper.sh"
fi

i3-msg reload > /dev/null

"$HOME/.config/polybar/launch.sh" &

if command -v dunstify &> /dev/null; then
    dunstify "Theme System" "Applied theme: $THEME" -u low -r 9991
fi

echo "Done."