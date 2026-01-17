#!/bin/bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="$(pwd)"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
SYSTEM_SCRIPT_DIR="$HOME/scripts"
CONFIG_DIR="$HOME/.config"

show_banner() {
    clear
    echo -e "${CYAN}"
    echo "    _    ____   ____ _   _      ___ _____  __        ____  __         __  __  _ "
    echo "   / \  |  _ \ / ___| | | |    |_ _|___ /__\ \      / /  \/  |        \ \/ / / |"
    echo "  / _ \ | |_) | |   | |_| |_____| |  |_ \__ \ \ /\ / /| |\/| |_____    \  /  | |"
    echo " / ___ \|  _ <| |___|  _  |_____| | ___) |   \ V  V / | |  | |_____|   /  \  | |"
    echo "/_/   \_\_| \_\\____|_| |_|    |___|____/     \_/\_/  |_|  |_|        /_/\_\ |_|"
    echo -e "${NC}"
    echo -e "${BLUE}  :: Installer & Setup Script :: v2.0 ::${NC}"
    echo ""
    sleep 2
}

show_banner
echo -e "${BLUE}[INFO] Checking system dependencies...${NC}"

if command -v yay &> /dev/null; then HELPER="yay"; elif command -v paru &> /dev/null; then HELPER="paru"; else
    echo -e "${RED}[ERROR] AUR Helper not found! Please install 'yay' or 'paru' first.${NC}"; exit 1
fi

echo -e "${GREEN}[1/6] Installing Essential Packages...${NC}"

CORE_PKGS="i3-wm polybar rofi kitty dunst feh thunar flameshot brightnessctl polkit-gnome starship jq libcanberra fastfetch xorg-xrandr arandr imagemagick"

VISUAL_PKGS="picom-git i3lock-color-git lxappearance"
FONT_PKGS="ttf-jetbrains-mono-nerd noto-fonts-emoji ttf-font-awesome ttf-nerd-fonts-symbols"

AUDIO_PKGS="pipewire pipewire-pulse wireplumber pavucontrol"

$HELPER -S --needed --noconfirm --answerdiff=None --answerclean=None --removemake $CORE_PKGS $VISUAL_PKGS $FONT_PKGS $AUDIO_PKGS

echo "   -> Refreshing font cache..."
fc-cache -fv > /dev/null

echo -e "${GREEN}[2/6] Backing up existing configs...${NC}"
mkdir -p "$BACKUP_DIR"

CONFIG_LIST=("i3" "polybar" "picom" "rofi" "kitty" "dunst" "starship" "fastfetch")

for cfg in "${CONFIG_LIST[@]}"; do
    if [ -d "$HOME/.config/$cfg" ]; then
        echo "   -> Backup $cfg to $BACKUP_DIR..."
        cp -r "$HOME/.config/$cfg" "$BACKUP_DIR/"
    fi
done

echo -e "${GREEN}[3/6] Deploying Configs...${NC}"
mkdir -p "$CONFIG_DIR"

for cfg in "${CONFIG_LIST[@]}"; do
    SOURCE="$REPO_DIR/.config/$cfg"
    TARGET="$CONFIG_DIR/$cfg"
    
    rm -rf "$TARGET"
    
    if [ -d "$SOURCE" ]; then
        echo "   -> Installing $cfg..."
        cp -rf "$SOURCE" "$TARGET"
    else
        echo -e "${YELLOW}   [WARN] Config for $cfg not found in repo, skipping.${NC}"
        if [ "$cfg" == "kitty" ]; then mkdir -p "$TARGET"; fi
    fi
done

touch "$CONFIG_DIR/kitty/current-theme.conf"

echo -e "${GREEN}[4/6] Setting up Assets...${NC}"
FASTFETCH_DIR="$CONFIG_DIR/fastfetch"
mkdir -p "$FASTFETCH_DIR"

LOGO_PATH="$FASTFETCH_DIR/arch_logo.png"
if [ ! -f "$LOGO_PATH" ]; then
    echo "   -> Downloading Arch Linux Logo (High-Res PNG)..."
    curl -sL "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Archlinux-icon-crystal-64.svg/1024px-Archlinux-icon-crystal-64.svg.png" -o "$LOGO_PATH"
else
    echo "   -> Logo already exists."
fi

echo -e "${GREEN}[5/6] Installing Scripts & Fixing Permissions...${NC}"

rm -rf "$SYSTEM_SCRIPT_DIR"

cp -rf "$REPO_DIR/scripts" "$SYSTEM_SCRIPT_DIR"

echo "   -> Applying chmod +x to all .sh files..."
find "$SYSTEM_SCRIPT_DIR" -name "*.sh" -exec chmod +x {} \;

chmod +x "$CONFIG_DIR/polybar/launch.sh"

echo -e "${GREEN}[6/6] Finalizing System Setup...${NC}"

BASHRC="$HOME/.bashrc"
sed -i '/run_fastfetch/d' "$BASHRC"
sed -i '/fastfetch/d' "$BASHRC"
echo "" >> "$BASHRC"
echo '# --- FASTFETCH AUTO START ---' >> "$BASHRC"
echo 'if [[ -x "$(command -v fastfetch)" && $- == *i* ]]; then' >> "$BASHRC"
echo '    clear' >> "$BASHRC"
echo '    fastfetch' >> "$BASHRC"
echo 'fi' >> "$BASHRC"

echo "   -> Adding user '$USER' to video group..."
sudo usermod -aG video "$USER"

echo "   -> Applying Initial Theme (Ocean)..."
if [ -x "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ]; then
    "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ocean
else
    echo -e "${RED}[ERROR] Switch script not executable!${NC}"
fi

echo ""
echo -e "${CYAN}======================================================${NC}"
echo -e "${GREEN}   INSTALLATION COMPLETED SUCCESSFULLY!   ${NC}"
echo -e "${CYAN}======================================================${NC}"
echo -e "${YELLOW}Please REBOOT your system to apply all changes.${NC}"
echo -e "${YELLOW}Command: reboot${NC}"