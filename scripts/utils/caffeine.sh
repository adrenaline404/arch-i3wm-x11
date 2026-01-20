#!/bin/bash

if [ "$1" = "status" ]; then
    if xset q | grep -q "DPMS is Enabled"; then
        echo "%{F#444444}󰾪%{F-}"
    else
        echo "%{F#2e9ef4}󰅶%{F-}"
    fi
fi

if [ "$1" = "toggle" ]; then
    if xset q | grep -q "DPMS is Enabled"; then
        xset s off -dpms
        notify-send -u low -t 2000 "Caffeine" "Enabled ☕ (No Sleep)"
    else
        xset s on +dpms
        notify-send -u low -t 2000 "Caffeine" "Disabled 󰾪 (Auto Lock On)"
    fi
fi