#!/bin/bash

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/arch-i3wm-install.log"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

clear
echo -e "${BLUE}>>> STARTING INSTALLER...${NC}"

log "Checking for conflicting packages..."
CONFLICTS=("i3lock" "rofi")
for pkg in "${CONFLICTS[@]}"; do
    if pacman -Qq "$pkg" &> /dev/null; then
        log "Removing conflicting package: $pkg..."
        sudo pacman -Rdd --noconfirm "$pkg"
    fi
done

if ! command -v yay &> /dev/null; then
    log "Installing yay..."
    sudo pacman -S --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$REPO_DIR" || exit
fi

log "Installing ALL required packages..."

PKGS_SYS="i3-wm polybar dunst picom nitrogen i3lock-color-git \
          xorg-server xorg-xinit xorg-xset xorg-xrandr xss-lock \
          polkit-gnome lxappearance qt5ct brightnessctl playerctl \
          network-manager-applet blueman pavucontrol flameshot \
          thunar thunar-archive-plugin file-roller gvfs gvfs-mtp unzip"

PKGS_SHELL="kitty zsh starship fastfetch eza bat ripgrep \
            zsh-syntax-highlighting zsh-autosuggestions"

PKGS_ROFI="rofi"

PKGS_FONTS="ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-font-awesome \
            noto-fonts-emoji ttf-material-design-icons-desktop-git \
            ttf-fira-code ttf-liberation"

PKGS_THEME="papirus-icon-theme arc-gtk-theme"

yay -Syu --noconfirm --needed $PKGS_SYS $PKGS_SHELL $PKGS_ROFI $PKGS_FONTS $PKGS_THEME

log "Deploying Configs..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.config"

for cfg in i3 polybar rofi kitty picom dunst fastfetch; do
    [ -d "$HOME/.config/$cfg" ] && mv "$HOME/.config/$cfg" "$BACKUP_DIR/"
done
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$BACKUP_DIR/"

cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
cp -r "$REPO_DIR/scripts" "$HOME/.config/i3/"
cp -r "$REPO_DIR/themes" "$HOME/.config/i3/"
cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"

log "Setting Permissions & Groups..."
chmod +x "$HOME/.config/i3/scripts/"*.sh
chmod +x "$HOME/.config/polybar/launch.sh"

sudo usermod -aG video "$USER"
sudo usermod -aG input "$USER"

log "Applying Void Red Theme..."
bash "$HOME/.config/i3/scripts/theme_switcher.sh" "void-red"

echo -e "${GREEN}INSTALLATION COMPLETE! REBOOT NOW.${NC}"