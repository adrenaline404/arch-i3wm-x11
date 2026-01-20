#!/bin/bash

TMPBG=/tmp/screen.png
scrot "$TMPBG"

convert "$TMPBG" -filter Gaussian -thumbnail 20% -sample 500% "$TMPBG"
convert "$TMPBG" -fill "black" -colorize 50% "$TMPBG"

i3lock \
  -i "$TMPBG" \
  --time-color=ffffffff \
  --date-color=ffffffff \
  --layout-color=ffffffff \
  --keyhl-color=bd2c40ff \
  --bshl-color=bd2c40ff \
  --separator-color=00000000 \
  --insidever-color=00000000 \
  --insidewrong-color=00000000 \
  --inside-color=00000000 \
  --ringver-color=5294e2ff \
  --ringwrong-color=bd2c40ff \
  --ring-color=ffffff33 \
  --line-color=00000000 \
  --verif-text="Verifying..." \
  --wrong-text="Access Denied" \
  --noinput-text="" \
  --lock-text="Locked" \
  --lockfailed-text="Failed" \
  --clock \
  --time-str="%H:%M" \
  --date-str="%d %B %Y" \
  --date-str="%A" \
  --indicator

rm "$TMPBG"