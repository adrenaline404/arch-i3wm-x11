#!/bin/bash
BG=$(xrdb -query | grep "*background" | awk '{print $2}')
FG=$(xrdb -query | grep "*foreground" | awk '{print $2}')
ACC=$(xrdb -query | grep "*accent" | awk '{print $2}')

BGC=${BG:1}
FGC=${FG:1}
ACCC=${ACC:1}

i3lock \
--blur 5 \
--clock \
--indicator \
--inside-color=00000000 \
--ring-color=$ACCC \
--line-color=00000000 \
--keyhl-color=$FGC \
--time-color=$FGC \
--date-color=$FGC \
--layout-color=$FGC \
--time-str="%H:%M" \
--date-str="%d %B %Y" \
--date-str="%A" \
--verif-text="..." \
--wrong-text="X" \
--noinput-text=""