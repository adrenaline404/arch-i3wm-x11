#!/bin/bash

set -e
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}[INFO] Memulai Instalasi...${NC}"

if command -v yay &> /dev/null; then
    HELPER="yay"
elif command -v paru &> /dev/null; then
    HELPER="paru"
else
    echo -e "${RED}[ERROR] Install 'yay' atau 'paru' dulu!${NC}"
    exit 1
fi

CORE_PKGS="i3-wm polybar rofi alacritty dunst nitrogen thunar flameshot brightnessctl polkit-gnome starship jq libcanberra"
AUDIO_PKGS="pipewire pipewire-pulse wireplumber pavucontrol"
VISUAL_PKGS="picom-git i3lock-color-git lxappearance"
FONT_PKGS="ttf-jetbrains-mono-nerd noto-fonts-emoji ttf-font-awesome ttf-nerd-fonts-symbols"

echo -e "${GREEN}[ACTION] Menginstall paket via $HELPER (Auto-confirm)...${NC}"

$HELPER -S --needed --noconfirm --answerdiff=None --answerclean=None --removemake $CORE_PKGS $AUDIO_PKGS $VISUAL_PKGS $FONT_PKGS

echo -e "${GREEN}[ACTION] Refreshing Font Cache...${NC}"
fc-cache -fv > /dev/null

echo -e "${GREEN}[ACTION] Setting Permissions...${NC}"
chmod +x scripts/setup/*.sh
chmod +x scripts/theme-switcher/*.sh
chmod +x scripts/utils/*.sh
chmod +x .config/polybar/launch.sh

sudo usermod -aG video $USER

echo -e "${BLUE}[DONE] Instalasi selesai. Silakan REBOOT.${NC}"