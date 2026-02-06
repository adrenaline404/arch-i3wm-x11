#!/bin/bash

COLOR_CONFIG="$HOME/.config/i3/scripts/lock_colors.rc"
if [ -f "$COLOR_CONFIG" ]; then source "$COLOR_CONFIG"; else
    LOCK_RING="#FF0000cc"; LOCK_TEXT="#FF0000ee"; LOCK_WRONG="#880000bb"; LOCK_VERIFY="#ff5555bb"; LOCK_INSIDE="#00000000"
fi

BLANK='#00000000'

i3lock \
--blur 5 \
--clock \
--indicator \
--radius=120 \
--ring-width=10 \
--inside-color=$LOCK_INSIDE \
--ring-color=$LOCK_RING \
--line-color=$BLANK \
--keyhl-color=$LOCK_WRONG \
--ringver-color=$LOCK_VERIFY \
--separator-color=$LOCK_RING \
--insidever-color=$LOCK_INSIDE \
--ringwrong-color=$LOCK_WRONG \
--insidewrong-color=$LOCK_INSIDE \
--verif-color=$LOCK_TEXT \
--wrong-color=$LOCK_TEXT \
--time-color=$LOCK_TEXT \
--date-color=$LOCK_TEXT \
--layout-color=$LOCK_TEXT \
\
--time-str="%H:%M" \
--time-font="JetBrainsMono Nerd Font:style=Bold" \
--time-size=60 \
--time-pos="ix:iy+20" \
\
--date-str="%A, %d %B %Y" \
--date-font="JetBrainsMono Nerd Font" \
--date-size=18 \
--date-pos="ix:iy+160" \
\
--verif-text="Verifying..." \
--verif-size=20 \
--wrong-text="Access Denied" \
--wrong-size=20 \
--no-modkey-text \
--ignore-empty-password \
--pass-media-keys