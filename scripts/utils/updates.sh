#!/bin/bash

if ! official_updates=$(checkupdates 2> /dev/null | wc -l); then
    official_updates=0
fi

if ! aur_updates=$(yay -Qua 2> /dev/null | wc -l); then
    aur_updates=0
fi

total_updates=$((official_updates + aur_updates))

if [ "$total_updates" -gt 0 ]; then
    echo "📦 $total_updates"
else
    echo ""
fi