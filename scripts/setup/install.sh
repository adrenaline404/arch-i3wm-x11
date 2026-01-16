#!/bin/bash

set -e
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="$(pwd)"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
SYSTEM_SCRIPT_DIR="$HOME/scripts"

echo -e "${BLUE}[INFO] Memulai Instalasi Fail-Safe...${NC}"

if command -v yay &> /dev/null; then HELPER="yay"; elif command -v paru &> /dev/null; then HELPER="paru"; else
    echo -e "${RED}[ERROR] Install 'yay' atau 'paru' dulu!${NC}"; exit 1
fi

echo -e "${GREEN}[1/4] Installing Packages...${NC}"
CORE_PKGS="i3-wm polybar rofi alacritty dunst nitrogen thunar flameshot brightnessctl polkit-gnome starship jq libcanberra"
VISUAL_PKGS="picom-git i3lock-color-git lxappearance"
FONT_PKGS="ttf-jetbrains-mono-nerd noto-fonts-emoji ttf-font-awesome ttf-nerd-fonts-symbols"
AUDIO_PKGS="pipewire pipewire-pulse wireplumber pavucontrol"

$HELPER -S --needed --noconfirm --answerdiff=None --answerclean=None --removemake $CORE_PKGS $VISUAL_PKGS $FONT_PKGS $AUDIO_PKGS
fc-cache -fv > /dev/null

echo -e "${GREEN}[2/4] Backing up existing configs...${NC}"
mkdir -p "$BACKUP_DIR"
CONFIGS=("i3" "polybar" "picom" "rofi" "alacritty" "dunst" "starship")

for cfg in "${CONFIGS[@]}"; do
    if [ -d "$HOME/.config/$cfg" ]; then
        echo "   -> Backup $cfg ke $BACKUP_DIR/$cfg"
        cp -r "$HOME/.config/$cfg" "$BACKUP_DIR/"
    fi
done

echo -e "${GREEN}[3/4] Deploying Configs (Hard Copy)...${NC}"
mkdir -p "$HOME/.config"

for cfg in "${CONFIGS[@]}"; do
    SOURCE="$REPO_DIR/.config/$cfg"
    TARGET="$HOME/.config/$cfg"
    
    rm -rf "$TARGET"
    cp -rf "$SOURCE" "$TARGET"
done

echo -e "${GREEN}[4/4] Deploying Scripts to ~/scripts ...${NC}"
rm -rf "$SYSTEM_SCRIPT_DIR"
cp -rf "$REPO_DIR/scripts" "$SYSTEM_SCRIPT_DIR"

chmod +x "$SYSTEM_SCRIPT_DIR/setup/"*.sh
chmod +x "$SYSTEM_SCRIPT_DIR/theme-switcher/"*.sh
chmod +x "$SYSTEM_SCRIPT_DIR/utils/"*.sh

cp "$REPO_DIR/scripts/setup/restore.sh" "$SYSTEM_SCRIPT_DIR/restore.sh" 2>/dev/null || true
chmod +x "$SYSTEM_SCRIPT_DIR/restore.sh"

sudo usermod -aG video $USER

"$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ocean

echo -e "${BLUE}[DONE] Instalasi Selesai.${NC}"
echo -e "${BLUE}[INFO] Scripts tersimpan di: $SYSTEM_SCRIPT_DIR${NC}"
echo -e "${BLUE}[INFO] Backup tersimpan di: $BACKUP_DIR${NC}"
echo -e "${BLUE}[TIP] Jika error di TTY, jalankan: ~/scripts/restore.sh${NC}"