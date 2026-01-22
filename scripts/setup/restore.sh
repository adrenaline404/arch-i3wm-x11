#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== SYSTEM RECOVERY TOOL ===${NC}"
echo "1. Restore from Latest Backup"
echo "2. Re-Clone Repository and Reinstall"
echo "3. Exit"
echo -n "Choose an option [1-3]: "
read choice

case $choice in
    1)
        LATEST_BACKUP=$(ls -td ~/dotfiles_backup/* | head -1)
        
        if [ -z "$LATEST_BACKUP" ]; then
            echo -e "${RED}[ERROR] No backup found in ~/dotfiles_backup${NC}"
            exit 1
        fi
        
        echo -e "Restoring from: $LATEST_BACKUP ..."
        cp -rf "$LATEST_BACKUP/"* "$HOME/.config/"
        echo -e "${GREEN}[OK] Config restored. Please reboot or reload i3.${NC}"
        ;;
    2)
        echo -e "Re-Cloning Repository..."
        cd "$HOME"
        rm -rf arch-i3wm-x11

        ping -c 1 google.com &> /dev/null
        if [ $? -ne 0 ]; then
            echo -e "${RED}[ERROR] No internet connection. Use 'nmtui' to connect to WiFi.${NC}"
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
        echo "Invalid choice."
        ;;
esac