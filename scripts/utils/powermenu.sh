#!/bin/bash

lock="  Lock Screen"
logout="  Logout"
shutdown="  Shutdown"
reboot="  Reboot"
sleep="  Suspend"

selected_option=$(echo "$lock
$logout
$sleep
$reboot
$shutdown" | rofi -dmenu \
                  -i \
                  -p "System Power" \
                  -theme "~/.config/rofi/powermenu.rasi")

case "$selected_option" in
    "$lock")
        "$HOME/scripts/utils/lock.sh"
        ;;
    "$logout")
        i3-msg exit
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$sleep")
        amixer set Master mute
        systemctl suspend
        ;;
    *)
        echo "No match"
        ;;
esac