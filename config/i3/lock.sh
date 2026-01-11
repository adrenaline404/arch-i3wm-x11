#!/bin/sh
scrot /tmp/lock.png
convert /tmp/lock.png -blur 0x5 /tmp/lockblur.png
i3lock -i /tmp/lockblur.png