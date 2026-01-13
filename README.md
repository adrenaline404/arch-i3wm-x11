# Arch i3wm X11 Dotfiles

![License](https://img.shields.io/badge/license-MIT-green.svg) ![Platform](https://img.shields.io/badge/platform-Arch%20Linux-blue.svg) ![WM](https://img.shields.io/badge/window--manager-i3-orange.svg) ![Display](https://img.shields.io/badge/display-X11-lightgrey.svg) ![Repo](https://img.shields.io/github/stars/adrenaline404/arch-i3wm-x11?style=social)

Modern i3wm dotfiles with dual-theme support (Black & Ocean), optimized for Arch Linux on X11. This repository includes preconfigured i3, Polybar, Picom (compositor), Rofi, Alacritty, Dunst, and PipeWire integration.

## Key Features

- Dual themes (Black & Ocean) — instant theme switching via script
- Visual effects: blur, transparency, rounded corners (hardware dependent)
- Tuned for Intel GPUs (example: Intel HD 4400)
- Complete desktop stack: i3, Polybar, Rofi, Alacritty, Dunst, and utilities

## System Requirements

- Operating System: Arch Linux (X11)
- Display server: X11
- Audio: PipeWire
- CPU/GPU: Intel Core i3 / Intel HD Graphics 4400 or better
- RAM: 4 GB minimum

## Quick Installation

1. Clone the repository

```bash
cd ~
git clone https://github.com/adrenaline404/arch-i3wm-x11.git
cd arch-i3wm-x11
```

2. Run the installer script

```bash
chmod +x scripts/setup/install.sh
./scripts/setup/install.sh
```

The installer will:

- Install required packages (uses pacman; may include AUR helper if configured)
- Enable LightDM service (if applicable)
- Backup existing configurations
- Deploy dotfiles to their target locations
- Set the default theme to Black

After installation a reboot is recommended:

```bash
reboot
```

## Dependencies (summary)

- Window manager & compositor: `i3-wm` (or `i3-gaps`), `picom`
- Xorg packages: `xorg`, `xorg-xinit`, `xorg-xrandr`, `xorg-xrdb`
- Display manager: `lightdm`, `lightdm-gtk-greeter`
- Status bar & launcher: `polybar`, `rofi`
- Terminal: `alacritty`
- Audio: `pipewire`, `pipewire-pulse`, `wireplumber`, `pavucontrol`
- Notifications & wallpaper tools: `dunst`, `nitrogen`
- Utilities: `network-manager-applet`, `blueman`, `brightnessctl`, `flameshot`, `numlockx`, `xss-lock`, `xfce4-power-manager`, `polkit-gnome`

Recommended AUR packages: `picom-jonaburg-git`, `starship`.

## Theme System

Themes are located under `themes/black` and `themes/ocean`. Each theme contains color definitions (`Xresources`) and a wallpaper.

Switch theme with the provided script:

```bash
./scripts/theme-switcher/switch-theme.sh black
./scripts/theme-switcher/switch-theme.sh ocean
```

Theme changes are applied instantly and generally do not require a logout.

## Important Shortcuts (summary)

- `Super + Enter` — open terminal
- `Super + d` — launcher (Rofi)
- `Super + q` — close window
- `Super + f` — toggle fullscreen
- `Super + Shift + Space` — toggle floating
- Navigation: `Super + h/j/k/l` (left/down/up/right)
- Workspaces: `Super + 1..0` to switch, `Super + Shift + 1..0` to move windows

Full keybindings are available in the i3 configuration under `.config/i3/`.

## Post-installation & Troubleshooting

- Polybar not visible: check `~/.config/polybar/launch.sh`
- Picom not running (no blur/transparency):

	```bash
	picom --config ~/.config/picom/picom.conf &
	```

- Theme not applied: reload X resources and i3

	```bash
	xrdb -merge ~/.Xresources
	i3-msg reload
	```

- PipeWire issues: check services

	```bash
	systemctl --user status pipewire pipewire-pulse wireplumber
	systemctl --user enable --now pipewire pipewire-pulse wireplumber
	```

- Screen tearing: ensure Picom uses the `glx` backend and `vsync = true` in its config.

## Repository Structure (summary)

- `.config/` — i3, picom, polybar, rofi, alacritty, dunst, starship, GTK settings
- `scripts/setup/install.sh` — installer script
- `scripts/theme-switcher/switch-theme.sh` — theme switcher script
- `themes/black` & `themes/ocean` — theme assets (colors, wallpapers)
- `.Xresources`, `.xinitrc`, `LICENSE`, `README.md`

## Contributing

Contributions, issues and feature requests are welcome. Fork the repository and submit a pull request.

## License

This project is licensed under the MIT License — see the `LICENSE` file for details.

---
