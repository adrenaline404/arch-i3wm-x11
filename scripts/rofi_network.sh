#!/bin/bash

ROFI_CMD="rofi -dmenu -i -theme ~/.config/rofi/config.rasi"
NOTIFY_CMD="notify-send -u low -t 2000"

ICON_WIFI_ON=" "
ICON_WIFI_OFF="󰖪 "
ICON_ETH="󰈀 "
ICON_NET_ON="󰖩 "
ICON_NET_OFF="󰖪 "
ICON_SCAN=" "
ICON_INFO=" "
ICON_EDIT=" "
ICON_LOCK=" "
ICON_UNLOCK=" "

get_status_info() {
    ACTIVE_CON=$(nmcli -t -f NAME,TYPE connection show --active | head -n1)
    if [ -n "$ACTIVE_CON" ]; then
        NAME=$(echo "$ACTIVE_CON" | cut -d: -f1)
        TYPE=$(echo "$ACTIVE_CON" | cut -d: -f2)
        IP_ADDR=$(nmcli -g ip4.address connection show "$NAME" | awk '{print $1}' | cut -d/ -f1)
        echo "Connected: $NAME ($TYPE) | IP: $IP_ADDR"
    else
        echo "Status: Disconnected"
    fi
}

show_main_menu() {
    WIFI_STATUS=$(nmcli radio wifi)
    NET_STATUS=$(nmcli networking)
    HEADER=$(get_status_info)

    if [ "$WIFI_STATUS" = "enabled" ]; then
        OPT_WIFI="$ICON_WIFI_OFF Disable Wi-Fi"
    else
        OPT_WIFI="$ICON_WIFI_ON Enable Wi-Fi"
    fi

    if [ "$NET_STATUS" = "enabled" ]; then
        OPT_NET="$ICON_NET_OFF Disable Networking (Airplane)"
    else
        OPT_NET="$ICON_NET_ON Enable Networking"
    fi

    OPTIONS="$OPT_WIFI\n$ICON_SCAN Scan Networks\n$ICON_ETH Ethernet Status\n$ICON_INFO Connection Details\n$ICON_EDIT Connection Editor\n$OPT_NET"

    CHOICE=$(echo -e "$OPTIONS" | $ROFI_CMD -p "Network" -mesg "$HEADER")

    case "$CHOICE" in
        *"Enable Wi-Fi")
            nmcli radio wifi on
            $NOTIFY_CMD "Wi-Fi" "Radio Enabled"
            ;;
        *"Disable Wi-Fi")
            nmcli radio wifi off
            $NOTIFY_CMD "Wi-Fi" "Radio Disabled"
            ;;
        *"Scan Networks")
            scan_wifi
            ;;
        *"Ethernet Status")
            show_ethernet_info
            ;;
        *"Connection Details")
            show_full_info
            ;;
        *"Connection Editor")
            nmcli-connection-editor &
            ;;
        *"Enable Networking")
            nmcli networking on
            $NOTIFY_CMD "Network" "Networking Enabled"
            ;;
        *"Disable Networking")
            nmcli networking off
            $NOTIFY_CMD "Network" "Networking Disabled"
            ;;
    esac
}

scan_wifi() {
    $NOTIFY_CMD "Wi-Fi" "Scanning networks..."
    
    WIFI_LIST=$(nmcli --colors no -f IN-USE,BARS,SECURITY,SSID device wifi list | \
        sed '1d' | \
        awk -F'  +' '{
            if($1=="*") active=" "; else active="  ";
            if($3=="--") sec=" "; else sec=" ";
            printf "%s %-5s %s %-20s\n", active, $2, sec, $4
        }')

    CHOSEN=$(echo -e "$WIFI_LIST" | $ROFI_CMD -p "Wi-Fi Scan" -mesg " : Active |  : Secured | Bars : Signal")

    if [ -z "$CHOSEN" ]; then show_main_menu; return; fi

    SSID=$(echo "$CHOSEN" | sed -E 's/^.. ..... .. //')
    
    if [ -n "$SSID" ]; then
        connect_wifi "$SSID"
    fi
}

connect_wifi() {
    SSID=$1
    SAVED=$(nmcli -g NAME connection show | grep -w "$SSID")

    if [ -n "$SAVED" ]; then
        $NOTIFY_CMD "Wi-Fi" "Connecting to saved network: $SSID..."
        if nmcli connection up id "$SSID"; then
            $NOTIFY_CMD "Wi-Fi" "Connected to $SSID"
        else
            $NOTIFY_CMD "Wi-Fi" "Failed to connect"
        fi
    else
        PASS=$(rofi -dmenu -password -p "Password for $SSID" -theme ~/.config/rofi/config.rasi)
        
        if [ -z "$PASS" ]; then return; fi

        $NOTIFY_CMD "Wi-Fi" "Connecting to new network: $SSID..."
        if nmcli device wifi connect "$SSID" password "$PASS"; then
            $NOTIFY_CMD "Wi-Fi" "Connected to $SSID"
        else
            $NOTIFY_CMD "Wi-Fi" "Wrong password or failed connection"
        fi
    fi
}

show_ethernet_info() {
    ETH_STATUS=$(nmcli device status | grep "ethernet" | awk '{print $3}')
    ETH_DEVICE=$(nmcli device status | grep "ethernet" | awk '{print $1}')
    
    if [ "$ETH_STATUS" == "connected" ]; then
        INFO=$(nmcli -g ip4.address,gw4,dns4 device show "$ETH_DEVICE")
        rofi -e "  Ethernet Connected ($ETH_DEVICE)
-----------------------------------
$INFO" -theme ~/.config/rofi/config.rasi
    else
        rofi -e "  Ethernet: Disconnected / Cable Unplugged" -theme ~/.config/rofi/config.rasi
    fi
    show_main_menu
}

show_full_info() {
    INFO=$(nmcli -p -f GENERAL,IP4,DNS device show)
    
    echo "$INFO" | rofi -dmenu -p "Details" -theme ~/.config/rofi/config.rasi -lines 15 -width 50
    show_main_menu
}

show_main_menu