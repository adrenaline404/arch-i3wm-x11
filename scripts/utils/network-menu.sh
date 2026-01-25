#!/bin/bash

exec 1>>/tmp/network-menu.log 2>&1

killall rofi || true

ROFI_CMD="rofi -dmenu -i -p '  Wi-Fi' -theme ~/.config/rofi/config.rasi"

WIFI_STATUS=$(nmcli radio wifi)
if [ "$WIFI_STATUS" = "disabled" ]; then
    CHOSEN=$(echo -e "Enable Wi-Fi" | eval "$ROFI_CMD")
    if [ "$CHOSEN" = "Enable Wi-Fi" ]; then
        nmcli radio wifi on
        notify-send "Wi-Fi" "Enabling Wi-Fi..."
    fi
    exit 0
fi

LIST=$(nmcli --fields "BARS,SSID,SECURITY" device wifi list --rescan yes | sed 1d | sed 's/  */ /g')

CHOSEN=$(echo -e "  Rescan\n  Settings\n$LIST" | uniq -u | eval "$ROFI_CMD")

if [ -z "$CHOSEN" ]; then
    exit 0
elif [ "$CHOSEN" = "  Rescan" ]; then
    nmcli device wifi rescan
    notify-send "Wi-Fi" "Rescanning..."
    $0
elif [ "$CHOSEN" = "  Settings" ]; then
    nm-connection-editor &
    exit 0
else
    SSID=$(echo "$CHOSEN" | sed -E 's/^[^ ]+ //')
    SSID=$(echo "$SSID" | sed -E 's/ [^ ]+$//')
    SSID=$(echo "$SSID" | xargs)

    KNOWN=$(nmcli connection show | grep "$SSID")

    if [ -n "$KNOWN" ]; then
        notify-send "Wi-Fi" "Connecting to $SSID..."
        nmcli connection up id "$SSID"
    else
        PASS=$(rofi -dmenu -p "Password" -password -theme ~/.config/rofi/config.rasi)
        if [ -n "$PASS" ]; then
            notify-send "Wi-Fi" "Connecting..."
            if nmcli device wifi connect "$SSID" password "$PASS"; then
                notify-send "Wi-Fi" "Connected: $SSID"
            else
                notify-send "Wi-Fi" "Connection Failed"
            fi
        fi
    fi
fi