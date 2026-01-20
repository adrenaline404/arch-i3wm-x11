#!/bin/bash

lock=""
logout=""
reboot=""
shutdown=""

rofi_cmd() {
	rofi -dmenu \
		-p "Power" \
		-theme ~/.config/rofi/powermenu.rasi
}

run_cmd() {
	if [[ $1 == "--lock" ]]; then
		"$HOME/scripts/utils/lock.sh"
	elif [[ $1 == "--logout" ]]; then
		i3-msg exit
	elif [[ $1 == "--reboot" ]]; then
		systemctl reboot
	elif [[ $1 == "--shutdown" ]]; then
		systemctl poweroff
	fi
}

chosen="$(echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd)"

case ${chosen} in
    $lock)
		run_cmd --lock
        ;;
    $logout)
		run_cmd --logout
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $shutdown)
		run_cmd --shutdown
        ;;
esac