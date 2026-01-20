#!/bin/bash

ROFI_CMD="rofi -dmenu -i -p '  Wi-Fi' -theme ~/.config/rofi/config.rasi"

WIFI_STATUS=$(nmcli radio wifi)

if [ "$WIFI_STATUS" = "disabled" ]; then
    echo "WIFI IS DISABLED"
    CHOSEN=$(echo -e "Enable Wi-Fi" | eval "$ROFI_CMD")
    if [ "$CHOSEN" = "Enable Wi-Fi" ]; then
        nmcli radio wifi on
        notify-send "Wi-Fi" "Wi-Fi Enabled. Please wait..."
    fi
    exit 0
fi

LIST=$(nmcli --fields "BARS,SSID,SECURITY" device wifi list --rescan yes | sed 1d | sed 's/  */ /g')

CHOSEN=$(echo -e "  Rescan\n$LIST" | uniq -u | eval "$ROFI_CMD")

if [ -z "$CHOSEN" ]; then
    exit 0
elif [ "$CHOSEN" = "  Rescan" ]; then
    nmcli device wifi rescan
    notify-send "Wi-Fi" "Scanning for networks..."
    $0
    exit 0
else
    SSID=$(echo "$CHOSEN" | sed -E 's/^[^ ]+ //')
    SSID=$(echo "$SSID" | sed -E 's/ [^ ]+$//')
    SSID=$(echo "$SSID" | xargs)

    KNOWN=$(nmcli connection show | grep "$SSID")

    if [ -n "$KNOWN" ]; then
        notify-send "Wi-Fi" "Connecting to \"$SSID\"..."
        nmcli connection up id "$SSID"
    else
        PASS=$(rofi -dmenu -p "Password for $SSID" -password -theme ~/.config/rofi/config.rasi)
        if [ -n "$PASS" ]; then
            notify-send "Wi-Fi" "Connecting to \"$SSID\"..."
            if nmcli device wifi connect "$SSID" password "$PASS"; then
                notify-send "Wi-Fi" "Connected to \"$SSID\""
            else
                notify-send "Wi-Fi" "Failed to connect"
            fi
        fi
    fi
fi