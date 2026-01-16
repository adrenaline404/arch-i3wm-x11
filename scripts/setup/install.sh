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

echo -e "${BLUE}[INFO] Memulai Instalasi Fail-Safe + Fastfetch...${NC}"

if command -v yay &> /dev/null; then HELPER="yay"; elif command -v paru &> /dev/null; then HELPER="paru"; else
    echo -e "${RED}[ERROR] Install 'yay' atau 'paru' dulu!${NC}"; exit 1
fi

echo -e "${GREEN}[1/5] Installing Packages...${NC}"
CORE_PKGS="i3-wm polybar rofi alacritty dunst nitrogen thunar flameshot brightnessctl polkit-gnome starship jq libcanberra fastfetch"
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
        echo "   -> Backup $cfg ke $BACKUP_DIR/$cfg"
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
    if [ -d "$SOURCE" ]; then
        cp -rf "$SOURCE" "$TARGET"
    fi
done

echo -e "${GREEN}[4/5] Generating Professional Fastfetch Config...${NC}"
mkdir -p "$CONFIG_DIR/fastfetch"

cat <<EOF > "$CONFIG_DIR/fastfetch/config.jsonc"
{
  "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "small",
    "padding": {
      "top": 1,
      "left": 2
    }
  },
  "display": {
    "separator": "  ➜  ",
    "color": "cyan",
    "key": {
        "width": 15
    }
  },
  "modules": [
    "break",
    {
      "type": "title",
      "color": {
        "user": "green",
        "at": "red",
        "host": "blue"
      }
    },
    "break",
    { "type": "os", "key": "OS", "keyColor": "yellow" },
    { "type": "kernel", "key": "Kernel", "keyColor": "yellow" },
    { "type": "uptime", "key": "Uptime", "keyColor": "yellow" },
    "break",
    { "type": "packages", "key": "Packages", "keyColor": "blue" },
    { "type": "shell", "key": "Shell", "keyColor": "blue" },
    { "type": "terminal", "key": "Terminal", "keyColor": "blue" },
    { "type": "wm", "key": "WM", "keyColor": "blue" },
    "break",
    { "type": "cpu", "key": "CPU", "keyColor": "green" },
    { "type": "memory", "key": "Memory", "keyColor": "green" },
    { "type": "disk", "key": "Disk", "keyColor": "green" },
    "break",
    "colors"
  ]
}
EOF

# Inject Smart Logic ke .bashrc
BASHRC="$HOME/.bashrc"
if ! grep -q "SMART FASTFETCH" "$BASHRC"; then
    echo -e "\n   -> Injecting Smart Fastfetch to .bashrc..."
    cat <<'EOF' >> "$BASHRC"

run_fastfetch() {
    WIDTH=$(tput cols)
    if [ "$WIDTH" -lt 80 ]; then
        fastfetch --logo none --display-compact
    else
        fastfetch
    fi
}

if [[ -x "$(command -v fastfetch)" && $- == *i* ]]; then
    run_fastfetch
fi
EOF
else
    echo "   -> Smart Fastfetch logic already in .bashrc (Skipping)"
fi

echo -e "${GREEN}[5/5] Deploying Scripts to ~/scripts ...${NC}"
rm -rf "$SYSTEM_SCRIPT_DIR"
cp -rf "$REPO_DIR/scripts" "$SYSTEM_SCRIPT_DIR"

chmod +x "$SYSTEM_SCRIPT_DIR/setup/"*.sh
chmod +x "$SYSTEM_SCRIPT_DIR/theme-switcher/"*.sh
chmod +x "$SYSTEM_SCRIPT_DIR/utils/"*.sh

cp "$REPO_DIR/scripts/setup/restore.sh" "$SYSTEM_SCRIPT_DIR/restore.sh" 2>/dev/null || true
chmod +x "$SYSTEM_SCRIPT_DIR/restore.sh"

sudo usermod -aG video $USER

"$SYSTEM_SCRIPT_DIR/theme-switcher/switch.sh" ocean

echo -e "${BLUE}[DONE] Instalasi Selesai.${NC}"
echo -e "${BLUE}[INFO] Buka terminal baru untuk melihat Fastfetch.${NC}"
echo -e "${BLUE}[INFO] Jalankan 'i3-msg restart' atau reboot untuk menerapkan i3wm.${NC}"
echo -e "${BLUE}[INFO] Gunakan script di ~/scripts/theme-switcher/ untuk mengganti tema.${NC}"
echo -e "${BLUE}[INFO] Gunakan '~/scripts/restore.sh' untuk mengembalikan konfigurasi lama.${NC}"
echo -e "${BLUE}[INFO] By: @adrenaline404 - Selamat menikmati i3wm di Arch Linux!${NC}"