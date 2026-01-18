#!/bin/bash

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

NAME="Screenshot_$(date +%Y%m%d_%H%M%S).png"

flameshot full -p "$DIR/$NAME"

dunstify "Screenshot Saved" "Saved to $DIR/$NAME" -u low -r 9992