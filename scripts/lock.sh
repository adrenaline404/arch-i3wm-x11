#!/bin/bash

COLOR_CONFIG="$HOME/.config/i3/scripts/lock_colors.rc"

if [ -f "$COLOR_CONFIG" ]; then
    source "$COLOR_CONFIG"
else
    # Fallback to Pro Dark (Catppuccin Mocha) if config is missing
    LOCK_RING="#CBA6F7cc"    # Mauve
    LOCK_TEXT="#CDD6F4ee"    # White/Text
    LOCK_WRONG="#F38BA8bb"   # Red Pastel
    LOCK_VERIFY="#89B4FAbb"  # Blue Pastel
    LOCK_INSIDE="#00000000"  # Transparent
fi

BLANK='#00000000'
SHADOW_BG='#1E1E2E88'

DATE_LAYOUT="%A, %d %B %Y"

i3lock \
--blur 7 \
--clock \
--indicator \
\
--radius=140 \
--ring-width=6 \
\
--inside-color=$SHADOW_BG \
--ring-color=$LOCK_RING \
--line-color=$BLANK \
\
--keyhl-color=$LOCK_TEXT \
--bshl-color=$LOCK_WRONG \
\
--ringver-color=$LOCK_VERIFY \
--separator-color=$LOCK_RING \
--insidever-color=$SHADOW_BG \
\
--ringwrong-color=$LOCK_WRONG \
--insidewrong-color=$SHADOW_BG \
\
--verif-color=$LOCK_TEXT \
--wrong-color=$LOCK_WRONG \
--time-color=$LOCK_TEXT \
--date-color=$LOCK_TEXT \
--layout-color=$LOCK_TEXT \
\
--time-str="%H:%M" \
--time-font="JetBrainsMono Nerd Font:style=ExtraBold" \
--time-size=56 \
--time-pos="ix:iy-15" \
\
--date-str="$DATE_LAYOUT" \
--date-font="JetBrainsMono Nerd Font:style=Bold" \
--date-size=14 \
--date-pos="ix:iy+25" \
\
--verif-text="Verifying..." \
--verif-font="JetBrainsMono Nerd Font:style=Bold" \
--verif-size=24 \
--verif-pos="ix:iy" \
\
--wrong-text="Access Denied" \
--wrong-font="JetBrainsMono Nerd Font:style=Bold" \
--wrong-size=24 \
--wrong-pos="ix:iy" \
\
--no-modkey-text \
--ignore-empty-password \
--pass-media-keys