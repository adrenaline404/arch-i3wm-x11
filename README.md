
# Arch i3wm X11 Dotfiles

![License](https://img.shields.io/badge/license-MIT-green.svg) ![Platform](https://img.shields.io/badge/platform-Arch%20Linux-blue.svg) ![WM](https://img.shields.io/badge/window--manager-i3-orange.svg) ![Display](https://img.shields.io/badge/display-X11-lightgrey.svg) ![Repo](https://img.shields.io/github/stars/adrenaline404/arch-i3wm-x11?style=social)

Modern i3wm dotfiles with dual-theme support (Black & Ocean), optimized for Arch Linux on X11. This repository provides a preconfigured desktop stack: i3, Polybar, Picom (compositor), Rofi, Alacritty, Dunst, and PipeWire integration.

## Overview

This repository contains a portable i3/X11 configuration that can be installed on an Arch Linux system. It includes an automated installer script, a theme switcher, theme assets (colors & wallpapers), and ready-to-use configuration files under `.config/`.

## What this project contains

- **Installer script**: `scripts/setup/install.sh` — updates the system, installs required packages (pacman + AUR via `yay`), enables LightDM, backs up existing configs, and deploys the dotfiles.
- **Theme switcher**: `scripts/theme-switcher/switch-theme.sh` — switch between `black` and `ocean` themes; updates `~/.Xresources`, `rofi`, `alacritty`, `dunst`, `polybar`, `picom`, wallpaper, and reloads i3.
- **Themes**: `themes/black` and `themes/ocean` — each contains `colors/Xresources` and `wallpapers/main.jpg`.
- **Configs**: `.config/` contains subfolders for `i3`, `picom`, `polybar`, `rofi`, `alacritty`, `dunst`, `starship`, `gtk-3.0`, and more.

## Key features

- One-command installer for Arch Linux (uses `pacman`; installs `yay` if missing).
- Dual theme system (Black & Ocean) with instant runtime switching.
- Prebuilt configurations for i3, Polybar, Picom, Rofi, Alacritty, Dunst, and GTK.
- Installer backs up user configs before deploying.

## Quick installation

1. Clone the repository:

```bash
cd ~
git clone https://github.com/adrenaline404/arch-i3wm-x11.git
cd arch-i3wm-x11
```

2. Run the installer (do not run as root):

```bash
chmod +x scripts/setup/install.sh
./scripts/setup/install.sh
```

After installation, a reboot is recommended:

```bash
reboot
```

## What the installer does (summary)

- Runs `sudo pacman -Syu` and installs a curated list of packages including `i3-wm`, `polybar`, `rofi`, `alacritty`, `dunst`, `lightdm`, Xorg packages, fonts, and utilities.
- Installs an AUR helper (`yay`) if not present and uses it to install AUR packages such as `picom-git`, `starship`, and `nitrogen`.
- Enables `lightdm` service and creates commonly used directories (`~/.config`, `~/Pictures/Wallpapers`, etc.).
- Backs up any existing `~/.config/{i3,picom,polybar,rofi,alacritty,dunst,starship}` to `~/.config_backup_<timestamp>`.
- Copies repo `.config/`, `.Xresources`, `.xinitrc`, `themes/` and `scripts/` into the user's home, sets executable permissions where needed, and runs the theme switcher to the default `black` theme.

## Theme switching

Use the theme switcher to change colors and assets at runtime:

```bash
./scripts/theme-switcher/switch-theme.sh black
./scripts/theme-switcher/switch-theme.sh ocean
```

The switcher replaces `~/.Xresources`, updates `rofi`, `alacritty`, and `dunst` configs, restarts `dunst`, reloads `polybar` and `picom`, reloads i3, and applies the wallpaper with `nitrogen`.

## Shortcuts (installed defaults)

- `Super + Enter` — open terminal
- `Super + d` — launcher (Rofi)
- `Super + q` — close window
- `Super + f` — toggle fullscreen
- `Super + Shift + Space` — toggle floating
- `Super + 1..0` — switch workspaces

## Troubleshooting & tips

- Polybar not visible: check `~/.config/polybar/launch.sh` and ensure it's executable.
- Picom not running (no blur/transparency):

```bash
picom --config ~/.config/picom/picom.conf &
```

- Theme not applied: reload X resources and i3:

```bash
xrdb -merge ~/.Xresources
i3-msg reload
```

- PipeWire: check services and enable if necessary:

```bash
systemctl --user status pipewire pipewire-pulse wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

- Screen tearing: ensure `picom` uses the `glx` backend and `vsync = true` in its config.

## Repository layout

- `.config/` — i3, picom, polybar, rofi, alacritty, dunst, starship, gtk-3.0
- `scripts/setup/install.sh` — installer script
- `scripts/theme-switcher/switch-theme.sh` — theme switcher
- `themes/black` & `themes/ocean` — theme colors and wallpapers
- `.Xresources`, `.xinitrc`, `LICENSE`, `README.md`

## Contributing

Contributions are welcome. Open issues for bugs/requests, fork the repo, and submit pull requests for changes.

## License

This project is licensed under the MIT License — see the `LICENSE` file for details.

---
