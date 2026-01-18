#!/bin/bash

set -e
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}[INFO] Starting Ultimate Installation...${NC}"

if command -v yay &> /dev/null; then HELPER="yay"; elif command -v paru &> /dev/null; then HELPER="paru"; else
    echo -e "${RED}[ERROR] Install 'yay' or 'paru' first!${NC}"; exit 1
fi

echo -e "${GREEN}[1/5] Installing Comprehensive Package List...${NC}"

PKGS_SYSTEM="base-devel xorg-server xorg-xinit xorg-xrandr xorg-xset xorg-xrdb arandr xclip xdotool numlockx"

PKGS_I3="i3-wm polybar rofi dunst i3lock-color-git picom-git nitrogen feh brightnessctl"

PKGS_TERM="kitty starship fastfetch bash-completion jq ripgrep bat lsd"

PKGS_FONTS="ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts-emoji ttf-nerd-fonts-symbols"

PKGS_THEME="lxappearance arc-gtk-theme papirus-icon-theme qt5ct"

PKGS_APPS="thunar thunar-archive-plugin thunar-volman file-roller gvfs gvfs-mtp flameshot pavucontrol network-manager-applet blueman firefox vlc"

PKGS_AUDIO="pipewire pipewire-pulse wireplumber alsa-utils"

$HELPER -S --needed --noconfirm --removemake $PKGS_SYSTEM $PKGS_I3 $PKGS_TERM $PKGS_FONTS $PKGS_THEME $PKGS_APPS $PKGS_AUDIO

echo -e "${GREEN}Refreshing Font Cache...${NC}"
fc-cache -fv > /dev/null

REPO_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"

echo -e "${GREEN}[2/5] Deploying Configs...${NC}"
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

mkdir -p "$CONFIG_DIR/kitty"
touch "$CONFIG_DIR/kitty/current-theme.conf"

echo -e "${GREEN}[3/5] Deploying Scripts...${NC}"
SYSTEM_SCRIPT_DIR="$HOME/scripts"
rm -rf "$SYSTEM_SCRIPT_DIR"
cp -rf "$REPO_DIR/scripts" "$SYSTEM_SCRIPT_DIR"

chmod 755 "$SYSTEM_SCRIPT_DIR"
find "$SYSTEM_SCRIPT_DIR" -name "*.sh" -exec chmod +x {} \;
chmod +x "$CONFIG_DIR/polybar/launch.sh"

echo -e "${GREEN}[4/5] Configuring Shell...${NC}"
BASHRC="$HOME/.bashrc"
sed -i '/fastfetch/d' "$BASHRC"
sed -i '/starship init/d' "$BASHRC"

cat << 'EOF' >> "$BASHRC"

eval "$(starship init bash)"

run_fastfetch_smart() {
    if [ "$(tput cols)" -ge 60 ]; then
        if [ ! -f "$HOME/.config/fastfetch/arch_logo.png" ]; then
             curl -sL "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Archlinux-icon-crystal-64.svg/1024px-Archlinux-icon-crystal-64.svg.png" -o "$HOME/.config/fastfetch/arch_logo.png"
        fi
        clear
        fastfetch
    fi
}
if [[ $- == *i* ]]; then run_fastfetch_smart; fi
EOF

echo -e "${GREEN}[5/5] Finalizing...${NC}"
sudo usermod -aG video,input $USER

mkdir -p "$HOME/.config/gtk-3.0"
cat <<EOF > "$HOME/.config/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

if [ -x "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ]; then
    "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ocean
fi

echo -e "${BLUE}[DONE] System Ready. REBOOT NOW.${NC}"