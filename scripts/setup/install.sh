#!/bin/bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}[INFO] Starting Installation (Zsh Edition)...${NC}"

if command -v yay &> /dev/null; then HELPER="yay"; elif command -v paru &> /dev/null; then HELPER="paru"; else
    echo -e "${RED}[ERROR] AUR helper (yay/paru) not found!${NC}"; exit 1
fi

echo -e "${GREEN}[1/7] Installing Packages...${NC}"

PKGS_SYSTEM="base-devel xorg-server xorg-xinit xorg-xrandr xorg-xset xorg-xrdb arandr xclip xdotool numlockx"

PKGS_I3="i3-wm polybar rofi dunst i3lock-color-git picom-git nitrogen feh brightnessctl"

PKGS_TERM="kitty zsh starship fastfetch bash-completion jq ripgrep bat lsd"

PKGS_FONTS="ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts-emoji ttf-nerd-fonts-symbols"

PKGS_THEME="lxappearance arc-gtk-theme papirus-icon-theme qt5ct"

PKGS_APPS="thunar thunar-archive-plugin thunar-volman file-roller gvfs gvfs-mtp flameshot pavucontrol network-manager-applet blueman firefox vlc"

PKGS_AUDIO="pipewire pipewire-pulse wireplumber alsa-utils"

$HELPER -S --needed --noconfirm --removemake $PKGS_SYSTEM $PKGS_I3 $PKGS_TERM $PKGS_FONTS $PKGS_THEME $PKGS_APPS $PKGS_AUDIO

echo -e "${GREEN}Refreshing Font Cache...${NC}"
fc-cache -fv > /dev/null

echo -e "${GREEN}[2/7] Setting up Zsh & Oh My Zsh...${NC}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "   -> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "   -> Oh My Zsh already installed."
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "   -> Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "   -> Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "   -> Changing default shell to Zsh (Password required)..."
    sudo usermod -s /usr/bin/zsh $USER
fi

REPO_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"

echo -e "${GREEN}[3/7] Deploying Configs...${NC}"
mkdir -p "$CONFIG_DIR"

CONFIG_LIST=("i3" "polybar" "picom" "rofi" "kitty" "dunst" "fastfetch")

for cfg in "${CONFIG_LIST[@]}"; do
    SOURCE="$REPO_DIR/.config/$cfg"
    TARGET="$CONFIG_DIR/$cfg"
    rm -rf "$TARGET"
    if [ -d "$SOURCE" ]; then cp -rf "$SOURCE" "$TARGET"; fi
done

if [ -f "$REPO_DIR/.config/starship.toml" ]; then
    cp "$REPO_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
fi

echo "   -> Deploying .zshrc..."
if [ -f "$REPO_DIR/.zshrc" ]; then
    cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"
else
    echo -e "${RED}[ERROR] .zshrc not found in repo!${NC}"
fi

mkdir -p "$CONFIG_DIR/kitty"
touch "$CONFIG_DIR/kitty/current-theme.conf"

echo -e "${GREEN}[4/7] Setting up Fastfetch Assets...${NC}"
FASTFETCH_DIR="$CONFIG_DIR/fastfetch"
mkdir -p "$FASTFETCH_DIR"

if [ ! -f "$FASTFETCH_DIR/blackarch_logo.png" ]; then
    echo "   -> Downloading BlackArch Logo..."
    curl -sL "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/BlackArch_Logo.svg/1024px-BlackArch_Logo.svg.png" -o "$FASTFETCH_DIR/blackarch_logo.png"
fi

echo -e "${GREEN}[5/7] Deploying Scripts...${NC}"
SYSTEM_SCRIPT_DIR="$HOME/scripts"
rm -rf "$SYSTEM_SCRIPT_DIR"
cp -rf "$REPO_DIR/scripts" "$SYSTEM_SCRIPT_DIR"

chmod 755 "$SYSTEM_SCRIPT_DIR"
find "$SYSTEM_SCRIPT_DIR" -name "*.sh" -exec chmod +x {} \;
chmod +x "$CONFIG_DIR/polybar/launch.sh"

echo -e "${GREEN}[6/7] Finalizing System...${NC}"

sudo usermod -aG video,input $USER

mkdir -p "$HOME/.config/gtk-3.0"
cat <<EOF > "$HOME/.config/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
EOF

if [ -x "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ]; then
    "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ocean
fi

echo -e ""
echo -e "${GREEN}[7/7] Installation Complete!${NC}"
echo -e "${YELLOW}Themes can be switched using the theme-switcher script located in ~/scripts/theme-switcher/${NC}"
echo -e "${YELLOW}Please restart your system to apply all changes.${NC}"
echo -e ""
echo -e "${RED}Github: https://github.com/adrenaline404/arch-i3wm-x11${NC}"
echo -e ""