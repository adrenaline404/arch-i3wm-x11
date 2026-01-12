#!/usr/bin/env bash
set -euo pipefail

if ! command -v xsecurelock >/dev/null 2>&1; then
    if command -v i3lock >/dev/null 2>&1; then
        i3lock -c 000000
    else
        echo "Error: Neither xsecurelock nor i3lock is installed" >&2
        exit 1
    fi
else
    xsecurelock
fi
