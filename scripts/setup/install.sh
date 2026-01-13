#!/bin/bash

# Arch i3wm X11 Installation Script

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Arch i3wm X11 Setup Installation${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}Please do not run as root${NC}"
    exit 1
fi

echo -e "${YELLOW}[1/8] Updating system...${NC}"
sudo pacman -Syu --noconfirm

echo -e "${YELLOW}[2/8] Installing base packages...${NC}"
sudo pacman -S --needed --noconfirm \
    i3-wm i3lock i3status \
    picom \
    polybar \
    rofi \
    alacritty \
    dunst \
    nitrogen \
    lightdm lightdm-gtk-greeter \
    xorg xorg-xinit xorg-xrandr xorg-xrdb \
    ttf-jetbrains-mono-nerd \
    papirus-icon-theme \
    network-manager-applet \
    blueman \
    pavucontrol \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
    wireplumber \
    thunar thunar-archive-plugin thunar-media-tags-plugin \
    file-roller \
    flameshot \
    brightnessctl \
    numlockx \
    xss-lock \
    xfce4-power-manager \
    polkit-gnome \
    lxappearance \
    gtk-engine-murrine \
    gnome-themes-extra

echo -e "${YELLOW}[3/8] Checking for AUR helper...${NC}"
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
fi

echo -e "${YELLOW}[4/8] Installing AUR packages...${NC}"
yay -S --needed --noconfirm \
    picom-jonaburg-git \
    starship

echo -e "${YELLOW}[5/8] Enabling LightDM...${NC}"
sudo systemctl enable lightdm.service

echo -e "${YELLOW}[6/8] Creating directories...${NC}"
mkdir -p ~/.config
mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/.local/share/fonts

echo -e "${YELLOW}[7/8] Backing up existing configurations...${NC}"
BACKUP_DIR=~/.config_backup_$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"

for dir in i3 picom polybar rofi alacritty dunst starship; do
    if [ -d ~/.config/$dir ]; then
        echo "Backing up $dir..."
        cp -r ~/.config/$dir "$BACKUP_DIR/"
    fi
done

echo -e "${YELLOW}[8/8] Installing dotfiles...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cp -r "$SCRIPT_DIR/.config/"* ~/.config/
cp "$SCRIPT_DIR/.Xresources" ~/
cp "$SCRIPT_DIR/.xinitrc" ~/
cp -r "$SCRIPT_DIR/themes" ~/
cp -r "$SCRIPT_DIR/scripts" ~/

chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/rofi/scripts/*.sh
chmod +x ~/scripts/theme-switcher/switch-theme.sh

echo -e "${YELLOW}Setting default theme to black...${NC}"
~/scripts/theme-switcher/switch-theme.sh black

echo -e "${YELLOW}Configuring GTK theme...${NC}"
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=rgb
EOF

echo 'eval "$(starship init bash)"' >> ~/.bashrc

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Reboot your system"
echo "2. Login through LightDM"
echo "3. Press Super+Enter to open terminal"
echo "4. Switch themes using: ~/scripts/theme-switcher/switch-theme.sh [black|ocean]"
echo ""
echo -e "${YELLOW}Key bindings:${NC}"
echo "Super+Enter        - Terminal"
echo "Super+d            - Application launcher"
echo "Super+Shift+e      - Power menu"
echo "Super+q            - Close window"
echo "Super+f            - Fullscreen"
echo "Super+Shift+Space  - Toggle floating"
echo "Super+1-0          - Switch workspace"
echo "Print              - Screenshot (area)"
echo ""
echo -e "${GREEN}Enjoy your new setup!${NC}"
echo -e "${RED}If you encounter any issues, please refer to the documentation or seek help from the community.${NC}"
echo ""