#!/bin/bash

CONFIG_DIR="$HOME/.config/fastfetch"
PRESET_DIR="$CONFIG_DIR/presets"
ART_DIR="$CONFIG_DIR/art"

echo "Generating Fastfetch Resources..."

mkdir -p "$PRESET_DIR"
mkdir -p "$ART_DIR"

cat > "$ART_DIR/void_char.txt" << 'EOF'
       .---.        .-----------
      /     \  __  /    ------
     / /     \(  )/    -----
    //////   ' \/ `   ---
   //// / // :    : ---
  // /   /  /`    '--
 //          //..\\
        ====UU====UU====
            '//||\\`
               ''``
EOF

cat > "$PRESET_DIR/01.jsonc" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "type": "file",
    "padding": { "top": 1, "left": 0, "right": 2 }
  },
  "display": { "separator": " ", "color": "white" },
  "modules": [
    "break",
    { "type": "os", "key": " ", "keyColor": "red" },
    { "type": "kernel", "key": " ", "keyColor": "red" },
    { "type": "uptime", "key": "󰅐 ", "keyColor": "red" },
    { "type": "packages", "key": "󰏖 ", "keyColor": "red" },
    { "type": "shell", "key": " ", "keyColor": "red" },
    { "type": "wm", "key": " ", "keyColor": "red" },
    { "type": "memory", "key": "󰍛 ", "keyColor": "red" },
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
    "padding": { "top": 1, "left": 0, "right": 2 }
  },
  "display": { "separator": " ", "color": "white" },
  "modules": [
    "break",
    { "type": "os", "key": " ", "keyColor": "red" },
    { "type": "kernel", "key": " ", "keyColor": "red" },
    { "type": "uptime", "key": "󰅐 ", "keyColor": "red" },
    { "type": "packages", "key": "󰏖 ", "keyColor": "red" },
    { "type": "shell", "key": " ", "keyColor": "red" },
    { "type": "wm", "key": " ", "keyColor": "red" },
    { "type": "memory", "key": "󰍛 ", "keyColor": "red" },
    "break",
    { "type": "custom", "format": "あなたにはあなた自身の意見を持つ権利はありますが、" },
	{ "type": "custom", "format": "あなた自身の事実を持つ権利はありません。" },
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
    "padding": { "top": 1, "left": 0, "right": 2 }
  },
  "display": { "separator": " ", "color": "white" },
  "modules": [
    "break",
    { "type": "os", "key": " ", "keyColor": "red" },
    { "type": "kernel", "key": " ", "keyColor": "red" },
    { "type": "uptime", "key": "󰅐 ", "keyColor": "red" },
    { "type": "packages", "key": "󰏖 ", "keyColor": "red" },
    { "type": "shell", "key": " ", "keyColor": "red" },
    { "type": "wm", "key": " ", "keyColor": "red" },
    { "type": "memory", "key": "󰍛 ", "keyColor": "red" },
    "break",
    { "type": "custom", "format": "あなたにはあなた自身の意見を持つ権利はありますが、" },
	{ "type": "custom", "format": "あなた自身の事実を持つ権利はありません。" },
  ]
}
EOF

echo "Generated 3 Fastfetch Layouts (ASCII, Image 1, Image 2)!"
chmod +x "$0"