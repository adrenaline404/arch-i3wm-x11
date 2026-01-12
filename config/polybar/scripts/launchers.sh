#!/usr/bin/env bash
set -euo pipefail

LAUNCHERS_FILE="$HOME/.config/polybar/launchers"
[ -f "$LAUNCHERS_FILE" ] || { echo ""; exit 0; }

OUT=""
while IFS=';' read -r ICON CMD; do
    ICON="${ICON//\"/}"
    CMD="${CMD//\"/}"
    [ -z "$ICON" ] && continue
    [ -z "$CMD" ] && continue
    OUT+="%{A1:$CMD:} $ICON %{A}"
done < "$LAUNCHERS_FILE"

printf "%s" "$OUT"
