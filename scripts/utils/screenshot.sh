#!/bin/bash
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
flameshot gui --path "$DIR"