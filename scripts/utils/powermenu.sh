#!/bin/bash
lock=""
logout=""
reboot=""
shutdown=""

options="$lock\n$logout\n$reboot\n$shutdown"
chosen="$(echo -e "$options" | rofi -theme ~/.config/rofi/powermenu.rasi -dmenu -selected-row 0 -p "Power")"

case $chosen in
    $lock) ~/arch-i3wm-x11/scripts/utils/lock.sh ;;
    $logout) i3-msg exit ;;
    $reboot) systemctl reboot ;;
    $shutdown) systemctl poweroff ;;
esac