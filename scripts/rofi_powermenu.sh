#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/powermenu.rasi"

OPTIONS="   Shutdown\n   Reboot\n   Suspend\n   Lock\n   Logout"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -theme "$ROFI_THEME" -p "System Power")

case "$CHOICE" in
    *Shutdown) poweroff ;;
    *Reboot) reboot ;;
    *Suspend) systemctl suspend ;;
    *Lock) ~/.config/i3/scripts/lock.sh ;;
    *Logout) i3-msg exit ;;
esac