#!/bin/bash

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
LOG_FILE="/tmp/arch-i3wm-install.log"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Flags
USE_SYMLINK=false
DRY_RUN=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

#  UTILITY FUNCTIONS

show_header() {
    clear
    echo -e "${CYAN}"
    echo " ARCH • I3WM • X11"
    echo " ╭──────────────────────────────────╮"
    echo " │  Stack     :  Arch Linux + i3wm  │"
    echo " │  Display   :  X11 (Xorg)         │"
    echo " │  Paradigm  :  Tiling WM          │"
    echo " ╰──────────────────────────────────╯"
    echo -e "${NC}"
    echo -e "${BLUE} // AUTOMATED INSTALLER & SETUP FOR ARCH LINUX${NC}"
    echo -e "${RED} // DEV: adrenaline404${NC}"
    echo ""
}

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
    echo "[INFO] $(date): $1" >> "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    echo "[WARN] $(date): $1" >> "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "[ERROR] $(date): $1" >> "$LOG_FILE"
    exit 1
}

ask_user() {
    local prompt="$1"
    local default="$2"
    local choice

    if [ "$default" == "Y" ]; then
        echo -ne "${GREEN}?? $prompt [Y/n]: ${NC}"
        read choice
        choice=${choice:-Y}
    else
        echo -ne "${YELLOW}?? $prompt [y/N]: ${NC}"
        read choice
        choice=${choice:-N}
    fi

    [[ "$choice" =~ ^[Yy]$ ]]
}

install_pkg() {
    local category="$1"
    local pkgs="$2"

    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Skipping install for $category: $pkgs"
        return 0
    fi

    log "Installing $category..."
    yay -S --noconfirm --needed $pkgs 2>> "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[OK] $category Installed.${NC}"
    else
        warn "Some packages in $category failed to install. Check log at $LOG_FILE."
    fi
}

deploy_config() {
    local src="$1"
    local dest="$2"
    
    local dest_dir=$(dirname "$dest")
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$dest_dir"
    fi

    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Deploy: $src -> $dest"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local base_name=$(basename "$dest")
        if [[ "$dest" != "$BACKUP_DIR"* ]]; then
            cp -r "$dest" "$BACKUP_DIR/${base_name}_old"
        fi
        rm -rf "$dest"
    fi

    if [ "$USE_SYMLINK" = true ]; then
        ln -sf "$src" "$dest"
        log "Symlinked: $src -> $dest"
    else
        cp -r "$src" "$dest"
        log "Copied: $src -> $dest"
    fi
}

#  MAIN EXECUTION

# Argument Parsing
for arg in "$@"; do
    case $arg in
        --link) USE_SYMLINK=true ;;
        --dry-run) DRY_RUN=true ;;
    esac
done

show_header

# PRE-FLIGHT CHECKS
log "Checking internet connection..."
ping -c 1 8.8.8.8 &> /dev/null || error "No Internet Connection!"

log "Checking sudo access..."
if ! sudo -v; then
    error "Sudo access required for system configuration."
fi
# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

log "Preparing Backup Directory..."
if [ "$DRY_RUN" = false ]; then
    mkdir -m 700 -p "$BACKUP_DIR"
    log "Backup location: $BACKUP_DIR"
fi

# AUR HELPER (YAY)
log "Checking AUR Helper (yay)..."
if ! command -v yay &> /dev/null && [ "$DRY_RUN" = false ]; then
    echo -e "${YELLOW}Yay not found. Installing base-devel & yay...${NC}"
    sudo pacman -S --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$REPO_DIR" || exit
fi

# CONFLICT HANDLING
log "Checking for conflicting packages..."
if [ "$DRY_RUN" = false ]; then
    CONFLICTS=("i3lock" "picom" "picom-ibhagwan-git")
    for pkg in "${CONFLICTS[@]}"; do
        if pacman -Qq "$pkg" &> /dev/null; then
            warn "Removing conflict: $pkg"
            sudo pacman -Rdd --noconfirm "$pkg"
        fi
    done
fi

# PACKAGE INSTALLATION
echo -e "\n${CYAN}>>> PACKAGE SELECTION${NC}"

# Core
PKGS_CORE="i3-wm polybar rofi dunst i3lock-color-git picom-git nitrogen xss-lock \
           xorg-server xorg-xinit xorg-xset xorg-xrandr \
           brightnessctl playerctl libcanberra libcanberra-gtk3 \
           network-manager-applet blueman pavucontrol flameshot jq xfce4-power-manager dmenu zenity imagemagick progress curl vlc feh xed cava htop \
           polkit-gnome lxappearance qt5ct \
           papirus-icon-theme arc-gtk-theme papirus-folders-git \
           neovim python-pynvim npm xclip ripgrep nano python-pywal less tree bat fd"

install_pkg "Core System (WM, Utils & Rice Tools)" "$PKGS_CORE"

