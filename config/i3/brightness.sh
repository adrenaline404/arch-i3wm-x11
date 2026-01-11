#!/bin/sh
DEV=$(brightnessctl -l | grep backlight | head -n1 | awk '{print $1}')
[ "$1" = "up" ] && brightnessctl -d "$DEV" set +5%
[ "$1" = "down" ] && brightnessctl -d "$DEV" set 5%-