#!/bin/bash

# RECOVERY & RESTORE TOOL FOR ARCH I3WM X11 SETUP
# Jalankan ini jika sistem error/broken: ~/scripts/restore.sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== SYSTEM RECOVERY TOOL ===${NC}"
echo "1. Restore Backup Terakhir (dari ~/dotfiles_backup)"
echo "2. Re-Download & Re-Install (Clone Fresh Repo)"
echo "3. Exit"
echo -n "Pilihan Anda [1-3]: "
read choice

case $choice in
    1)
        LATEST_BACKUP=$(ls -td ~/dotfiles_backup/* | head -1)
        
        if [ -z "$LATEST_BACKUP" ]; then
            echo -e "${RED}[ERROR] Tidak ada backup ditemukan di ~/dotfiles_backup${NC}"
            exit 1
        fi
        
        echo -e "Restoring from: $LATEST_BACKUP ..."
        cp -rf "$LATEST_BACKUP/"* "$HOME/.config/"
        echo -e "${GREEN}[OK] Config restored. Silakan reboot atau reload i3.${NC}"
        ;;
    2)
        echo -e "Re-Cloning Repository..."
        cd "$HOME"
        rm -rf arch-i3wm-x11

        ping -c 1 google.com &> /dev/null
        if [ $? -ne 0 ]; then
            echo -e "${RED}[ERROR] Tidak ada internet. Gunakan 'nmtui' untuk connect WiFi.${NC}"
            exit 1
        fi
        
        git clone https://github.com/adrenaline404/arch-i3wm-x11.git
        cd arch-i3wm-x11
        chmod +x scripts/setup/install.sh
        ./scripts/setup/install.sh
        ;;
    3)
        exit 0
        ;;
    *)
        echo "Pilihan salah."
        ;;
esac