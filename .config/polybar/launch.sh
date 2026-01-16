#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

LOG_FILE="/tmp/polybar.log"
echo "--- Starting Polybar ---" > $LOG_FILE

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main 2>&1 | tee -a $LOG_FILE &
  done
else
  polybar --reload main 2>&1 | tee -a $LOG_FILE &
fi

echo "Polybar launched..."