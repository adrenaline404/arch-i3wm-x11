#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

fail=0
warn=0

ok() { printf "%b[OK]%b %s\n" "$GREEN" "$NC" "$1"; }
warnf() { warn=$((warn+1)); printf "%b[WARN]%b %s\n" "$YELLOW" "$NC" "$1"; }
err() { fail=$((fail+1)); printf "%b[FAIL]%b %s\n" "$RED" "$NC" "$1"; }

echo "Validating runtime configuration for arch-i3wm-x11"

check_cmd() {
    if command -v "$1" >/dev/null 2>&1; then
        ok "Found command: $1"
    else
        warnf "Missing command: $1"
    fi
}

echo "\nChecking required commands"
for cmd in polybar rofi picom dunst brightnessctl xbacklight systemctl fc-cache pamixer maim xclip; do
    check_cmd "$cmd"
done

echo "\nChecking backlight devices"
if [ -d /sys/class/backlight ] && [ "$(ls -A /sys/class/backlight 2>/dev/null || true)" != "" ]; then
    for d in /sys/class/backlight/*; do
        echo " - backlight device: $(basename "$d")"
    done
    ok "Backlight device(s) detected"
else
    warnf "No backlight device detected in /sys/class/backlight"
fi

echo "\nChecking power supply (battery/adapter)"
if [ -d /sys/class/power_supply ] && [ "$(ls -A /sys/class/power_supply 2>/dev/null || true)" != "" ]; then
    BAT=$(ls /sys/class/power_supply | grep -E '^BAT' | head -n1 || true)
    AC=$(ls /sys/class/power_supply | grep -i '^AC' | head -n1 || true)
    [ -n "$BAT" ] && ok "Battery detected: $BAT" || warnf "No battery (BAT*) detected"
    [ -n "$AC" ] && ok "AC adapter detected: $AC" || warnf "No AC adapter (AC*) detected"
else
    warnf "No /sys/class/power_supply entries found"
fi

echo "\nChecking Polybar configuration expectations"
CFG="${HOME}/.config/polybar/config.ini"
if [ -f "$CFG" ]; then
    if grep -q "\$\{env:BACKLIGHT_CARD" "$CFG" 2>/dev/null; then
        ok "Polybar config references BACKLIGHT_CARD env"
    else
        warnf "Polybar config does not reference BACKLIGHT_CARD env"
    fi
    if grep -q "\$\{env:POLYBAR_BATTERY" "$CFG" 2>/dev/null; then
        ok "Polybar config references POLYBAR_BATTERY env"
    else
        warnf "Polybar config does not reference POLYBAR_BATTERY env"
    fi
else
    warnf "Polybar config ($CFG) not present in user config (this is optional)"
fi

echo "\nChecking Rofi powermenu themes for numeric location"
RASI_DIR="$HOME/.config/rofi"
found=0
for f in "$RASI_DIR"/powermenu*.rasi; do
    [ -f "$f" ] || continue
    found=1
    if grep -Eq "location:\s*[0-9]+" "$f"; then
        ok "Numeric location in $(basename "$f")"
    else
        err "Non-numeric or missing location in $(basename "$f")"
    fi
done
if [ $found -eq 0 ]; then
    warnf "No powermenu rasi files found in $RASI_DIR"
fi

echo "\nScanning config/ for inline comment lines in scripts (excluding shebang)"
bad=0
while IFS= read -r -d '' file; do
    lineno=0
    while IFS= read -r line; do
        lineno=$((lineno+1))
        if [ $lineno -eq 1 ] && [[ $line == \#!* ]]; then
            continue
        fi
        if [[ $line =~ ^[[:space:]]*# ]]; then
            printf "%b" "${YELLOW}" >/dev/null 2>&1 || true
            printf "Inline comment in %s:%d\n" "$file" "$lineno"
            bad=1
        fi
    done < "$file"
done < <(find config -type f \( -name "*.sh" -o -name "*.rasi" -o -name "*.conf" -o -name "*.ini" \) -print0)

if [ $bad -eq 0 ]; then
    ok "No inline comment lines found in checked config scripts"
else
    warnf "Some inline comments found in config scripts; consider removing if you want fully cleaned files"
fi

echo "\nChecking for insecure chmod suggestions"
if grep -R --line-number "chmod 666" . 2>/dev/null | grep -q .; then
    err "Found occurrences of 'chmod 666' - review and replace with udev rule or safer perms"
else
    ok "No 'chmod 666' suggestions found"
fi

echo "\nSummary: failures=$fail warnings=$warn"
if [ $fail -gt 0 ]; then
    echo "One or more FAIL items detected. Fix before install." >&2
    exit 2
fi
if [ $warn -gt 0 ]; then
    echo "Warnings detected; install can proceed but review warnings." >&2
    exit 1
fi
echo "All checks passed"
exit 0
