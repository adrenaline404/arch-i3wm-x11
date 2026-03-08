#!/bin/bash

CONFIG_DIR="$HOME/.config/fastfetch"
PRESET_DIR="$CONFIG_DIR/presets"
ART_DIR="$CONFIG_DIR/art"

echo "Generating Fastfetch Resources..."

mkdir -p "$PRESET_DIR"
mkdir -p "$ART_DIR"

cat > "$PRESET_DIR/01.jsonc" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "arch_small",
    "padding": { "top": 1, "left": 2, "right": 3 }
  },
  "display": { "separator": " ", "color": "white" },
  "modules": [
    "break",
    { "type": "os", "key": " ", "keyColor": "magenta" },
    { "type": "kernel", "key": " ", "keyColor": "magenta" },
    { "type": "uptime", "key": "󰅐 ", "keyColor": "magenta" },
    { "type": "packages", "key": "󰏖 ", "keyColor": "magenta" },
    { "type": "shell", "key": " ", "keyColor": "magenta" },
    { "type": "wm", "key": " ", "keyColor": "magenta" },
    { "type": "memory", "key": "󰍛 ", "keyColor": "magenta" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/02.jsonc" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "~/.config/fastfetch/art/custom_image_1.png",
    "type": "kitty",
    "height": 10,
    "padding": { "top": 1, "left": 2, "right": 3 }
  },
  "display": { "separator": " ", "color": "white" },
  "modules": [
    "break",
    { "type": "os", "key": " ", "keyColor": "magenta" },
    { "type": "kernel", "key": " ", "keyColor": "magenta" },
    { "type": "uptime", "key": "󰅐 ", "keyColor": "magenta" },
    { "type": "packages", "key": "󰏖 ", "keyColor": "magenta" },
    { "type": "shell", "key": " ", "keyColor": "magenta" },
    { "type": "wm", "key": " ", "keyColor": "magenta" },
    { "type": "memory", "key": "󰍛 ", "keyColor": "magenta" },
    "break",
    { "type": "custom", "format": "あなたにはあなた自身の意見を持つ権利はありますが、" },
    { "type": "custom", "format": "あなた自身の事実を持つ権利はありません。" }
  ]
}
EOF

cat > "$PRESET_DIR/03.jsonc" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "~/.config/fastfetch/art/custom_image_2.png",
    "type": "kitty",
    "height": 10,
    "padding": { "top": 1, "left": 2, "right": 3 }
  },
  "display": { "separator": " ", "color": "white" },
  "modules": [
    "break",
    { "type": "os", "key": " ", "keyColor": "magenta" },
    { "type": "kernel", "key": " ", "keyColor": "magenta" },
    { "type": "uptime", "key": "󰅐 ", "keyColor": "magenta" },
    { "type": "packages", "key": "󰏖 ", "keyColor": "magenta" },
    { "type": "shell", "key": " ", "keyColor": "magenta" },
    { "type": "wm", "key": " ", "keyColor": "magenta" },
    { "type": "memory", "key": "󰍛 ", "keyColor": "magenta" },
    "break",
    { "type": "custom", "format": "あなたにはあなた自身の意見を持つ権利はありますが、" },
    { "type": "custom", "format": "あなた自身の事実を持つ権利はありません。" }
  ]
}
EOF

echo "Generated 3 Fastfetch Layouts (ASCII, Image 1, Image 2)!"
chmod +x "$0"