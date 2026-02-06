#!/bin/bash

ROFI_CMD="rofi -dmenu -i -theme ~/.config/rofi/powermenu.rasi -p 'Power'"

OPTIONS="  Shutdown\n  Reboot\n  Suspend\n  Lock\n  Logout"

CHOICE=$(echo -e "$OPTIONS" | eval $ROFI_CMD)

case "$CHOICE" in
    *Shutdown) poweroff ;;
    *Reboot) reboot ;;
    *Suspend) systemctl suspend ;;
    *Lock) ~/.config/i3/scripts/lock.sh ;;
    *Logout) i3-msg exit ;;
esac