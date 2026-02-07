#!/bin/bash

CONFIG_DIR="$HOME/.config/fastfetch"
PRESET_DIR="$CONFIG_DIR/presets"
ART_DIR="$CONFIG_DIR/art"

echo "Generating Professional Fastfetch Resources..."

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
            '//||\`
              ''``
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
    "title",
    "separator",
    { "type": "os", "key": " SYSTEM", "keyColor": "blue" },
    { "type": "kernel", "key": " KERNEL", "keyColor": "blue" },
    { "type": "uptime", "key": "󰅐 UPTIME", "keyColor": "blue" },
    { "type": "packages", "key": "󰮯 PKGS", "keyColor": "blue" },
    { "type": "wm", "key": " WINDOW", "keyColor": "blue" },
    { "type": "terminal", "key": " TERM", "keyColor": "blue" },
    { "type": "cpu", "key": " CPU", "keyColor": "blue" },
    { "type": "memory", "key": "󰘚 RAM", "keyColor": "blue" },
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
    "title",
    "separator",
    { "type": "host", "key": "PC ", "keyColor": "blue" },
    { "type": "cpu", "key": "CPU", "keyColor": "blue" },
    { "type": "gpu", "key": "GPU", "keyColor": "blue" },
    { "type": "disk", "key": "DSK", "keyColor": "blue" },
    { "type": "memory", "key": "RAM", "keyColor": "blue" },
    { "type": "display", "key": "DSP", "keyColor": "blue" },
    { "type": "battery", "key": "BAT", "keyColor": "blue" },
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
  "display": { "separator": " ➜  " },
  "modules": [
    "title",
    "separator",
    { "type": "shell", "key": "SHELL", "keyColor": "blue" },
    { "type": "terminal", "key": "TERM ", "keyColor": "blue" },
    { "type": "wm", "key": "DE/WM", "keyColor": "blue" },
    { "type": "theme", "key": "THEME", "keyColor": "blue" },
    { "type": "icons", "key": "ICONS", "keyColor": "blue" },
    { "type": "font", "key": "FONT ", "keyColor": "blue" },
    { "type": "localip", "key": "NET  ", "keyColor": "blue" },
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
    "title",
    "separator",
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
    "title",
    "separator",
    { "type": "os", "key": " ", "keyColor": "blue" },
    { "type": "kernel", "key": " ", "keyColor": "blue" },
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
    "title",
    "separator",
    { "type": "os", "key": "[ DISTRO ]", "keyColor": "blue" },
    { "type": "kernel", "key": "[ KERNEL ]", "keyColor": "blue" },
    { "type": "wm", "key": "[ WINDOW ]", "keyColor": "blue" },
    { "type": "uptime", "key": "[ UPTIME ]", "keyColor": "blue" },
    { "type": "memory", "key": "[ MEMORY ]", "keyColor": "blue" },
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
  "display": { "separator": " : " },
  "modules": [
    { "type": "title", "color": { "user": "blue", "at": "white", "host": "blue" } },
    "separator",
    { "type": "os", "key": "SYS", "keyColor": "blue" },
    { "type": "kernel", "key": "KER", "keyColor": "blue" },
    { "type": "wm", "key": "WIN", "keyColor": "blue" },
    { "type": "packages", "key": "PKG", "keyColor": "blue" },
    { "type": "shell", "key": "SHL", "keyColor": "blue" },
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
    "title",
    "separator",
    { "type": "os", "key": "OS ", "keyColor": "blue" },
    { "type": "kernel", "key": "KR ", "keyColor": "blue" },
    { "type": "uptime", "key": "UP ", "keyColor": "blue" },
    { "type": "packages", "key": "PK ", "keyColor": "blue" },
    { "type": "memory", "key": "MM ", "keyColor": "blue" },
    "break",
    "colors"
  ]
}
EOF

echo "Generated 8 Professional Fastfetch Layouts!"