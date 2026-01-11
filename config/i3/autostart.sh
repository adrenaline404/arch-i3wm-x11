#!/bin/sh
pgrep -x picom || picom --config ~/.config/i3/picom.conf &
pgrep -x dunst || dunst &
pgrep -x polybar || ~/.config/polybar/launch.sh &
feh --bg-fill ~/.config/wallpaper/current.jpg &
pgrep -x xss-lock || xss-lock -- xsecurelock &