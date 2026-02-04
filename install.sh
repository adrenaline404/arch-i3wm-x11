REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/arch-i3wm-install.log"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
I3_CONFIG_DIR="$HOME/.config/i3"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

log "Checking for conflicting packages..."
if pacman -Qq i3lock &> /dev/null; then
    log "Removing conflicting package: i3lock..."
    sudo pacman -Rdd --noconfirm i3lock
fi

log "Installing System Packages..."

if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$REPO_DIR" || exit
fi

PKGS="i3-wm polybar rofi dunst kitty picom nitrogen feh i3lock-color-git \
      polkit-gnome lxappearance qt5ct brightnessctl playerctl \
      zsh starship fastfetch eza bat ripgrep \
      thunar thunar-archive-plugin thunar-volman file-roller unzip \
      gvfs gvfs-mtp network-manager-applet blueman pavucontrol flameshot \
      ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-font-awesome \
      noto-fonts-emoji ttf-material-design-icons-desktop-git \
      papirus-icon-theme arc-gtk-theme"

yay -Syu --noconfirm --needed $PKGS

log "Backing up & Deploying..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.config"

for cfg in i3 polybar rofi kitty picom dunst fastfetch; do
    [ -d "$HOME/.config/$cfg" ] && mv "$HOME/.config/$cfg" "$BACKUP_DIR/"
done
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$BACKUP_DIR/"

cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
cp -r "$REPO_DIR/scripts" "$I3_CONFIG_DIR/"
cp -r "$REPO_DIR/themes" "$I3_CONFIG_DIR/"
cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"

log "Setting Permissions..."
chmod +x "$I3_CONFIG_DIR/scripts/"*.sh
chmod +x "$HOME/.config/polybar/launch.sh"

bash "$I3_CONFIG_DIR/scripts/theme_switcher.sh" "void-red"

echo -e "${GREEN}INSTALLATION COMPLETE! PLEASE REBOOT.${NC}"