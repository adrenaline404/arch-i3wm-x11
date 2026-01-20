#!/bin/bash

ROFI_CMD="rofi -dmenu -i -p '  Wi-Fi' -theme ~/.config/rofi/config.rasi"

LIST=$(nmcli --fields "SSID,BARS" device wifi list | sed 1d | sed 's/  */ /g')

CHOSEN=$(echo -e "  Rescan\n$LIST" | uniq -u | eval "$ROFI_CMD")

if [ -z "$CHOSEN" ]; then
    exit 0
elif [ "$CHOSEN" = "  Rescan" ]; then
    nmcli device wifi rescan
    exit 0
else
    SSID=$(echo "$CHOSEN" | awk '{print $1}')
    
    KNOWN=$(nmcli connection show | grep "$SSID")

    if [ -n "$KNOWN" ]; then
        nmcli connection up id "$SSID"
    else
        PASS=$(rofi -dmenu -p "Password for $SSID" -password -theme ~/.config/rofi/config.rasi)
        if [ -n "$PASS" ]; then
            nmcli device wifi connect "$SSID" password "$PASS"
        fi
    fi
fi