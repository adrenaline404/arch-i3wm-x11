#!/bin/bash

STATUS=$(xset q | grep "DPMS is" | awk '{print $3}')

if [ "$1" == "toggle" ]; then
    if [ "$STATUS" == "Enabled" ]; then
        xset s off -dpms
        notify-send "Caffeine" "Enabled (No Sleep)" -i "coffee"
    else
        xset s on +dpms
        notify-send "Caffeine" "Disabled (Auto Sleep)" -i "coffee-off"
    fi
else
    if [ "$STATUS" == "Enabled" ]; then
        echo ""
    else
        echo "☕" 
    fi
fi