#!/bin/bash

set -e
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="$(pwd)"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
SYSTEM_SCRIPT_DIR="$HOME/scripts"
CONFIG_DIR="$HOME/.config"

echo -e "${BLUE}[INFO] ! Memulai Instalasi...${NC}"

if command -v yay &> /dev/null; then HELPER="yay"; elif command -v paru &> /dev/null; then HELPER="paru"; else
    echo -e "${RED}[ERROR] Install 'yay' atau 'paru' dulu!${NC}"; exit 1
fi

echo -e "${GREEN}[1/5] Installing Packages...${NC}"
CORE_PKGS="i3-wm polybar rofi alacritty dunst nitrogen thunar flameshot brightnessctl polkit-gnome starship jq libcanberra fastfetch xorg-xrandr arandr"
VISUAL_PKGS="picom-git i3lock-color-git lxappearance"
FONT_PKGS="ttf-jetbrains-mono-nerd noto-fonts-emoji ttf-font-awesome ttf-nerd-fonts-symbols"
AUDIO_PKGS="pipewire pipewire-pulse wireplumber pavucontrol"

$HELPER -S --needed --noconfirm --answerdiff=None --answerclean=None --removemake $CORE_PKGS $VISUAL_PKGS $FONT_PKGS $AUDIO_PKGS

fc-cache -fv > /dev/null

echo -e "${GREEN}[2/5] Backing up existing configs...${NC}"
mkdir -p "$BACKUP_DIR"
CONFIGS=("i3" "polybar" "picom" "rofi" "alacritty" "dunst" "starship" "fastfetch")

for cfg in "${CONFIGS[@]}"; do
    if [ -d "$HOME/.config/$cfg" ]; then
        cp -r "$HOME/.config/$cfg" "$BACKUP_DIR/"
    fi
done

echo -e "${GREEN}[3/5] Deploying Configs (Hard Copy)...${NC}"
mkdir -p "$CONFIG_DIR"

for cfg in "${CONFIGS[@]}"; do
    if [ "$cfg" == "fastfetch" ]; then continue; fi
    SOURCE="$REPO_DIR/.config/$cfg"
    TARGET="$CONFIG_DIR/$cfg"
    rm -rf "$TARGET"
    if [ -d "$SOURCE" ]; then cp -rf "$SOURCE" "$TARGET"; fi
done

echo -e "${GREEN}[4/5] Generating Fastfetch Config...${NC}"
mkdir -p "$CONFIG_DIR/fastfetch"
cat <<EOF > "$CONFIG_DIR/fastfetch/config.jsonc"
{
  "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": { "type": "small", "padding": { "top": 1, "left": 2 } },
  "display": { "separator": "  ➜  ", "color": "cyan", "key": { "width": 15 } },
  "modules": [
    "break",
    { "type": "title", "color": { "user": "green", "at": "red", "host": "blue" } },
    "break",
    { "type": "os", "key": "OS", "keyColor": "yellow" },
    { "type": "kernel", "key": "Kernel", "keyColor": "yellow" },
    { "type": "uptime", "key": "Uptime", "keyColor": "yellow" },
    "break",
    { "type": "packages", "key": "Packages", "keyColor": "blue" },
    { "type": "wm", "key": "WM", "keyColor": "blue" },
    "break",
    { "type": "cpu", "key": "CPU", "keyColor": "green" },
    { "type": "memory", "key": "Memory", "keyColor": "green" },
    "break",
    "colors"
  ]
}
EOF

# Inject Smart Logic ke .bashrc
BASHRC="$HOME/.bashrc"
if ! grep -q "SMART FASTFETCH" "$BASHRC"; then
    cat <<'EOF' >> "$BASHRC"
# --- SMART FASTFETCH ---
run_fastfetch() {
    WIDTH=$(tput cols)
    if [ "$WIDTH" -lt 80 ]; then fastfetch --logo none --display-compact
    else fastfetch; fi
}
if [[ -x "$(command -v fastfetch)" && $- == *i* ]]; then run_fastfetch; fi
EOF
fi

echo -e "${GREEN}[5/5] Deploying Scripts to ~/scripts ...${NC}"
rm -rf "$SYSTEM_SCRIPT_DIR"
cp -rf "$REPO_DIR/scripts" "$SYSTEM_SCRIPT_DIR"

echo "   -> Fixing execution permissions..."
find "$SYSTEM_SCRIPT_DIR" -name "*.sh" -exec chmod +x {} \;

cp "$REPO_DIR/scripts/setup/restore.sh" "$SYSTEM_SCRIPT_DIR/restore.sh" 2>/dev/null || true
chmod +x "$SYSTEM_SCRIPT_DIR/restore.sh"

sudo usermod -aG video $USER

"$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ocean

echo -e "${BLUE}----------------------------------------------------------------------${NC}"
echo -e "${BLUE}[DONE] Instalasi Selesai.${NC}"
echo -e "${BLUE}    - Backup configs di: ${BACKUP_DIR}${NC}"
echo -e "${BLUE}    - Jalankan 'restore.sh' dari ~/scripts untuk mengembalikan backup.${NC}"
echo -e "${BLUE}    - Reboot sistem untuk memastikan semua perubahan diterapkan.${NC}"
echo -e "${BLUE}    - Enjoy your i3wm setup!${NC}"
echo -e "${BLUE}    - Script by GitHub.com/adrenaline404${NC}"
echo -e "${BLUE}----------------------------------------------------------------------${NC}"