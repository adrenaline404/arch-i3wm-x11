#!/bin/bash

CONFIG_FILE="/tmp/audio-visualizer-config"
FIFO_FILE="/tmp/audio-visualizer-fifo"

if [ ! -p "$FIFO_FILE" ]; then
    mkfifo "$FIFO_FILE" 2>/dev/null
fi

cat > "$CONFIG_FILE" << 'EOF'
[general]
bars = 8
framerate = 30

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /tmp/audio-visualizer-fifo
data_format = ascii
ascii_max_range = 7
bar_delimiter = 32

[smoothing]
noise_reduction = 75
EOF

pkill -f "cava -p $CONFIG_FILE" 2>/dev/null

cava -p "$CONFIG_FILE" &>/dev/null &
CAVA_PID=$!

cleanup() {
    kill $CAVA_PID 2>/dev/null
    rm -f "$FIFO_FILE" "$CONFIG_FILE"
    exit 0
}

trap cleanup EXIT INT TERM

BARS="▁▂▃▄▅▆▇█"

COLOR_LOW="%{F#98c379}"
COLOR_MID="%{F#e5c07b}"
COLOR_HIGH="%{F#e06c75}"
COLOR_RESET="%{F-}"

get_color() {
    local val=$1
    if [ "$val" -le 2 ]; then
        echo "$COLOR_LOW"
    elif [ "$val" -le 5 ]; then
        echo "$COLOR_MID"
    else
        echo "$COLOR_HIGH"
    fi
}

while read -r line; do
    output=" "
    
    for val in $line; do
        [ "$val" -lt 0 ] && val=0
        [ "$val" -gt 7 ] && val=7
        
        char="${BARS:$val:1}"
        color=$(get_color "$val")
        
        output="${output}${color}${char}${COLOR_RESET} "
    done
    
    echo "$output"
    sleep 0.016
done < "$FIFO_FILE"