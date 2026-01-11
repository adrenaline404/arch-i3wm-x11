# arch-i3wm-x11

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)
![i3wm](https://img.shields.io/badge/i3wm-X11-black?style=flat&logo=i3&logoColor=white)
![X11](https://img.shields.io/badge/X11-Display_Server-blue?style=flat)
![LightDM](https://img.shields.io/badge/LightDM-Supported-green?style=flat)

A clean, modern, and lightweight i3wm (X11) configuration for Arch Linux.
Designed to be LightDM-safe, laptop-friendly, and easy to deploy via a single install script.

This repository targets:
- Arch Linux
- i3wm + LightDM
- X11 session (NOT Wayland)
- Low-to-mid spec laptops (Intel iGPU friendly)

---

## Features

- i3wm (X11) — clean and minimal
- xsecurelock — modern lockscreen
- Polybar — icon-based, lightweight
- Rofi — launcher & power menu
- Dunst — notification daemon
- Catppuccin & Nord themes
- Wallpaper switcher
- Volume OSD (pamixer)
- Brightness control (brightnessctl)
- Screenshot tool (maim + clipboard)
- picom with fullscreen auto-disable
- LightDM-safe (no startx, no .xinitrc)

---

## Repository Structure

```text
arch-i3wm-x11/
├── install.sh
├── README.md
├── LICENSE
├── config/
│   ├── i3/
│   │   ├── config
│   │   ├── autostart.sh
│   │   ├── lock.sh
│   │   └── scripts/
│   │       ├── volume.sh
│   │       ├── brightness.sh
│   │       └── screenshot.sh
│   ├── polybar/
│   │   ├── launch.sh
│   │   ├── config.ini
│   │   └── themes/
│   │       ├── catppuccin.ini
│   │       └── nord.ini
│   ├── rofi/
│   │   ├── launcher.rasi
│   │   ├── powermenu.rasi
│   │   └── theme-switcher.sh
│   ├── dunst/
│   │   └── dunstrc
│   └── picom/
│       └── picom.conf
└── wallpaper/
    ├── catppuccin.jpg
    ├── nord.jpg
```

---

## Requirements

- Arch Linux
- X11 session
- LightDM (recommended)
- Internet connection

---

## Installation

1. Clone the repository:
```bash
git clone https://github.com/adrenaline404/arch-i3wm-x11.git
cd arch-i3wm-x11
```

2. Run the installer:
```bash
chmod +x install.sh
./install.sh
```

---

## Default Keybindings

```text
Super + Enter        → Terminal
Super + D            → Rofi launcher
Super + Shift + E    → Power menu
Super + Shift + X    → Lock screen
Print                → Screenshot (selection → clipboard)
XF86Audio*           → Volume control
XF86MonBrightness*   → Brightness control
```

---

## License

MIT License

---

Maintained by adrenaline404
