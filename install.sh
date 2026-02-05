#!/bin/bash

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

clear
echo -e "${BLUE}>>> STARTING...${NC}"

log "Installing Dependencies..."

if ! command -v yay &> /dev/null; then
    sudo pacman -S --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$REPO_DIR" || exit
fi

PKGS="i3-wm polybar picom-git nitrogen i3lock-color-git xorg-xset xorg-xrandr \
      brightnessctl playerctl libcanberra libcanberra-gtk3 \
      ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols noto-fonts-emoji \
      zsh-syntax-highlighting zsh-autosuggestions \
      network-manager-applet blueman pavucontrol flameshot \
      thunar thunar-archive-plugin file-roller gvfs gvfs-mtp unzip \
      papirus-icon-theme arc-gtk-theme"

yay -Syu --noconfirm --needed $PKGS

log "Deploying Configurations..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.config"

for cfg in i3 polybar scripts themes picom dunst kitty; do
    [ -d "$HOME/.config/$cfg" ] && mv "$HOME/.config/$cfg" "$BACKUP_DIR/"
done
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$BACKUP_DIR/"

cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
cp -r "$REPO_DIR/scripts" "$HOME/.config/i3/"
cp -r "$REPO_DIR/themes" "$HOME/.config/i3/"
cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"

log "Creating Udev Rule for Backlight Control..."
echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"' | sudo tee /etc/udev/rules.d/90-backlight.rules
echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"' | sudo tee -a /etc/udev/rules.d/90-backlight.rules

sudo usermod -aG video "$USER"
sudo usermod -aG input "$USER"

log "Setting Executable Permissions..."
chmod +x "$HOME/.config/i3/scripts/"*.sh
chmod +x "$HOME/.config/polybar/launch.sh"

log "Initializing Theme..."
bash "$HOME/.config/i3/scripts/theme_switcher.sh" "void-red"

echo -e "${GREEN}================================================"
echo -e " INSTALLATION COMPLETE!"
echo -e " YOU MUST REBOOT NOW FOR BRIGHTNESS TO WORK."
echo -e "================================================${NC}"