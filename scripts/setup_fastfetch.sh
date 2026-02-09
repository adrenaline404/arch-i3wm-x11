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
    "padding": { "top": 1, "left": 2, "right": 2 }
  },
  "display": {
    "separator": "  ",
    "color": "white"
  },
  "modules": [
    "title",
    "separator",
    { "type": "os", "key": "OS   ", "keyColor": "blue" },
    { "type": "host", "key": "HOST ", "keyColor": "blue" },
    { "type": "kernel", "key": "KER  ", "keyColor": "blue" },
    { "type": "uptime", "key": "UP   ", "keyColor": "blue" },
    { "type": "packages", "key": "PKGS ", "keyColor": "blue" },
    { "type": "shell", "key": "SH   ", "keyColor": "blue" },
    { "type": "memory", "key": "RAM  ", "keyColor": "blue" },
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
    "padding": { "top": 1, "left": 2, "right": 2 }
  },
  "display": {
    "separator": "  ",
    "color": "white"
  },
  "modules": [
    { "type": "title", "color": { "user": "blue", "at": "white", "host": "blue" } },
    "separator",
    { "type": "os", "key": "System", "keyColor": "blue" },
    { "type": "kernel", "key": "Kernel", "keyColor": "blue" },
    { "type": "wm", "key": "Window", "keyColor": "blue" },
    { "type": "cpu", "key": "CPU   ", "keyColor": "blue" },
    { "type": "memory", "key": "Memory", "keyColor": "blue" },
    { "type": "disk", "key": "Disk  ", "keyColor": "blue" },
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
    "padding": { "top": 1, "left": 2, "right": 3 }
  },
  "display": {
    "separator": "  "
  },
  "modules": [
    "title",
    "separator",
    { "type": "os", "key": "", "keyColor": "blue" },
    { "type": "kernel", "key": "", "keyColor": "blue" },
    { "type": "uptime", "key": "", "keyColor": "blue" },
    { "type": "packages", "key": "", "keyColor": "blue" },
    { "type": "wm", "key": "", "keyColor": "blue" },
    { "type": "terminal", "key": "", "keyColor": "blue" },
    { "type": "memory", "key": "", "keyColor": "blue" },
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
    "padding": { "top": 1, "left": 2, "right": 2 }
  },
  "display": {
    "separator": " "
  },
  "modules": [
    "title",
    "separator",
    { "type": "os", "key": "[DISTRO]", "keyColor": "blue" },
    { "type": "kernel", "key": "[KERNEL]", "keyColor": "blue" },
    { "type": "uptime", "key": "[UPTIME]", "keyColor": "blue" },
    { "type": "wm", "key": "[WINDOW]", "keyColor": "blue" },
    { "type": "shell", "key": "[SHELL ]", "keyColor": "blue" },
    { "type": "memory", "key": "[MEMORY]", "keyColor": "blue" },
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
    "padding": { "top": 1, "left": 2, "right": 2 }
  },
  "display": {
    "separator": " │ ",
    "color": "white"
  },
  "modules": [
    "title",
    "separator",
    { "type": "host", "key": "PC ", "keyColor": "blue" },
    { "type": "cpu", "key": "CPU", "keyColor": "blue" },
    { "type": "gpu", "key": "GPU", "keyColor": "blue" },
    { "type": "memory", "key": "RAM", "keyColor": "blue" },
    { "type": "display", "key": "RES", "keyColor": "blue" },
    { "type": "battery", "key": "BAT", "keyColor": "blue" },
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
    "padding": { "top": 1, "left": 2, "right": 2 }
  },
  "display": {
    "separator": " "
  },
  "modules": [
    "title",
    "separator",
    { "type": "os", "key": "OS ", "keyColor": "blue" },
    { "type": "kernel", "key": "KR ", "keyColor": "blue" },
    { "type": "wm", "key": "WM ", "keyColor": "blue" },
    { "type": "shell", "key": "SH ", "keyColor": "blue" },
    { "type": "terminal", "key": "TR ", "keyColor": "blue" },
    { "type": "memory", "key": "MM ", "keyColor": "blue" },
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
    "padding": { "top": 1, "left": 2, "right": 2 }
  },
  "display": {
    "separator": " | "
  },
  "modules": [
    { "type": "title", "color": { "user": "blue", "at": "white", "host": "blue" } },
    "separator",
    { "type": "os", "key": "sys", "keyColor": "blue" },
    { "type": "kernel", "key": "ker", "keyColor": "blue" },
    { "type": "uptime", "key": "up ", "keyColor": "blue" },
    { "type": "packages", "key": "pkg", "keyColor": "blue" },
    { "type": "wm", "key": "win", "keyColor": "blue" },
    { "type": "memory", "key": "ram", "keyColor": "blue" },
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
    "padding": { "top": 1, "left": 2, "right": 2 }
  },
  "display": {
    "separator": " • "
  },
  "modules": [
    "title",
    "separator",
    { "type": "os", "key": "Arch", "keyColor": "blue" },
    { "type": "wm", "key": "View", "keyColor": "blue" },
    { "type": "shell", "key": "Cmd ", "keyColor": "blue" },
    { "type": "terminal", "key": "Term", "keyColor": "blue" },
    { "type": "cpu", "key": "Chip", "keyColor": "blue" },
    { "type": "memory", "key": "Data", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

echo "Generated 8 Fastfetch Layouts!"
chmod +x "$0"