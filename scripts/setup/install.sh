#!/bin/bash

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

set -e
trap 'echo -e "${RED}[ERROR] Script interrupted or failed on line $LINENO.${NC}"; exit 1' ERR

show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "    _    ____   ____ _   _      _ _____                  __  __ __ "
    echo "   / \  |  _ \ / ___| | | |    (_)___ /__      __  __   / / / // |"
    echo "  / _ \ | |_) | |   | |_| |____| | |_ \ \ /\ / / |___|  \ \/ / | |"
    echo " / ___ \|  _ <| |___|  _  |____| |___) \ V  V /          >  <  | |"
    echo "/_/   \_\_| \_\\____|_| |_|    |_|____/ \_/\_/          /_/\_\ |_|"
    echo "                                                                  "
    echo -e "   :: Automated Setup :: ${GREEN}Arch Linux - i3wm - Setup${CYAN} ::"
    echo -e "${NC}"
    echo -e "${YELLOW}[!] Ensure you have a stable internet connection.${NC}"
    echo -e "${YELLOW}[!] Do NOT run this script as root (sudo). It will ask for password when needed.${NC}"
    echo ""
}

if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}[ERROR] Please run as a normal user, not root.${NC}"
  exit 1
fi

show_banner
read -p "Press [Enter] to start installation..."

echo -e "\n${BLUE}[1/5] Checking AUR Helper...${NC}"

if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    echo -e "${YELLOW}[INFO] AUR helper not found. Installing yay-bin (Faster)...${NC}"
    
    echo -e "${CYAN}:: Installing git & base-devel...${NC}"
    sudo pacman -S --needed --noconfirm git base-devel

    cd /tmp
    rm -rf yay-bin
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    
    echo -e "${GREEN}[OK] yay installed successfully.${NC}"
    cd - > /dev/null
else
    echo -e "${GREEN}[OK] AUR helper detected.${NC}"
fi

if command -v paru &> /dev/null; then HELPER="paru"; else HELPER="yay"; fi

echo -e "\n${BLUE}[2/5] Installing Packages & Fonts (Anti-Tofu)...${NC}"

CORE_PKGS="i3-wm polybar rofi alacritty dunst nitrogen thunar flameshot brightnessctl polkit-gnome starship jq"
AUDIO_PKGS="pipewire pipewire-pulse wireplumber pavucontrol"
VISUAL_PKGS="picom-git i3lock-color-git lxappearance"
FONT_PKGS="ttf-jetbrains-mono-nerd noto-fonts-emoji ttf-font-awesome ttf-nerd-fonts-symbols"
UTIL_PKGS="xorg-xrdb xorg-xinit unzip"

echo -e "${CYAN}:: Installing required packages via $HELPER...${NC}"
$HELPER -S --needed --noconfirm $CORE_PKGS $AUDIO_PKGS $VISUAL_PKGS $FONT_PKGS $UTIL_PKGS

echo -e "${CYAN}:: Refreshing Font Cache...${NC}"
fc-cache -fv > /dev/null
echo -e "${GREEN}[OK] Packages & Fonts installed.${NC}"

echo -e "\n${BLUE}[3/5] Setting up Dotfiles...${NC}"

REPO_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

CONFIGS=("i3" "polybar" "picom" "rofi" "alacritty" "dunst" "starship")

for cfg in "${CONFIGS[@]}"; do
    TARGET="$CONFIG_DIR/$cfg"
    SOURCE="$REPO_DIR/.config/$cfg"

    if [ -d "$TARGET" ] || [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
        echo -e "${YELLOW}   -> Backing up existing $cfg to $cfg.bak${NC}"
        mv "$TARGET" "$TARGET.bak.$(date +%s)"
    fi

    rm -rf "$TARGET"

    echo -e "   -> Linking $cfg"
    ln -s "$SOURCE" "$TARGET"
done

echo -e "${GREEN}[OK] Dotfiles linked.${NC}"

echo -e "\n${BLUE}[4/5] Finalizing Permissions...${NC}"

chmod +x "$REPO_DIR/scripts/setup/"*.sh
chmod +x "$REPO_DIR/scripts/theme-switcher/"*.sh
chmod +x "$REPO_DIR/scripts/utils/"*.sh
chmod +x "$REPO_DIR/.config/polybar/launch.sh"

if ! groups "$USER" | grep -q "\bvideo\b"; then
    echo -e "${CYAN}:: Adding user $USER to video group (brightness control)...${NC}"
    sudo usermod -aG video "$USER"
fi

echo -e "${GREEN}[OK] Permissions set.${NC}"

echo -e "\n${BLUE}[5/5] Applying Default Theme...${NC}"

if [ -f "$REPO_DIR/scripts/theme-switcher/switch.sh" ]; then
    "$REPO_DIR/scripts/theme-switcher/switch.sh" ocean
    echo -e "${GREEN}[OK] Ocean theme applied.${NC}"
else
    echo -e "${RED}[ERROR] Theme switcher script not found!${NC}"
fi

echo -e "\n${GREEN}==========================================${NC}"
echo -e "${BOLD}   INSTALLATION COMPLETE! ${NC}"
echo -e "${GREEN}==========================================${NC}"
echo -e "Please ${BOLD}REBOOT${NC} your system to finalize changes."
echo -e "After reboot, select 'i3' from your login manager."
echo -e "${RED}By: adrenaline404${NC}"
echo ""
read -p "Press [Enter] to exit..."