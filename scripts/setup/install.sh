#!/bin/bash

set -e
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_DIR="$(pwd)"
SYSTEM_SCRIPT_DIR="$HOME/scripts"
CONFIG_DIR="$HOME/.config"

echo -e "${BLUE}[INFO] Starting Installation...${NC}"

echo -e "${GREEN}[1/4] Deploying Configs...${NC}"
mkdir -p "$CONFIG_DIR"

CONFIG_LIST=("i3" "polybar" "picom" "rofi" "kitty" "dunst" "fastfetch")

for cfg in "${CONFIG_LIST[@]}"; do
    SOURCE="$REPO_DIR/.config/$cfg"
    TARGET="$CONFIG_DIR/$cfg"
    rm -rf "$TARGET"
    if [ -d "$SOURCE" ]; then cp -rf "$SOURCE" "$TARGET"; fi
done

echo "   -> Configuring Starship..."
if [ -f "$REPO_DIR/.config/starship.toml" ]; then
    cp "$REPO_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
fi

mkdir -p "$CONFIG_DIR/kitty"
touch "$CONFIG_DIR/kitty/current-theme.conf"

echo -e "${GREEN}[2/4] Deploying Scripts...${NC}"
rm -rf "$SYSTEM_SCRIPT_DIR"
cp -rf "$REPO_DIR/scripts" "$SYSTEM_SCRIPT_DIR"

chmod 755 "$SYSTEM_SCRIPT_DIR"
find "$SYSTEM_SCRIPT_DIR" -name "*.sh" -exec chmod +x {} \;

chmod +x "$CONFIG_DIR/polybar/launch.sh"

echo -e "${GREEN}[3/4] Updating .bashrc...${NC}"
BASHRC="$HOME/.bashrc"

sed -i '/fastfetch/d' "$BASHRC"
sed -i '/starship init/d' "$BASHRC"

cat << 'EOF' >> "$BASHRC"

eval "$(starship init bash)"

run_fastfetch_smart() {
    local width=$(tput cols)
    
    if [ "$width" -ge 60 ]; then
        if [ ! -f "$HOME/.config/fastfetch/arch_logo.png" ]; then
             curl -sL "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Archlinux-icon-crystal-64.svg/1024px-Archlinux-icon-crystal-64.svg.png" -o "$HOME/.config/fastfetch/arch_logo.png"
        fi
        
        clear
        fastfetch
    fi
}

if [[ $- == *i* ]]; then
    run_fastfetch_smart
fi
EOF

echo -e "${GREEN}[4/4] Finalizing...${NC}"

sudo usermod -aG video,input $USER

if [ -x "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ]; then
    "$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ocean
fi

echo -e "${BLUE}[DONE] System Updated. Please REBOOT now.${NC}"