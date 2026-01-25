#!/bin/bash

set -e
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}[INFO] Starting Installation...${NC}"

if command -v yay &> /dev/null; then HELPER="yay"; elif command -v paru &> /dev/null; then HELPER="paru"; else
    echo -e "${RED}[ERROR] Install 'yay' or 'paru' first!${NC}"; exit 1
fi

echo -e "${GREEN}[1/7] Installing Packages...${NC}"

# PACKAGE LIST
# SYSTEM UTILITIES & XORG
PKGS_SYSTEM="base-devel xorg-server xorg-xinit xorg-xrandr xorg-xset xorg-xrdb arandr xclip xdotool numlockx pacman-contrib bluez bluez-utils acpi"
# WINDOW MANAGER & DESKTOP
PKGS_I3="i3-wm polybar rofi dunst i3lock-color-git picom-git nitrogen feh brightnessctl"
# TERMINAL & SHELL
PKGS_TERM="kitty zsh starship fastfetch bash-completion jq ripgrep bat lsd"
# FONTS
PKGS_FONTS="ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts-emoji ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono"
# THEME & APPEARANCE
PKGS_THEME="lxappearance arc-gtk-theme papirus-icon-theme qt5ct"
# APPLICATIONS & TOOLS
PKGS_APPS="thunar thunar-archive-plugin thunar-volman tumbler ffmpegthumbnailer file-roller unzip p7zip gvfs gvfs-mtp flameshot pavucontrol network-manager-applet blueman firefox vlc imagemagick maim xss-lock libnotify polkit-gnome rofi-greenclip blueman playerctl dmenu"
# AUDIO
PKGS_AUDIO="pipewire pipewire-pulse wireplumber alsa-utils"

$HELPER -S --needed --noconfirm --removemake $PKGS_SYSTEM $PKGS_I3 $PKGS_TERM $PKGS_FONTS $PKGS_THEME $PKGS_APPS $PKGS_AUDIO
fc-cache -fv > /dev/null

echo -e "${GREEN}[2/7] Setting up Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    sudo usermod -s /usr/bin/zsh $USER
fi

echo -e "${GREEN}[3/7] Deploying Configs...${NC}"
REPO_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

CONFIG_LIST=("i3" "polybar" "picom" "rofi" "kitty" "dunst" "fastfetch")
for cfg in "${CONFIG_LIST[@]}"; do
    rm -rf "$CONFIG_DIR/$cfg"
    [ -d "$REPO_DIR/.config/$cfg" ] && cp -rf "$REPO_DIR/.config/$cfg" "$CONFIG_DIR/$cfg"
done

[ -f "$REPO_DIR/.config/starship.toml" ] && cp "$REPO_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
[ -f "$REPO_DIR/.zshrc" ] && cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"
mkdir -p "$CONFIG_DIR/kitty" && touch "$CONFIG_DIR/kitty/current-theme.conf"

echo -e "${GREEN}[4/7] Generating Assets...${NC}"
mkdir -p "$CONFIG_DIR/fastfetch"
cat <<EOF > "$CONFIG_DIR/fastfetch/arch_small.txt"
      /\\
     /  \\
    /    \\
   /      \\
  /   ,,   \\
 /   |  |   \\
/_-''    ''-_\\
EOF

echo -e "${GREEN}[5/7] Deploying Scripts & Permissions...${NC}"
SYSTEM_SCRIPT_DIR="$HOME/scripts"
rm -rf "$SYSTEM_SCRIPT_DIR"
cp -rf "$REPO_DIR/scripts" "$SYSTEM_SCRIPT_DIR"
chmod 755 "$SYSTEM_SCRIPT_DIR"
chmod -R +x "$SYSTEM_SCRIPT_DIR"

chmod +x "$SYSTEM_SCRIPT_DIR/setup/install.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/set-wallpaper.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/lock.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/powermenu.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/dashboard.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/screenshot.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/network-menu.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/caffeine.sh"
chmod +x "$SYSTEM_SCRIPT_DIR/utils/updates.sh"
chmod +x "$CONFIG_DIR/polybar/launch.sh"

sudo chown -R $USER:$USER "$CONFIG_DIR" "$SYSTEM_SCRIPT_DIR"

echo -e "${GREEN}[6/7] Finalizing...${NC}"
sudo usermod -aG video,input $USER

mkdir -p "$HOME/.config/gtk-3.0"
cat <<EOF > "$HOME/.config/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
EOF

if [ -x "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ]; then
    "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" black
fi

echo -e "${GREEN}[Refresh Font Cache]${NC}"
fc-cache -fv > /dev/null

echo -e ""
echo -e "${GREEN}[7/7] Installation Complete!${NC}"
echo -e "${BLUE}Github: https://github.com/adrenaline404/arch-i3wm-x11${NC}"
echo -e "${BLUE}Enjoy your new i3wm setup!${NC}"
echo -e "${GREEN}Reboot your system to apply all changes.${NC}"
echo -e ""