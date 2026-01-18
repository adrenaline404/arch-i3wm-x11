#!/bin/bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="$(pwd)"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
SYSTEM_SCRIPT_DIR="$HOME/scripts"
CONFIG_DIR="$HOME/.config"

echo -e "${BLUE}[INFO] Starting Comprehensive System Setup...${NC}"

echo -e "${GREEN}[1/5] Checking & Installing Packages...${NC}"

if command -v yay &> /dev/null; then HELPER="yay"; elif command -v paru &> /dev/null; then HELPER="paru"; else
    echo -e "${RED}[ERROR] AUR Helper not found. Please install 'yay' or 'paru' first.${NC}"; exit 1
fi

CORE_PKGS="i3-wm polybar rofi kitty dunst feh thunar flameshot brightnessctl polkit-gnome starship jq libcanberra fastfetch xorg-xrandr arandr imagemagick"
VISUAL_PKGS="picom-git i3lock-color-git lxappearance"
FONT_PKGS="ttf-jetbrains-mono-nerd noto-fonts-emoji ttf-font-awesome ttf-nerd-fonts-symbols"
AUDIO_PKGS="pipewire pipewire-pulse wireplumber pavucontrol"

$HELPER -S --needed --noconfirm --answerdiff=None --answerclean=None --removemake $CORE_PKGS $VISUAL_PKGS $FONT_PKGS $AUDIO_PKGS

fc-cache -fv > /dev/null

echo -e "${GREEN}[2/5] Deploying Configurations...${NC}"

mkdir -p "$BACKUP_DIR"
CONFIG_LIST=("i3" "polybar" "picom" "rofi" "kitty" "dunst" "starship" "fastfetch")

for cfg in "${CONFIG_LIST[@]}"; do
    if [ -d "$CONFIG_DIR/$cfg" ]; then
        cp -r "$CONFIG_DIR/$cfg" "$BACKUP_DIR/"
    fi
done

mkdir -p "$CONFIG_DIR"
for cfg in "${CONFIG_LIST[@]}"; do
    SOURCE="$REPO_DIR/.config/$cfg"
    TARGET="$CONFIG_DIR/$cfg"
    
    rm -rf "$TARGET"
    
    if [ -d "$SOURCE" ]; then 
        cp -rf "$SOURCE" "$TARGET"
    else
        mkdir -p "$TARGET"
    fi
done

touch "$CONFIG_DIR/kitty/current-theme.conf"

echo -e "${GREEN}[3/5] Deploying Scripts & Fixing Permissions...${NC}"

rm -rf "$SYSTEM_SCRIPT_DIR"
cp -rf "$REPO_DIR/scripts" "$SYSTEM_SCRIPT_DIR"

chmod 755 "$SYSTEM_SCRIPT_DIR"
find "$SYSTEM_SCRIPT_DIR" -type d -exec chmod 755 {} \;

find "$SYSTEM_SCRIPT_DIR" -name "*.sh" -exec chmod +x {} \;

chmod +x "$SYSTEM_SCRIPT_DIR/setup/install.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/set-wallpaper.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/powermenu.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/lock.sh"

chmod +x "$CONFIG_DIR/polybar/launch.sh"

echo "   -> Permissions successfully hardened."

echo -e "${GREEN}[4/5] Injecting Smart Shell Configuration...${NC}"
BASHRC="$HOME/.bashrc"

sed -i '/run_fastfetch/d' "$BASHRC"
sed -i '/fastfetch/d' "$BASHRC"
sed -i '/SMART FASTFETCH/d' "$BASHRC"

cat << 'EOF' >> "$BASHRC"

run_fastfetch_smart() {
    local width=$(tput cols)
    
    if [ "$width" -lt 60 ]; then
        return
    fi
    
    if [ ! -f "$HOME/.config/fastfetch/arch_logo.png" ]; then
        curl -sL "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Archlinux-icon-crystal-64.svg/1024px-Archlinux-icon-crystal-64.svg.png" -o "$HOME/.config/fastfetch/arch_logo.png"
    fi

    clear
    fastfetch
}

if [[ -x "$(command -v fastfetch)" && $- == *i* ]]; then
    run_fastfetch_smart
fi
EOF

echo -e "${GREEN}[5/5] Finalizing System...${NC}"

echo "   -> Adding user to 'video' and 'input' groups..."
sudo usermod -aG video,input $USER

echo "   -> Applying Theme..."
if [ -x "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ]; then
    "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ocean
else
    echo -e "${YELLOW}[WARN] Switch script not executable. Please check permissions manually.${NC}"
fi

echo ""
echo -e "${BLUE}======================================================${NC}"
echo -e "${GREEN}   INSTALLATION COMPLETE!   ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo -e "${YELLOW}IMPORTANT: Please REBOOT your system now to apply group changes.${NC}"