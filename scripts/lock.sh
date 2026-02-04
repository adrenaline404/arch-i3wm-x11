#!/bin/bash
COLOR="2e9ef4" 

i3lock \
--blur 5 \
--bar-indicator \
--bar-pos y+h \
--bar-direction 1 \
--bar-max-height 50 \
--bar-base-width 50 \
--bar-color 000000cc \
--keyhl-color "$COLOR" \
--bar-periodic-step 50 \
--bar-step 50 \
--redraw-thread \
--clock \
--force-clock \
--time-pos x+5:y+h-80 \
--time-color "$COLOR" \
--date-pos tx:ty+25 \
--date-color "$COLOR" \
--date-align 1 \
--time-align 1 \
--ringver-color "$COLOR" \
--ringwrong-color ff5555 \
--status-pos x+5:y+h-16 \
--verif-align 1 \
--wrong-align 1 \
--verif-color "$COLOR" \
--wrong-color ff5555 \
--modif-pos -50:-50