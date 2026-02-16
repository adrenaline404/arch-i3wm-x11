#!/bin/bash

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/arch-i3wm-install.log"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

show_header() {
    clear
    echo -e "${CYAN}"
    echo " █████╗ ██████╗  ██████╗██╗  ██╗       ██╗██████╗ ██╗    ██╗███╗   ███╗"
    echo "██╔══██╗██╔══██╗██╔════╝██║  ██║       ██║╚════██╗██║    ██║████╗ ████║"
    echo "███████║██████╔╝██║     ███████║█████╗ ██║ █████╔╝██║ █╗ ██║██╔████╔██║"
    echo "██╔══██║██╔══██╗██║     ██╔══██║╚════╝ ██║ ╚═══██╗██║███╗██║██║╚██╔╝██║"
    echo "██║  ██║██║  ██║╚██████╗██║  ██║       ██║██████╔╝╚███╔███╔╝██║ ╚═╝ ██║"
    echo "╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝       ╚═╝╚═════╝  ╚══╝╚══╝ ╚═╝     ╚═╝"
    echo -e "${NC}"
    echo -e "${BLUE}  >>> AUTOMATED INSTALLER & SETUP FOR ARCH LINUX (i3-wm)${NC}"
    echo -e "${BLUE}  >>> DEV: https://github.com/adrenaline404${NC}"
    echo " "
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
    read -p "Press Enter to continue (or Ctrl+C to abort)..."
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

    if [[ "$choice" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

install_pkg() {
    local category="$1"
    local pkgs="$2"

    log "Installing $category..."
    yay -S --noconfirm --needed $pkgs 2>> "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[OK] $category Installed.${NC}"
    else
        warn "Some packages in $category failed to install. Check log."
    fi
}

show_header
log "Checking internet connection..."
ping -c 1 8.8.8.8 &> /dev/null || { echo -e "${RED}No Internet Connection!${NC}"; exit 1; }

log "Checking AUR Helper (yay)..."
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}Yay not found. Installing base-devel & yay...${NC}"
    sudo pacman -S --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$REPO_DIR" || exit
fi

log "Checking for conflicting packages..."
CONFLICTS=("i3lock" "picom" "picom-ibhagwan-git")
for pkg in "${CONFLICTS[@]}"; do
    if pacman -Qq "$pkg" &> /dev/null; then
        warn "Removing conflict: $pkg"
        sudo pacman -Rdd --noconfirm "$pkg"
    fi
done

echo -e "\n${CYAN}>>> PACKAGE SELECTION${NC}"

PKGS_CORE="i3-wm polybar rofi dunst i3lock-color-git picom-git nitrogen xss-lock \
           xorg-server xorg-xinit xorg-xset xorg-xrandr \
           brightnessctl playerctl libcanberra libcanberra-gtk3 \
           network-manager-applet blueman pavucontrol flameshot jq xfce4-power-manager dmenu zenity imagemagick progress curl vlc \
           polkit-gnome lxappearance qt5ct \
           papirus-icon-theme arc-gtk-theme papirus-folders-git \
           neovim python-pynvim npm xclip ripgrep nano cava"
install_pkg "Core System (Window Manager & Utils)" "$PKGS_CORE"

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

if ask_user "Install Basic Dev Tools (Git, Python, VSCode-Bin)?" "Y"; then
    PKGS_DEV="git python python-pip visual-studio-code-bin \
              tk python-gobject python-cairo python-matplotlib python-pillow"
    install_pkg "Developer Tools" "$PKGS_DEV"
fi

echo -e "\n${CYAN}>>> CONFIGURATION DEPLOYMENT${NC}"
log "Backing up old configs to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.config"

CONFIGS=("i3" "polybar" "scripts" "themes" "picom" "dunst" "kitty" "rofi" "fastfetch")

for cfg in "${CONFIGS[@]}"; do
    if [ -d "$HOME/.config/$cfg" ]; then
        mv "$HOME/.config/$cfg" "$BACKUP_DIR/"
    fi
done
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$BACKUP_DIR/"

log "Copying new configurations..."
cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
cp -r "$REPO_DIR/scripts" "$HOME/.config/i3/"
cp -r "$REPO_DIR/themes" "$HOME/.config/i3/"
cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"

echo -e "\n${CYAN}>>> SYSTEM HARDENING & FIXES${NC}"

log "Setting Executable Permissions..."
chmod +x "$HOME/.config/i3/scripts/"*.sh
chmod +x "$HOME/.config/polybar/launch.sh"
chmod +x "$HOME/.config/i3/scripts/rofi_dashboard.sh" 2>/dev/null

log "Generating Dynamic Fastfetch Presets..."
bash "$REPO_DIR/scripts/setup_fastfetch.sh"

log "Creating Udev Rules for Backlight Control..."
echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"' | sudo tee /etc/udev/rules.d/90-backlight.rules > /dev/null
echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"' | sudo tee -a /etc/udev/rules.d/90-backlight.rules > /dev/null

log "Configuring Python Matplotlib Backend (Fix Freezing Issues)..."
mkdir -p "$HOME/.config/matplotlib"
echo "backend: TkAgg" > "$HOME/.config/matplotlib/matplotlibrc"
echo -e "${GREEN}[OK] Matplotlib configured to use TkAgg backend.${NC}"

log "Adding user to required groups..."
sudo usermod -aG video,input,storage,audio "$USER"

log "Changing Default Shell to Zsh..."
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
fi

log "Applying Default Theme (Void Red)..."
bash "$HOME/.config/i3/scripts/theme_switcher.sh" "void-red"

if [ -f "$HOME/.config/i3/scripts/lock_colors.rc" ]; then
    log "Lockscreen colors generated successfully."
else
    warn "Failed to generate lockscreen colors. Trying manual fallback..."
    echo 'LOCK_RING="#FF0000cc"' > "$HOME/.config/i3/scripts/lock_colors.rc"
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
echo " "
echo -e "${NC}"

read -p "Do you want to reboot now? [Y/n]: " reboot_choice
if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
    reboot
else
    echo "Please reboot manually later."
fi