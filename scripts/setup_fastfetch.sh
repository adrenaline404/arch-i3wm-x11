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
 //        //..\\
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
    "padding": { "top": 1, "left": 2, "right": 3 }
  },
  "display": { "separator": " 󰁔 ", "color": "white" },
  "modules": [
    "break",
    { "type": "os", "key": " OS ", "keyColor": "red" },
    { "type": "kernel", "key": " KER", "keyColor": "red" },
    { "type": "uptime", "key": "󰅐 UPT", "keyColor": "red" },
    { "type": "packages", "key": "󰏖 PKG", "keyColor": "red" },
    { "type": "shell", "key": " SHL", "keyColor": "red" },
    { "type": "wm", "key": " WM ", "keyColor": "red" },
    { "type": "memory", "key": "󰍛 RAM", "keyColor": "red" },
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
    "height": 16,
    "padding": { "top": 1, "left": 2, "right": 4 }
  },
  "display": { "separator": " 󰁔 ", "color": "white" },
  "modules": [
    "break",
    { "type": "os", "key": " OS ", "keyColor": "red" },
    { "type": "kernel", "key": " KER", "keyColor": "red" },
    { "type": "uptime", "key": "󰅐 UPT", "keyColor": "red" },
    { "type": "packages", "key": "󰏖 PKG", "keyColor": "red" },
    { "type": "shell", "key": " SHL", "keyColor": "red" },
    { "type": "wm", "key": " WM ", "keyColor": "red" },
    { "type": "memory", "key": "󰍛 RAM", "keyColor": "red" },
    "break",
    { "type": "custom", "format": "あなたにはあなた自身の意見を持つ権利はありますが、あなた自身の事実を持つ権利はありません。" },
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/03.jsonc" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "~/.config/fastfetch/art/custom_image_2.png",
    "type": "kitty",
    "height": 16,
    "padding": { "top": 1, "left": 2, "right": 4 }
  },
  "display": { "separator": " 󰁔 ", "color": "white" },
  "modules": [
    "break",
    { "type": "os", "key": " OS ", "keyColor": "red" },
    { "type": "kernel", "key": " KER", "keyColor": "red" },
    { "type": "uptime", "key": "󰅐 UPT", "keyColor": "red" },
    { "type": "packages", "key": "󰏖 PKG", "keyColor": "red" },
    { "type": "shell", "key": " SHL", "keyColor": "red" },
    { "type": "wm", "key": " WM ", "keyColor": "red" },
    { "type": "memory", "key": "󰍛 RAM", "keyColor": "red" },
    "break",
    { "type": "custom", "format": "あなたにはあなた自身の意見を持つ権利はありますが、あなた自身の事実を持つ権利はありません。" },
    "colors"
  ]
}
EOF

echo "Generated 3 Fastfetch Layouts (ASCII, Image 1, Image 2)!"
chmod +x "$0"