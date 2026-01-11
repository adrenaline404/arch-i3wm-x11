#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOME/.config"
WALL="$HOME/Pictures"
BACKUP="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

echo "[*] Arch i3wm X11 installer"

command -v pacman >/dev/null || { echo "Arch only"; exit 1; }

PKGS=(
  i3-wm polybar rofi dunst picom feh
  pamixer brightnessctl playerctl
  maim xclip xorg-xrandr
  xsecurelock
)

sudo pacman -S --needed --noconfirm "${PKGS[@]}"

mkdir -p "$BACKUP"
for d in i3 polybar rofi dunst picom; do
  [[ -d "$CONFIG/$d" ]] && cp -r "$CONFIG/$d" "$BACKUP/"
done

mkdir -p "$CONFIG"
cp -r "$REPO_DIR/config/"* "$CONFIG/"

mkdir -p "$WALL"
cp -r "$REPO_DIR/wallpaper/"* "$WALL/"

chmod +x \
  "$CONFIG/i3/autostart.sh" \
  "$CONFIG/i3/lock.sh" \
  "$CONFIG/i3/scripts/"*.sh \
  "$CONFIG/polybar/launch.sh" \
  "$CONFIG/rofi/theme-switcher.sh"

if systemctl is-enabled lightdm &>/dev/null; then
  echo "[✓] LightDM detected"
else
  echo "[!] LightDM not enabled"
fi

echo "[✓] Done. Logout → select i3 session."