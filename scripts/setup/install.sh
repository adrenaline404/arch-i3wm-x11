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
PKGS_SYSTEM="base-devel xorg-server xorg-xinit xorg-xrandr xorg-xset xorg-xrdb arandr xclip xdotool numlockx"
PKGS_I3="i3-wm polybar rofi dunst i3lock-color-git picom-git nitrogen feh brightnessctl"
PKGS_TERM="kitty zsh starship fastfetch bash-completion jq ripgrep bat lsd"
PKGS_FONTS="ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts-emoji ttf-nerd-fonts-symbols"
PKGS_THEME="lxappearance arc-gtk-theme papirus-icon-theme qt5ct"
PKGS_APPS="thunar thunar-archive-plugin thunar-volman file-roller gvfs gvfs-mtp flameshot pavucontrol network-manager-applet blueman firefox vlc"
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
    echo "   -> Changing shell to Zsh..."
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

echo -e "${GREEN}[4/7] Downloading Lain Iwakura Assets...${NC}"
FASTFETCH_DIR="$CONFIG_DIR/fastfetch"
mkdir -p "$FASTFETCH_DIR"

if [ ! -f "$FASTFETCH_DIR/lain_logo.png" ]; then
    echo "   -> Downloading Lain Logo..."
    curl -sL "https://upload.wikimedia.org/wikipedia/en/thumb/9/91/Serial_Experiments_Lain_DVD_vol_1.jpg/220px-Serial_Experiments_Lain_DVD_vol_1.jpg" -o "$FASTFETCH_DIR/lain_logo.png"
fi

echo -e "${GREEN}[5/7] Deploying Scripts...${NC}"
rm -rf "$HOME/scripts"
cp -rf "$REPO_DIR/scripts" "$HOME/scripts"
chmod 755 "$HOME/scripts"
find "$HOME/scripts" -name "*.sh" -exec chmod +x {} \;
chmod +x "$CONFIG_DIR/polybar/launch.sh"

echo -e "${GREEN}[6/7] Finalizing...${NC}"
sudo usermod -aG video,input $USER

mkdir -p "$HOME/.config/gtk-3.0"
cat <<EOF > "$HOME/.config/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
EOF

if [ -x "$HOME/scripts/theme-switcher/switch.sh" ]; then
    "$HOME/scripts/theme-switcher/switch.sh" ocean
fi

echo -e ""
echo -e "${BLUE}[DONE] System Ready. Reboot Now.${NC}"
echo -e "${RED}Github: https://github.com/adrenaline404/arch-i3wm-x11${NC}"
echo -e ""