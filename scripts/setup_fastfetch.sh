#!/bin/bash

CONFIG_DIR="$HOME/.config/fastfetch"
PRESET_DIR="$CONFIG_DIR/presets"
ART_DIR="$CONFIG_DIR/art"

echo "Generating Fastfetch Resources..."

mkdir -p "$PRESET_DIR"
mkdir -p "$ART_DIR"

cat > "$ART_DIR/void_char.txt" << 'EOF'
${c1}       .---.        .-----------
${c1}      /     \  __  /    ------
${c1}     / /     \(  )/    -----
${c1}    //////   ' \/ `   ---
${c1}   //// / // :    : ---
${c1}  // /   /  /`    '--
${c1} //          //..\\
${c1}        ====UU====UU====
${c1}            '//||\`
${c1}              ''``
EOF

cat > "$PRESET_DIR/01.jsonc" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "type": "file",
    "padding": { "top": 1, "left": 2 }
  },
  "display": { "separator": "   " },
  "modules": [
    "title", "separator",
    { "type": "os", "key": " OS", "keyColor": "blue" },
    { "type": "host", "key": "󰌢 PC", "keyColor": "blue" },
    { "type": "kernel", "key": " KR", "keyColor": "blue" },
    { "type": "uptime", "key": "󰅐 UP", "keyColor": "blue" },
    { "type": "packages", "key": "󰮯 PK", "keyColor": "blue" },
    { "type": "memory", "key": "󰘚 MM", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/02.jsonc" << 'EOF'
{
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "type": "file",
    "padding": { "top": 1, "left": 2 }
  },
  "display": { "separator": " │ " },
  "modules": [
    "title", "separator",
    { "type": "cpu", "key": " CPU", "keyColor": "blue" },
    { "type": "gpu", "key": "󰢮 GPU", "keyColor": "blue" },
    { "type": "disk", "key": " DSK", "keyColor": "blue" },
    { "type": "memory", "key": "󰘚 RAM", "keyColor": "blue" },
    { "type": "battery", "key": " BAT", "keyColor": "blue" },
    { "type": "poweradapter", "key": " PWR", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/03.jsonc" << 'EOF'
{
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "type": "file",
    "padding": { "top": 1, "left": 2 }
  },
  "display": { "separator": " • " },
  "modules": [
    "title", "separator",
    { "type": "wm", "key": " WM", "keyColor": "blue" },
    { "type": "shell", "key": " SH", "keyColor": "blue" },
    { "type": "terminal", "key": " TR", "keyColor": "blue" },
    { "type": "theme", "key": " TH", "keyColor": "blue" },
    { "type": "icons", "key": "󰀻 IC", "keyColor": "blue" },
    { "type": "font", "key": " FT", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/04.jsonc" << 'EOF'
{
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "type": "file",
    "padding": { "top": 1, "left": 2 }
  },
  "display": { "separator": " " },
  "modules": [
    "title", "separator",
    { "type": "os", "key": "OS", "keyColor": "blue" },
    { "type": "kernel", "key": "KR", "keyColor": "blue" },
    { "type": "uptime", "key": "UP", "keyColor": "blue" },
    { "type": "packages", "key": "PK", "keyColor": "blue" },
    { "type": "memory", "key": "MM", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/05.jsonc" << 'EOF'
{
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "type": "file",
    "padding": { "top": 1, "left": 2 }
  },
  "display": { "separator": "  " },
  "modules": [
    "title", "separator",
    { "type": "os", "key": " ", "keyColor": "blue" },
    { "type": "wm", "key": " ", "keyColor": "blue" },
    { "type": "shell", "key": " ", "keyColor": "blue" },
    { "type": "terminal", "key": " ", "keyColor": "blue" },
    { "type": "memory", "key": "󰘚 ", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/06.jsonc" << 'EOF'
{
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "type": "file",
    "padding": { "top": 1, "left": 2 }
  },
  "display": { "separator": " " },
  "modules": [
    "title", "separator",
    { "type": "os", "key": "[ DISTRO ]", "keyColor": "blue" },
    { "type": "host", "key": "[ SYSTEM ]", "keyColor": "blue" },
    { "type": "kernel", "key": "[ KERNEL ]", "keyColor": "blue" },
    { "type": "uptime", "key": "[ UPTIME ]", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/07.jsonc" << 'EOF'
{
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "type": "file",
    "padding": { "top": 1, "left": 2 }
  },
  "display": { "separator": "  " },
  "modules": [
    { "type": "title", "color": { "user": "blue", "at": "white", "host": "blue" } },
    "separator",
    { "type": "os", "format": "{3}", "key": "", "keyColor": "blue" },
    { "type": "kernel", "format": "{2}", "key": "", "keyColor": "blue" },
    { "type": "wm", "format": "{2}", "key": "", "keyColor": "blue" },
    { "type": "memory", "key": "󰘚", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/08.jsonc" << 'EOF'
{
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "type": "file",
    "padding": { "top": 1, "left": 2 }
  },
  "display": { "separator": " " },
  "modules": [
    "title", "separator",
    { "type": "os", "key": "OS ", "keyColor": "blue" },
    { "type": "wm", "key": "WM ", "keyColor": "blue" },
    { "type": "shell", "key": "SH ", "keyColor": "blue" },
    { "type": "uptime", "key": "UP ", "keyColor": "blue" },
    { "type": "packages", "key": "PK ", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

echo "Generated 8 Unique Fastfetch Layouts with Void Character!"