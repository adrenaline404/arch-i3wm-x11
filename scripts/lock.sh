#!/bin/bash

BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#2e9ef4cc'
TEXT='#2e9ef4ee'
WRONG='#ff5555bb'
VERIFY='#50fa7bbb'

i3lock \
--blur 5 \
--indicator \
--bar-indicator \
--bar-pos="y+h" \
--bar-direction=1 \
--bar-max-height=50 \
--bar-base-width=50 \
--bar-color=000000cc \
--keyhl-color=$DEFAULT \
--bshl-color=$WRONG \
--separator-color=$DEFAULT \
--verif-color=$VERIFY \
--wrong-color=$WRONG \
--layout-color=$TEXT \
--date-color=$TEXT \
--time-color=$TEXT \
--screen 1 \
--clock \
--time-str="%H:%M:%S" \
--date-str="%A, %d %B %Y" \
--verify-text="Verifying..." \
--wrong-text="Incorrect!" \
--no-modkey-text