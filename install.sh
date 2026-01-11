#!/bin/bash
sudo pacman -S --needed \
i3-wm xorg-xinit dbus \
polybar rofi dunst picom feh maim \
brightnessctl pamixer alacritty \
xsecurelock xss-lock imagemagick \
ttf-jetbrains-mono-nerd \
noto-fonts noto-fonts-emoji

mkdir -p ~/.config
cp -r config/* ~/.config/
cp .xinitrc ~/

chmod +x ~/.config/i3/*.sh
chmod +x ~/.config/polybar/*.sh
chmod +x ~/.config/rofi/*.sh
chmod +x ~/.config/themes/*.sh

echo "Install selesai. | Jalankan: startx - untuk memulai i3wm. | By: @adrenaline404"