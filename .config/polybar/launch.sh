#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

LOG_FILE="/tmp/polybar.log"
echo "--- Polybar Launch $(date) ---" > $LOG_FILE

if ! command -v xrandr &> /dev/null; then
  echo "WARNING: xrandr not found! Launching in fallback mode (single monitor)." | tee -a $LOG_FILE
  polybar --reload main 2>&1 | tee -a $LOG_FILE &
  exit 0
fi

MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)

if [ -z "$MONITORS" ]; then
  echo "ERROR: No monitors detected by xrandr. Fallback launch." | tee -a $LOG_FILE
  polybar --reload main 2>&1 | tee -a $LOG_FILE &
else
  for m in $MONITORS; do
    echo "Launching polybar on monitor: $m" | tee -a $LOG_FILE
    MONITOR=$m polybar --reload main 2>&1 | tee -a $LOG_FILE &
  done
fi

echo "Polybar launch script finished." | tee -a $LOG_FILE