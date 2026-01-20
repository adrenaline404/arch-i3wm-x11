#!/bin/bash

IMAGE=/tmp/i3lock.png

maim -u "$IMAGE"

convert "$IMAGE" \
    -filter Gaussian \
    -resize 25% \
    -blur 0x15 \
    -resize 400% \
    -fill black -colorize 45% \
    "$IMAGE"

i3lock \
  -i "$IMAGE" \
  --nofork \
  --ignore-empty-password \
  --line-uses-inside \
  \
  --clock \
  --time-str="%H:%M" \
  --time-color=2e9ef4ff \
  --time-size=28 \
  --time-font="JetBrainsMono Nerd Font" \
  \
  --date-str="%d %B %Y" \
  --date-color=ffffffff \
  --date-size=12 \
  --date-font="JetBrainsMono Nerd Font" \
  --date-str="%A" \
  --date-color=ffffffff \
  --date-size=14 \
  --date-font="JetBrainsMono Nerd Font" \
  \
  --keyhl-color=2e9ef4ff \
  --bshl-color=ff5555ff \
  --separator-color=00000000 \
  --insidever-color=00000000 \
  --insidewrong-color=00000000 \
  --inside-color=00000000 \
  --ringver-color=50fa7bff \
  --ringwrong-color=ff5555ff \
  --ring-color=2e9ef433 \
  \
  --verif-text="" \
  --wrong-text="" \
  --noinput-text="" \
  --lock-text="" \
  --lockfailed-text="" \
  \
  --radius=120 \
  --ring-width=8 \
  --indicator

rm "$IMAGE"