#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOME/.config"
WALL="$HOME/Pictures"
BACKUP="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

info() {
    echo -e "${YELLOW}[*]${NC} $1"
}

info "Arch i3wm X11 installer"
info "Target: Asus X540LA (Intel Core i3-4005U, 4GB RAM)"

if ! command -v pacman >/dev/null 2>&1; then
    error "This script is designed for Arch Linux only"
    exit 1
fi

if [[ $EUID -eq 0 ]]; then
    error "Do not run this script as root"
    exit 1
fi

if ! sudo -n true 2>/dev/null; then
    info "This script requires sudo privileges"
    sudo -v
fi

PKGS=(
    xorg-server
    xorg-xinit
    xorg-xrandr
    i3-wm
    alacritty
    ttf-jetbrains-mono-nerd
    polybar
    rofi
    picom
    dunst
    feh
    pamixer
    pipewire
    pipewire-pulse
    pipewire-alsa
    pipewire-jack
    wireplumber
    brightnessctl
    playerctl
    maim
    xclip
    xsecurelock
    network-manager-applet
    blueman
    pavucontrol
)

info "Installing packages..."
for PKG in "${PKGS[@]}"; do
    if ! sudo pacman -S --needed --noconfirm "$PKG" >/dev/null 2>&1; then
        error "Failed to install $PKG"
        exit 1
    fi
done

info "Updating font cache..."
fc-cache -fv >/dev/null 2>&1 || true

info "Backing up existing configurations..."
mkdir -p "$BACKUP"
for d in i3 polybar rofi dunst picom; do
    if [[ -d "$CONFIG/$d" ]]; then
        cp -r "$CONFIG/$d" "$BACKUP/" 2>/dev/null || true
        success "Backed up $d"
    fi
done

info "Installing configurations..."
mkdir -p "$CONFIG"
if ! cp -r "$REPO_DIR/config/"* "$CONFIG/"; then
    error "Failed to copy configurations"
    exit 1
fi
success "Configurations installed"

info "Installing wallpapers..."
mkdir -p "$WALL"
if ! cp -r "$REPO_DIR/wallpaper/"* "$WALL/" 2>/dev/null; then
    error "Failed to copy wallpapers"
    exit 1
fi
success "Wallpapers installed"

info "Setting executable permissions..."
chmod +x \
    "$CONFIG/i3/autostart.sh" \
    "$CONFIG/i3/lock.sh" \
    "$CONFIG/i3/scripts/"*.sh \
    "$CONFIG/polybar/scripts/"*.sh \
    "$CONFIG/polybar/launch.sh" \
    "$CONFIG/rofi/theme-switcher.sh" \
    "$CONFIG/rofi/powermenu.sh" 2>/dev/null || true

if [[ -f "$CONFIG/udev/99-backlight.rules" ]]; then
    sudo cp "$CONFIG/udev/99-backlight.rules" /etc/udev/rules.d/99-backlight.rules 2>/dev/null || true
    sudo udevadm control --reload 2>/dev/null || true
    sudo udevadm trigger 2>/dev/null || true
    success "Installed udev backlight rule (if permitted)"
fi

THEME_STATE="$CONFIG/.theme_state"
if [[ ! -f "$THEME_STATE" ]]; then
    echo "catppuccin" > "$THEME_STATE"
fi

info "Configuring PipeWire..."
if systemctl --user is-enabled pipewire &>/dev/null 2>&1; then
    success "PipeWire user service already enabled"
else
    systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
    success "PipeWire user services enabled"
fi

if systemctl is-enabled lightdm &>/dev/null 2>&1; then
    success "LightDM is enabled"
else
    info "LightDM is not enabled. Enable it with: sudo systemctl enable lightdm"
fi

if [[ -d /sys/class/backlight/intel_backlight ]]; then
    success "Intel backlight detected"
else
    info "Intel backlight not found. Checking alternatives..."
    if [[ -d /sys/class/backlight/acpi_video0 ]]; then
        info "Found acpi_video0, you may need to adjust brightness script"
    fi
fi

if [[ -d /sys/class/power_supply ]]; then
    ADAPTER=$(ls /sys/class/power_supply/ | grep -i "^AC" | head -n1)
    if [[ -n "$ADAPTER" ]]; then
        info "Battery adapter detected: $ADAPTER"
        info "Update polybar config if adapter name differs from 'AC'"
    fi
fi

success "Installation complete!"
info "Backup location: $BACKUP"
info ""
info "Next steps:"
info "1. Logout and select i3 session in LightDM"
info "2. Or run: startx (if not using LightDM)"
info "3. Default theme: catppuccin"
info "4. Switch themes with: Super+Shift+T or ~/.config/rofi/theme-switcher.sh"
info "5. PipeWire is configured and will start automatically"
info "Setup complete. Enjoy your Arch i3wm environment!"