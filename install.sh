#!/bin/bash

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOG_FILE="/tmp/arch-i3wm-install.log"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_TARGET="$HOME/.config"
I3_CONFIG_DIR="$HOME/.config/i3"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; echo "[$(date)] $1" >> "$LOG_FILE"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; echo "[WARN] $1" >> "$LOG_FILE"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; echo "[ERROR] $1" >> "$LOG_FILE"; exit 1; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

clear
echo -e "${BLUE}"
echo "   ___   ___  ___ _  _    _ ____      ____  __   __  _1 "
echo "  / _ \ | _ \/ __| || |  (_)__ /__ __|__  \/  \ /  \/ |"
echo " / /_\ \|   / (__| __ |  | ||_ \ \ \ / / // () | () | |"
echo "/_/   \_\_|_\\___|_||_|  |_|___/  \_/ /_/ \__/ \__/|_|"
echo "                                  INSTALLER"
echo -e "${NC}"
sleep 2

log "Checking system requirements..."

[ -d "$REPO_DIR/configs" ] || error "Folder 'configs' hilang!"
[ -d "$REPO_DIR/scripts" ] || error "Folder 'scripts' hilang!"
[ -d "$REPO_DIR/themes" ] || error "Folder 'themes' hilang!"
[ -f "$REPO_DIR/.zshrc" ] || warn "File '.zshrc' tidak ditemukan di root repo (Terminal akan default)."

ping -c 1 8.8.8.8 &> /dev/null || error "Tidak ada koneksi internet."

log "Installing Packages..."

# Install Base-Devel & Git
if ! pacman -Qi base-devel &> /dev/null; then
    log "Installing base-devel & git..."
    sudo pacman -S --noconfirm base-devel git
fi

# Install Yay (AUR Helper)
if ! command -v yay &> /dev/null; then
    log "Yay tidak ditemukan. Menginstall yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$REPO_DIR" || exit
fi

# System & UI
PKGS_SYS="i3-wm polybar rofi dunst kitty picom nitrogen feh i3lock-color-git \
          polkit-gnome lxappearance qt5ct brightnessctl playerctl"
# Shell & Terminal
PKGS_SHELL="zsh starship fastfetch eza bat ripgrep"
# Utils & Network
PKGS_UTILS="thunar thunar-archive-plugin thunar-volman file-roller unzip \
            gvfs gvfs-mtp network-manager-applet blueman pavucontrol flameshot"
# Fonts
PKGS_FONTS="ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-font-awesome \
            noto-fonts-emoji ttf-material-design-icons-desktop-git"
# Themes
PKGS_THEME="papirus-icon-theme arc-gtk-theme"

log "Updating System & Installing Packages..."
yay -Syu --noconfirm --needed $PKGS_SYS $PKGS_SHELL $PKGS_UTILS $PKGS_FONTS $PKGS_THEME 2>&1 | tee -a "$LOG_FILE"

log "Melakukan Backup config lama ke: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

CONFIGS=("i3" "polybar" "rofi" "kitty" "picom" "dunst" "fastfetch")
for cfg in "${CONFIGS[@]}"; do
    if [ -d "$CONFIG_TARGET/$cfg" ]; then
        mv "$CONFIG_TARGET/$cfg" "$BACKUP_DIR/"
        success "Backed up $cfg"
    fi
done

[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$BACKUP_DIR/"
[ -f "$HOME/.config/starship.toml" ] && mv "$HOME/.config/starship.toml" "$BACKUP_DIR/"

log "Menerapkan Konfigurasi Baru..."

mkdir -p "$CONFIG_TARGET"
mkdir -p "$I3_CONFIG_DIR"

cp -r "$REPO_DIR/configs/"* "$CONFIG_TARGET/"

cp -r "$REPO_DIR/scripts" "$I3_CONFIG_DIR/"
cp -r "$REPO_DIR/themes" "$I3_CONFIG_DIR/"

if [ -f "$REPO_DIR/.zshrc" ]; then
    cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"
    success "Zsh config deployed."
fi

if [ -f "$REPO_DIR/configs/fastfetch.jsonc" ]; then
    mkdir -p "$HOME/.config/fastfetch"
    cp "$REPO_DIR/configs/fastfetch.jsonc" "$HOME/.config/fastfetch/config.jsonc"
fi

log "Mengatur Izin Eksekusi & Service..."

chmod +x "$I3_CONFIG_DIR/scripts/"*.sh
chmod +x "$CONFIG_TARGET/polybar/launch.sh"
[ -f "$I3_CONFIG_DIR/scripts/lock.sh" ] && chmod +x "$I3_CONFIG_DIR/scripts/lock.sh"

sudo systemctl enable --now bluetooth.service 2>/dev/null || warn "Bluetooth service skipped."

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    log "Changing default shell to Zsh..."
    chsh -s /usr/bin/zsh
fi

log "Mengaktifkan Tema Default (Void Red)..."

if [ -f "$I3_CONFIG_DIR/scripts/theme_switcher.sh" ]; then
    bash "$I3_CONFIG_DIR/scripts/theme_switcher.sh" "void-red"
else
    error "Script Theme Switcher tidak ditemukan!"
fi

echo -e "${GREEN}"
echo "======================================================="
echo "   INSTALLATION COMPLETE!"
echo "   Config Backup: $BACKUP_DIR"
echo "   Log File: $LOG_FILE"
echo ""
echo "   --> REBOOT SYSTEM NOW! <--"
echo "======================================================="
echo -e "${NC}"