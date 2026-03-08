#!/bin/bash

ACCENT=$(grep '^primary =' "$HOME/.config/i3/themes/current/colors.ini" | awk '{print $3}')
if [ -z "$ACCENT" ]; then ACCENT="#CBA6F7"; fi

DISABLED_COLOR=$(grep '^disabled =' "$HOME/.config/i3/themes/current/colors.ini" | awk '{print $3}')
if [ -z "$DISABLED_COLOR" ]; then DISABLED_COLOR="#6C7086"; fi

STATUS=$(xset q | grep "DPMS is" | awk '{print $3}')

if [ "$1" == "toggle" ]; then
    if [ "$STATUS" == "Enabled" ]; then
        xset s off -dpms
        notify-send -u low "󰅶 Caffeine" "Enabled: Screen will stay awake."
    else
        xset s on +dpms
        notify-send -u low "⏾ Caffeine" "Disabled: Auto-sleep restored."
    fi
else
    if [ "$STATUS" == "Enabled" ]; then
        echo "%{F$DISABLED_COLOR}󰅽 %{F-}"
    else
        echo "%{F$ACCENT}󰅶 %{F-}"
    fi
fi