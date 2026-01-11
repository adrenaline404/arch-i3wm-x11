#!/bin/sh
CHOICE=$(printf "Catppuccin\nNord" | rofi -dmenu)
case "$CHOICE" in
  Catppuccin) ~/.config/themes/catppuccin.sh ;;
  Nord) ~/.config/themes/nord.sh ;;
esac