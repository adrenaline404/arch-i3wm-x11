---

# arch-i3wm-x11

![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?logo=arch-linux&logoColor=white)
![i3wm](https://img.shields.io/badge/i3wm-Tiling_WM-2E3440)
![X11](https://img.shields.io/badge/X11-Stable_Display_Server-555555)

A **stable, minimal, and modern i3wm (X11) setup for Arch Linux**, designed specifically for **low-end and older Intel-based laptops**.

---

## ✨ Features

- **i3wm (X11)** — mature, predictable tiling window manager
- **Polybar** — lightweight and themeable status bar
- **Rofi** — application launcher & power menu
- **Picom** — compositor with *auto-disable on fullscreen*
- **xsecurelock + xss-lock** — modern and secure lockscreen
- **Dunst** — notification daemon (volume & brightness OSD)
- **Brightness & volume control** (media keys supported)
- **Screenshot tool** (selection-based)
- **Dynamic theme switching (runtime)**
  - Catppuccin
  - Nord
- **Wallpaper management**
- **Systemd-native suspend & lid handling**

---

## 🖥 Target Hardware

Optimized for:

- Intel iGPU (HD 4000/4400/similar)
- Low-power CPUs (Core i3 / i5 U-series)
- 4–8 GB RAM
- Laptop usage (lid close suspend, brightness keys)

Tested conceptually for devices like:

- ASUS X540 series
- ThinkPad X/T series (older gens)

---

## 📁 Repository Structure

```text
arch-i3wm-x11/
├── install.sh
├── README.md
├── LICENSE
├── .xinitrc
├── config/
│   ├── i3/
│   ├── polybar/
│   ├── rofi/
│   ├── dunst/
│   └── themes/
└── wallpaper/
```

All configuration files are installed into `~/.config/`.

---

## 📦 Dependencies

Installed automatically via `install.sh`.

Main components:

- `i3-wm`
- `xorg-xinit`
- `polybar`
- `rofi`
- `picom`
- `dunst`
- `feh`
- `maim`
- `brightnessctl`
- `pamixer`
- `alacritty`
- `xsecurelock`
- `xss-lock`
- `imagemagick`
- Nerd Fonts + Noto Fonts

No AUR packages required.

---

## 🚀 Installation

1. Clone repository

```bash
git clone https://github.com/adrenaline404/arch-i3wm-x11.git
cd arch-i3wm-x11
```

2. Run installer

```bash
chmod +x install.sh
./install.sh
```

This will:

- Install required packages
- Copy configs into `~/.config`
- Install `.xinitrc`
- Set executable permissions

3. Start session

```bash
startx
```

This setup is startx-first. Display managers are not officially supported.

---

## 🔐 Lockscreen & Power Management

- Lockscreen: `xsecurelock`
- Lock shortcut: Mod + Shift + X
- Suspend & lid close handled by `systemd-logind`

Recommended config:

```ini
# /etc/systemd/logind.conf
HandleLidSwitch=suspend
HandlePowerKey=suspend
```

Apply:

```bash
sudo systemctl restart systemd-logind
```

---

## 🎨 Themes & Appearance

Available themes:

- Catppuccin
- Nord

Switch theme without logout:

- `Mod + Shift + E`

This updates:

- Polybar colors
- Wallpaper
- Reloads i3 config

---

## ⌨ Keybindings (Essential)

- Terminal — `Mod + Enter`
- App launcher — `Mod + D`
- Theme switcher — `Mod + Shift + E`
- Lock screen — `Mod + Shift + X`
- Screenshot — `Print`
- Volume up — `XF86AudioRaiseVolume`
- Volume down — `XF86AudioLowerVolume`
- Mute — `XF86AudioMute`
- Brightness up — `XF86MonBrightnessUp`
- Brightness down — `XF86MonBrightnessDown`

---

## 🧠 Design Philosophy

- X11-first for maximum compatibility
- No unnecessary visual effects
- Compositor disabled automatically on fullscreen
- Systemd-native power handling
- Readable and auditable shell scripts

---

## 🛠 Troubleshooting FAQ

**Polybar does not appear**

Cause: Missing fonts

Fix:

```bash
polybar -l info main
```

Ensure Nerd Fonts are installed.

**Icons missing in Polybar or Rofi**

Cause: Nerd Font not applied

Fix:

```bash
fc-list | grep Nerd
```

**Brightness keys do not work**

Cause: Different backlight device

Fix:

```bash
ls /sys/class/backlight
```

**Screen does not lock on lid close**

Cause: `systemd-logind` misconfiguration

Fix: Ensure `HandleLidSwitch=suspend`

**Picom causes issues**

Fix:

```bash
pkill picom
```

Adjust `picom.conf` if necessary.

---

## 📜 License

- MIT License — see LICENSE

---

## ⚠ Disclaimer

- These are personal dotfiles.
- Always back up existing configuration before use.
