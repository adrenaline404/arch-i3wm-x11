#!/bin/bash

get_count() {
    if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
        updates_arch=0
    fi

    if ! updates_aur=$(yay -Qua 2> /dev/null | wc -l); then
        updates_aur=0
    fi

    updates=$((updates_arch + updates_aur))

    if [ "$updates" -gt 0 ]; then
        echo " $updates"
    else
        echo ""
    fi
}

show_list() {
    list_arch=$(checkupdates 2>/dev/null | sed 's/^/  /') 
    list_aur=$(yay -Qua 2>/dev/null | sed 's/^/󰣇  /')

    full_list="$list_arch\n$list_aur"

    clean_list=$(echo -e "$full_list" | sed '/^$/d')

    if [ -z "$clean_list" ]; then
        notify-send "System" "No updates available."
        exit 0
    fi

    echo -e "$clean_list" | rofi -dmenu -i -p "Updates Available" -theme ~/.config/rofi/config.rasi
}

run_update() {
    kitty --hold -e sh -c "yay -Syu; echo 'Done. Press Enter to exit.'; read"
}

case "$1" in
    show)
        show_list
        ;;
    update)
        run_update
        ;;
    *)
        get_count
        ;;
esac