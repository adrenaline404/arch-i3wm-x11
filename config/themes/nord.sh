cp ~/.config/polybar/themes/nord.ini ~/.config/polybar/config.ini
cp ~/.config/wallpaper/nord.jpg ~/.config/wallpaper/current.jpg
pkill polybar && ~/.config/polybar/launch.sh
feh --bg-fill ~/.config/wallpaper/current.jpg
i3-msg reload