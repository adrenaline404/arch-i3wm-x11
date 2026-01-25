#!/bin/bash

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then updates_arch=0; fi
if ! updates_aur=$(yay -Qua 2> /dev/null | wc -l); then updates_aur=0; fi

total=$((updates_arch + updates_aur))

if [ "$total" -gt 0 ]; then
    echo "📦 $total"
else
    echo "📦 ✓"
fi