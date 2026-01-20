#!/bin/bash

lock=""
logout=""
reboot=""
shutdown=""

rofi_cmd() {
	rofi -dmenu \
		-p "Goodbye" \
		-theme ~/.config/rofi/powermenu.rasi
}

run_cmd() {
	if [[ $1 == "--opt1" ]]; then
		"$HOME/scripts/utils/lock.sh"
	elif [[ $1 == "--opt2" ]]; then
		i3-msg exit
	elif [[ $1 == "--opt3" ]]; then
		systemctl reboot
	elif [[ $1 == "--opt4" ]]; then
		systemctl poweroff
	fi
}

chosen="$(printf "%s\n%s\n%s\n%s" "$lock" "$logout" "$reboot" "$shutdown" | rofi_cmd)"

case ${chosen} in
    $lock)
		run_cmd --opt1
        ;;
    $logout)
		run_cmd --opt2
        ;;
    $reboot)
		run_cmd --opt3
        ;;
    $shutdown)
		run_cmd --opt4
        ;;
esac