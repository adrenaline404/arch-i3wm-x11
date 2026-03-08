#!/bin/bash

ACCENT=$(grep '^primary =' "$HOME/.config/i3/themes/current/colors.ini" | awk '{print $3}')
if [ -z "$ACCENT" ]; then ACCENT="#CBA6F7"; fi

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
        echo " 0"
    fi
}

show_list() {
    list_arch=$(checkupdates 2>/dev/null | sed 's/^/  /') 
    list_aur=$(yay -Qua 2>/dev/null | sed 's/^/󰣇  /')

    full_list="$list_arch\n$list_aur"

    clean_list=$(echo -e "$full_list" | sed '/^$/d' | grep -v '^\s*$')

    if [ -z "$clean_list" ]; then
        notify-send "System Status" "No updates available. Your system is up to date!"
        exit 0
    fi

    HEADER="<span color='$ACCENT'><b>      AVAILABLE SYSTEM UPDATES      </b></span>"
    LAYOUT="window {width: 700px;} listview {lines: 12;} element-text {font: \"JetBrainsMono Nerd Font 11\";}"

    echo -e "$clean_list" | rofi -dmenu -i -p "Updates" \
        -theme ~/.config/rofi/config.rasi \
        -theme-str "$LAYOUT" \
        -mesg "$HEADER"
}

run_update() {
    kitty --hold -e sh -c "yay -Syu; echo ''; echo 'System Update Complete! Press Enter to exit.'; read"
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