#!/bin/bash

CONFIG_DIR="$HOME/.config/fastfetch"
PRESET_DIR="$CONFIG_DIR/presets"
ART_DIR="$CONFIG_DIR/art"

echo "[!] Generating Fastfetch Configs..."

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
    "padding": { "top": 2, "left": 2 }
  },
  "display": { "separator": "   " },
  "modules": [
    "title", "separator",
    { "type": "os", "key": " OS", "keyColor": "blue" },
    { "type": "host", "key": "󰌢 PC", "keyColor": "blue" },
    { "type": "kernel", "key": " Ker", "keyColor": "blue" },
    { "type": "uptime", "key": "󰅐 Up", "keyColor": "blue" },
    { "type": "packages", "key": "󰮯 Pkg", "keyColor": "blue" },
    { "type": "shell", "key": " Sh", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/02.jsonc" << 'EOF'
{
  "logo": { "source": "arch", "color": {"1": "blue"} },
  "display": { "separator": " │ " },
  "modules": [
    "title", "separator",
    { "type": "cpu", "key": " CPU", "keyColor": "green" },
    { "type": "gpu", "key": "󰢮 GPU", "keyColor": "green" },
    { "type": "memory", "key": "󰘚 RAM", "keyColor": "green" },
    { "type": "disk", "key": " DSK", "keyColor": "green" },
    { "type": "battery", "key": " BAT", "keyColor": "green" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/03.jsonc" << 'EOF'
{
  "logo": { "type": "none" },
  "modules": [
    { "type": "title", "format": "Welcome back, {user}" },
    "separator",
    { "type": "os", "key": "SYSTEM", "keyColor": "red" },
    { "type": "wm", "key": "WINDOW", "keyColor": "red" },
    { "type": "terminal", "key": "TERM  ", "keyColor": "red" },
    { "type": "shell", "key": "SHELL ", "keyColor": "red" }
  ]
}
EOF

cat > "$PRESET_DIR/04.jsonc" << 'EOF'
{
  "logo": { "source": "arch_small", "color": {"1": "magenta"} },
  "modules": [
    "title", "separator",
    { "type": "wm", "key": " WM", "keyColor": "magenta" },
    { "type": "theme", "key": " GTK", "keyColor": "magenta" },
    { "type": "icons", "key": "󰀻 ICO", "keyColor": "magenta" },
    { "type": "font", "key": " FNT", "keyColor": "magenta" },
    { "type": "cursor", "key": " CUR", "keyColor": "magenta" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/05.jsonc" << 'EOF'
{
  "logo": { "type": "small" },
  "display": { "separator": " " },
  "modules": [
    { "type": "os", "key": " ", "keyColor": "cyan" },
    { "type": "kernel", "key": " ", "keyColor": "cyan" },
    { "type": "uptime", "key": "󰅐 ", "keyColor": "cyan" },
    { "type": "packages", "key": "󰮯 ", "keyColor": "cyan" },
    { "type": "memory", "key": "󰘚 ", "keyColor": "cyan" }
  ]
}
EOF

cat > "$PRESET_DIR/06.jsonc" << 'EOF'
{
  "logo": { "source": "~/.config/fastfetch/art/void_char.txt", "padding": { "top": 1 } },
  "display": { "separator": "  " },
  "modules": [
    "title",
    { "type": "os", "key": "OS ", "keyColor": "yellow" },
    { "type": "wm", "key": "WM ", "keyColor": "yellow" },
    { "type": "shell", "key": "SH ", "keyColor": "yellow" },
    { "type": "terminal", "key": "TR ", "keyColor": "yellow" },
    "break",
    "colors"
  ]
}
EOF

cat > "$PRESET_DIR/07.jsonc" << 'EOF'
{
  "logo": { "source": "arch" },
  "modules": [
    "title", "separator",
    "host", "cpu", "gpu", "display", "memory", "swap", "disk", "localip", "battery", "poweradapter"
  ]
}
EOF

cat > "$PRESET_DIR/08.jsonc" << 'EOF'
{
  "logo": {
    "source": "~/.config/fastfetch/art/void_char.txt",
    "padding": { "top": 2, "left": 2 }
  },
  "modules": [
    { "type": "title", "color": { "user": "red", "at": "white", "host": "blue" } },
    "separator",
    { "type": "os", "key": "DISTRO", "keyColor": "red" },
    { "type": "wm", "key": "WINDOW", "keyColor": "blue" },
    { "type": "uptime", "key": "ACTIVE", "keyColor": "green" },
    "break",
    "colors"
  ]
}
EOF

echo "[!] Fastfetch: 8 Presets & Art Generated in $CONFIG_DIR"