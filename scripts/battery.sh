#!/bin/bash
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

if [ "$STATUS" = "Charging" ]; then
    ICON=""
else
    if [ "$CAPACITY" -ge 90 ]; then ICON=""
    elif [ "$CAPACITY" -ge 70 ]; then ICON=""
    elif [ "$CAPACITY" -ge 40 ]; then ICON=""
    elif [ "$CAPACITY" -ge 15 ]; then ICON=""
    else ICON=""
    fi
fi
echo "$ICON $CAPACITY%"