#!/bin/bash

THEME_COLORS="$HOME/.config/i3/themes/current/colors.ini"
ACCENT=$(grep '^primary =' "$THEME_COLORS" | awk '{print $3}')
ALERT=$(grep '^alert =' "$THEME_COLORS" | awk '{print $3}')
FOREGROUND=$(grep '^foreground =' "$THEME_COLORS" | awk '{print $3}')

if [ -z "$ACCENT" ]; then ACCENT="#CBA6F7"; fi
if [ -z "$ALERT" ]; then ALERT="#F38BA8"; fi
if [ -z "$FOREGROUND" ]; then FOREGROUND="#CDD6F4"; fi

BAT=""
for supply in /sys/class/power_supply/BAT*; do
    if [ -f "$supply/type" ] && grep -q "Battery" "$supply/type"; then
        BAT="$supply"
        break
    fi
done

if [ -z "$BAT" ]; then exit 0; fi

STATUS=$(cat "$BAT/status")
CAPACITY=$(cat "$BAT/capacity")

if [ "$CAPACITY" -gt 100 ]; then CAPACITY=100; fi

if [ "$STATUS" = "Charging" ] || [ "$STATUS" = "Full" ]; then
    ICON="󰂄"
    COLOR="$ACCENT"
else
    if [ "$CAPACITY" -ge 90 ]; then ICON="󰁹"; COLOR="$FOREGROUND"
    elif [ "$CAPACITY" -ge 70 ]; then ICON="󰂁"; COLOR="$FOREGROUND"
    elif [ "$CAPACITY" -ge 50 ]; then ICON="󰁿"; COLOR="$FOREGROUND"
    elif [ "$CAPACITY" -ge 30 ]; then ICON="󰁽"; COLOR="$FOREGROUND"
    elif [ "$CAPACITY" -ge 15 ]; then ICON="󰁻"; COLOR="$ALERT"
    else ICON="󰂎"; COLOR="$ALERT"
    fi
fi

if [ "$CAPACITY" -le 15 ] && [ "$STATUS" != "Charging" ]; then
    echo "%{F$ALERT}$ICON $CAPACITY%%{F-}"
else
    echo "%{F$COLOR}$ICON%{F-} $CAPACITY%"
fi