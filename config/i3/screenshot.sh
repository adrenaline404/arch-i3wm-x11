#!/bin/sh
maim -s ~/Pictures/screenshot-$(date +%s).png
notify-send "Screenshot saved"