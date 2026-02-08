#!/bin/bash

COLOR_CONFIG="$HOME/.config/i3/scripts/lock_colors.rc"

if [ -f "$COLOR_CONFIG" ]; then
    source "$COLOR_CONFIG"
else
    LOCK_RING="#FF0000cc"
    LOCK_INSIDE="#00000000"
    LOCK_TEXT="#FF0000ee"
    LOCK_WRONG="#880000bb"
    LOCK_VERIFY="#ff5555bb"
fi

BLANK='#00000000'

DATE_LAYOUT="%A, %d %B %Y"

i3lock \
--blur 1 \
--clock \
--indicator \
\
--radius=120 \
--ring-width=12 \
\
--inside-color=$LOCK_INSIDE \
--ring-color=$LOCK_RING \
--line-color=$BLANK \
\
--keyhl-color=$LOCK_WRONG \
--bshl-color=$LOCK_WRONG \
\
--ringver-color=$LOCK_VERIFY \
--separator-color=$LOCK_RING \
--insidever-color=$LOCK_INSIDE \
\
--ringwrong-color=$LOCK_WRONG \
--insidewrong-color=$LOCK_INSIDE \
\
--verif-color=$LOCK_TEXT \
--wrong-color=$LOCK_TEXT \
--time-color=$LOCK_TEXT \
--date-color=$LOCK_TEXT \
--layout-color=$LOCK_TEXT \
\
--time-str="%H:%M" \
--time-font="JetBrainsMono Nerd Font:style=ExtraBold" \
--time-size=64 \
--time-pos="ix:iy-12" \
\
--date-str="$DATE_LAYOUT" \
--date-font="JetBrainsMono Nerd Font:style=Bold" \
--date-size=12 \
--date-pos="ix:iy+28" \
\
--verif-text="Verifying..." \
--verif-size=30 \
--verif-pos="ix:iy" \
\
--wrong-text="Access Denied" \
--wrong-size=30 \
--wrong-pos="ix:iy" \
\
--no-modkey-text \
--ignore-empty-password \
--pass-media-keys