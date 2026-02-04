#!/bin/bash
OPTIONS="  Shutdown\n  Reboot\n  Suspend\n  Lock\n  Logout"
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Power" -theme ~/.config/rofi/config.rasi)

case "$CHOICE" in
    *Shutdown) poweroff ;;
    *Reboot) reboot ;;
    *Suspend) systemctl suspend ;;
    *Lock) ~/.config/i3/scripts/lock.sh ;;
    *Logout) i3-msg exit ;;
esac