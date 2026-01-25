#!/bin/bash

get_brightness() {
    brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}'
}

get_icon() {
    current=$(get_brightness)
    if [ "$current" -ge 80 ]; then echo "󰃠"
    elif [ "$current" -ge 50 ]; then echo "󰃟"
    elif [ "$current" -ge 20 ]; then echo "󰃝"
    else echo "󰃞"
    fi
}

echo "$(get_icon) $(get_brightness)%"