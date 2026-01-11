#!/usr/bin/env bash
choice=$(printf "Catppuccin\nNord" | rofi -dmenu)

case "$choice" in
  Catppuccin)
    feh --bg-fill ~/Pictures/catppuccin.jpg
    ;;
  Nord)
    feh --bg-fill ~/Pictures/nord.jpg
    ;;
esac