if ask_user "Install Modern Terminal Environment (Kitty, Zsh, Starship, Fastfetch)?" "Y"; then
    PKGS_TERM="kitty zsh starship fastfetch eza bat zsh-syntax-highlighting zsh-autosuggestions fzf"
    install_pkg "Terminal Tools" "$PKGS_TERM"
fi

if ask_user "Install Mega Font Pack (Coding, Emoji, CJK Support)?" "Y"; then
    PKGS_FONTS="ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols \
                ttf-fira-code ttf-hack-nerd ttf-cascadia-code ttf-ibm-plex \
                noto-fonts-emoji noto-fonts-cjk ttf-font-awesome \
                ttf-material-design-icons-desktop-git"
    install_pkg "Fonts" "$PKGS_FONTS"
fi

if ask_user "Install File Manager Tools (Thunar + Archive Support)?" "Y"; then
    PKGS_FILE="thunar thunar-archive-plugin thunar-volman file-roller gvfs gvfs-mtp unzip p7zip unrar"
    install_pkg "File Management" "$PKGS_FILE"
fi

if ask_user "Install Web Browser (Firefox)?" "Y"; then
    install_pkg "Firefox" "firefox"
fi

if ask_user "Install Web Browser (Chromium)? (Optional)" "N"; then
    install_pkg "Chromium" "chromium"
fi

if ask_user "Install Web Browser (Brave)? (Optional)" "N"; then
    install_pkg "Brave" "brave-bin"
fi

if ask_user "Install Basic Dev Tools (Git, Python, VSCode-Bin)?" "Y"; then
    PKGS_DEV="git python python-pip visual-studio-code-bin \
              tk python-gobject python-cairo python-matplotlib python-pillow"
    install_pkg "Developer Tools" "$PKGS_DEV"
fi

# CONFIGURATION DEPLOYMENT
echo -e "\n${CYAN}>>> CONFIGURATION DEPLOYMENT${NC}"

# Deploy standard configs from configs/ folder
# Mapped: configs/folder -> ~/.config/folder
for dir in "$REPO_DIR/configs"/*; do
    if [ -d "$dir" ] || [ -f "$dir" ]; then
        base_name=$(basename "$dir")
        deploy_config "$dir" "$HOME/.config/$base_name"
    fi
done

# Deploy Zshrc
deploy_config "$REPO_DIR/.zshrc" "$HOME/.zshrc"

# Deploy i3 Scripts & Themes
# Mapped: scripts/ -> ~/.config/i3/scripts
# Mapped: themes/  -> ~/.config/i3/themes
deploy_config "$REPO_DIR/scripts" "$HOME/.config/i3/scripts"
deploy_config "$REPO_DIR/themes" "$HOME/.config/i3/themes"


# SYSTEM HARDENING & FIXES
echo -e "\n${CYAN}>>> SYSTEM HARDENING & FIXES${NC}"

if [ "$DRY_RUN" = false ]; then
    log "Setting Executable Permissions..."
    chmod +x "$HOME/.config/i3/scripts/"*.sh
    chmod +x "$HOME/.config/polybar/launch.sh"
    chmod +x "$HOME/.config/i3/scripts/rofi_dashboard.sh" 2>/dev/null
    
    # Permission for python scripts
    if [ -f "$HOME/.config/i3/scripts/theme_builder.py" ]; then
        chmod +x "$HOME/.config/i3/scripts/theme_builder.py"
    fi

    log "Generating Dynamic Fastfetch Presets..."
    bash "$HOME/.config/i3/scripts/setup_fastfetch.sh"

    log "Creating Udev Rules for Backlight Control..."
    echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"' | sudo tee /etc/udev/rules.d/90-backlight.rules > /dev/null
    echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"' | sudo tee -a /etc/udev/rules.d/90-backlight.rules > /dev/null
    sudo udevadm control --reload-rules
    sudo udevadm trigger

    log "Configuring Python Matplotlib Backend..."
    mkdir -p "$HOME/.config/matplotlib"
    echo "backend: TkAgg" > "$HOME/.config/matplotlib/matplotlibrc"

    log "Adding user to required groups..."
    sudo usermod -aG video,input,storage,audio "$USER"

    log "Changing Default Shell to Zsh..."
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        chsh -s /usr/bin/zsh
    fi

    log "Applying Default Theme (Void Red)..."
    bash "$HOME/.config/i3/scripts/theme_switcher.sh" "void-red"
else
    log "[DRY-RUN] Skipping permissions, udev rules, and shell changes."
fi

echo -e "${GREEN}"
echo " "
echo "   INSTALLATION SUCCESSFUL!"
echo "   Developer: adrenaline404"
echo " "
echo "   [!] IMPORTANT:"
echo "   1. A reboot is REQUIRED for brightness & group permissions to work."
echo "   2. Select 'i3' session at login screen."
echo "   3. Backup of your old configs is at: $BACKUP_DIR"
echo "   4. First boot will prompt for default browser setup."
echo " "
echo -e "${NC}"

if ask_user "Do you want to reboot now?" "N"; then
    reboot
else
    echo "Please reboot manually later."
fi