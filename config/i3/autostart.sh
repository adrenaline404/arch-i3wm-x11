#!/usr/bin/env bash

pkill picom
pkill polybar

feh --bg-fill ~/Pictures/catppuccin.jpg
picom --config ~/.config/picom/picom.conf &
~/.config/polybar/launch.sh &
dunst &