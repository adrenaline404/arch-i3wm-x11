#!/usr/bin/env bash

chosen=$(echo -e " Lock\n Logout\n Suspend\n Reboot\n Shutdown" | rofi -dmenu -i -p "Power Menu" \
    -theme-str 'window {width: 400px;}' \
    -theme-str 'listview {lines: 5;}')

case "$chosen" in
    *Lock) i3lock -c 000000 ;;
    *Logout) i3-msg exit ;;
    *Suspend) systemctl suspend ;;
    *Reboot) systemctl reboot ;;
    *Shutdown) systemctl poweroff ;;
esac