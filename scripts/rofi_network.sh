#!/bin/bash

ROFI_CMD="rofi -dmenu -i -theme ~/.config/rofi/config.rasi -p 'Wi-Fi'"

STATUS=$(nmcli -fields WIFI g)

if [[ "$STATUS" =~ "enabled" ]]; then
	TOGGLE="睊  Disable Wi-Fi"
elif [[ "$STATUS" =~ "disabled" ]]; then
	TOGGLE="直  Enable Wi-Fi"
fi

OPTIONS="$TOGGLE\n  Scan Networks\n  Connection Editor"

CHOICE=$(echo -e "$OPTIONS" | eval $ROFI_CMD)

case "$CHOICE" in
	"睊  Disable Wi-Fi")
		nmcli radio wifi off
		notify-send "Wi-Fi" "Radio Disabled"
		;;
	"直  Enable Wi-Fi")
		nmcli radio wifi on
		notify-send "Wi-Fi" "Radio Enabled"
		;;
	"  Connection Editor")
		nmcli-connection-editor &
		;;
	"  Scan Networks")
		notify-send "Wi-Fi" "Scanning networks..."
		
		WIFI_LIST=$(nmcli --fields "SSID,SECURITY,BARS" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*. //g" | uniq)
		
		CHOSEN_WIFI=$(echo -e "$WIFI_LIST" | uniq -u | eval $ROFI_CMD -p "Select Wi-Fi" | awk '{print $1}')
		
		if [ -z "$CHOSEN_WIFI" ]; then exit 0; fi
		
		PASS=$(rofi -dmenu -password -p "Password for $CHOSEN_WIFI" -theme ~/.config/rofi/config.rasi)
		
		if [ -n "$PASS" ]; then
			nmcli device wifi connect "$CHOSEN_WIFI" password "$PASS"
			if [ $? -eq 0 ]; then
				notify-send "Wi-Fi" "Connected to $CHOSEN_WIFI"
			else
				notify-send "Wi-Fi" "Failed to connect" -u critical
			fi
		fi
		;;
esac