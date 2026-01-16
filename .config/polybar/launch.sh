#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

CONFIG_DIR="$HOME/.config/polybar/config.ini"
LOG_FILE="/tmp/polybar.log"

echo "--- Launching Polybar ---" > $LOG_FILE

if ! command -v xrandr &> /dev/null; then
  echo "xrandr not found. Launching fallback." | tee -a $LOG_FILE
  polybar --reload main --config="$CONFIG_DIR" >> $LOG_FILE 2>&1 &
  exit 0
fi

MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)

if [ -z "$MONITORS" ]; then
  echo "No monitors detected. Launching standard." | tee -a $LOG_FILE
  polybar --reload main --config="$CONFIG_DIR" >> $LOG_FILE 2>&1 &
else
  for m in $MONITORS; do
    echo "Launching on monitor: $m" | tee -a $LOG_FILE
    MONITOR=$m polybar --reload main --config="$CONFIG_DIR" >> $LOG_FILE 2>&1 &
  done
fi

echo "Polybar launched successfully." | tee -a $LOG_FILE