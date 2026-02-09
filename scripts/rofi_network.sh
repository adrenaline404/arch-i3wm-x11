#!/bin/bash

ROFI_CONFIG="-theme ~/.config/rofi/config.rasi"
WIDTH_CONST=40

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
ICON_CHECK=" "

notify_user() {
    local title="$1"
    local msg="$2"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u low -t 2000 "$title" "$msg"
    else
        echo "[$title] $msg"
    fi
}

if ! command -v nmcli >/dev/null 2>&1; then
    notify_user "Error" "NetworkManager (nmcli) tidak ditemukan!"
    exit 1
fi

get_active_info() {
    ACTIVE=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | head -n1)
    
    if [ -n "$ACTIVE" ]; then
        NAME=$(echo "$ACTIVE" | cut -d: -f1)
        TYPE=$(echo "$ACTIVE" | cut -d: -f2)
        IP=$(nmcli -g ip4.address connection show "$NAME" | head -n1 | cut -d/ -f1)
        echo "Connected: $NAME ($TYPE) | IP: ${IP:-N/A}"
    else
        echo "Status: Disconnected / Offline"
    fi
}

show_main_menu() {
    WIFI_STATE=$(nmcli radio wifi)
    NET_STATE=$(nmcli networking)
    HEADER_MSG=$(get_active_info)

    if [ "$WIFI_STATE" = "enabled" ]; then
        OPT_WIFI="$ICON_WIFI_OFF Disable Wi-Fi"
        ACT_WIFI="wifi_off"
    else
        OPT_WIFI="$ICON_WIFI_ON Enable Wi-Fi"
        ACT_WIFI="wifi_on"
    fi

    if [ "$NET_STATE" = "enabled" ]; then
        OPT_NET="$ICON_NET_OFF Disable Networking"
        ACT_NET="net_off"
    else
        OPT_NET="$ICON_NET_ON Enable Networking"
        ACT_NET="net_on"
    fi

    MENU="$OPT_WIFI
$ICON_SCAN Scan Networks
$ICON_ETH Ethernet Status
$ICON_INFO Connection Details
$ICON_EDIT Connection Editor
$OPT_NET"

    LINE_COUNT=$(echo "$MENU" | wc -l)

    CHOICE=$(echo -e "$MENU" | rofi -dmenu -i -p "Network" \
        $ROFI_CONFIG \
        -mesg "$HEADER_MSG" \
        -lines "$LINE_COUNT" \
        -width "$WIDTH_CONST")

    case "$CHOICE" in
        "$OPT_WIFI")
            if [ "$ACT_WIFI" == "wifi_on" ]; then
                nmcli radio wifi on
                notify_user "Wi-Fi" "Turning On..."
            else
                nmcli radio wifi off
                notify_user "Wi-Fi" "Turning Off..."
            fi
            ;;
        "$ICON_SCAN"*)
            scan_wifi
            ;;
        "$ICON_ETH"*)
            show_ethernet_info
            ;;
        "$ICON_INFO"*)
            show_full_info
            ;;
        "$ICON_EDIT"*)
            nmcli-connection-editor &
            ;;
        "$OPT_NET")
            if [ "$ACT_NET" == "net_on" ]; then
                nmcli networking on
                notify_user "Network" "System Networking Enabled"
            else
                nmcli networking off
                notify_user "Network" "System Networking Disabled"
            fi
            ;;
    esac
}

scan_wifi() {
    notify_user "Wi-Fi" "Scanning networks..."
    
    WIFI_LIST=$(nmcli -t -f IN-USE,SSID,BARS,SECURITY device wifi list --rescan yes | \
        awk -F: '{
            if (length($2) > 0) {
                if($1=="*") active=" "; else active="  ";
                if($4!="") sec=" "; else sec=" ";
                printf "%s%-25s %s %s\n", active, substr($2,0,25), sec, $3
            }
        }')

    SELECTED=$(echo -e "$WIFI_LIST" | rofi -dmenu -i -p "Wi-Fi" \
        $ROFI_CONFIG \
        -mesg "Select a network to connect" \
        -lines 10 \
        -width 50)

    if [ -n "$SELECTED" ]; then
        TEMP="${SELECTED:2}"
        SSID=$(echo "$TEMP" | sed 's/ [].*//' | sed 's/ *$//')

        connect_wifi "$SSID"
    else
        show_main_menu
    fi
}

connect_wifi() {
    local SSID="$1"
    
    if nmcli connection show "$SSID" >/dev/null 2>&1; then
        notify_user "Wi-Fi" "Connecting to saved: $SSID..."
        if nmcli connection up id "$SSID"; then
            notify_user "Wi-Fi" "Connected to $SSID"
        else
            notify_user "Wi-Fi" "Connection failed. Retrying with password..."
            connect_new_wifi "$SSID"
        fi
    else
        connect_new_wifi "$SSID"
    fi
}

connect_new_wifi() {
    local SSID="$1"
    PASS=$(rofi -dmenu -password -p "Password for $SSID" \
        $ROFI_CONFIG \
        -lines 0 \
        -width 30)
        
    if [ -z "$PASS" ]; then return; fi

    notify_user "Wi-Fi" "Connecting to $SSID..."
    
    if nmcli device wifi connect "$SSID" password "$PASS"; then
        notify_user "Wi-Fi" "Success: Connected to $SSID"
    else
        notify_user "Wi-Fi" "Error: Failed to connect (Wrong password?)"
    fi
}

show_ethernet_info() {
    ETH_DEV=$(nmcli -t -f DEVICE,TYPE device | grep "ethernet" | cut -d: -f1 | head -n1)
    
    if [ -n "$ETH_DEV" ]; then
        STATUS=$(nmcli -t -f STATE device show "$ETH_DEV" | cut -d: -f2)
        if [ "$STATUS" == "connected" ]; then
             INFO=$(nmcli -g ip4.address,gw4,dns4 device show "$ETH_DEV")
             MSG="Device: $ETH_DEV (Connected)
---------------------------------
$INFO"
        else
             MSG="Device: $ETH_DEV
Status: Disconnected / Cable Unplugged"
        fi
    else
        MSG="No Ethernet Device Found."
    fi
    
    rofi -e "$MSG" $ROFI_CONFIG
    
    show_main_menu
}

show_full_info() {
    nmcli -p device show | rofi -dmenu \
        -p "System Info" \
        $ROFI_CONFIG \
        -width 60 \
        -lines 15
        
    show_main_menu
}

show_main_menu