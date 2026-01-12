# arch-i3wm-x11

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)
![i3wm](https://img.shields.io/badge/i3wm-X11-black?style=flat&logo=i3&logoColor=white)
![X11](https://img.shields.io/badge/X11-Display_Server-blue?style=flat)
![LightDM](https://img.shields.io/badge/LightDM-Supported-green?style=flat)

Modern i3wm (X11) configuration for Arch Linux with black transparent semi-blur theme, optimized for low-to-mid spec laptops. Designed for **Asus X540LA**.

## ✨ Features

- **Black Transparent Semi-Blur Theme** - Modern transparent design with blur effects
- **Complete i3wm Configuration** - Full keybindings, workspace management, window controls
- **Modern Theme System** - Black, Catppuccin, and Nord themes with synchronized switching
- **Modern Theme System** - Black, Catppuccin, and Nord themes with synchronized switching
- **Polybar Status Bar** - Feature-rich status bar with modern icons (Nerd Font)
- **Rofi Launcher** - Beautiful application launcher and power menu with icons
- **Dunst Notifications** - Clean, modern notification daemon with transparency
- **Picom Compositor** - Optimized blur effects for Intel HD Graphics
- **PipeWire Audio** - Modern audio server with PulseAudio compatibility
- **Error Handling** - Robust error handling in all scripts
- **LightDM Compatible** - Works seamlessly with LightDM
- **Media Controls** - Volume, brightness, screenshot shortcuts with icons
- **Theme Switcher** - Synchronized theme switching across all components
- **Clean Code** - Scripts and configuration files are stripped of inline comments/notes for a production-ready layout
- **Backlight udev rule** - Optional udev rule provided to allow non-root brightness control
- **Powermenu confirmation** - Reboot/shutdown require confirmation via Rofi
- **Polybar launchers** - Clickable launcher icons (bottom/right) via `~/.config/polybar/launchers` and `~/.config/polybar/scripts/launchers.sh`

## 📋 Requirements

- Arch Linux (or Arch-based distribution)
- X11 session (NOT Wayland)
- LightDM (recommended) or manual X11 start
- Internet connection for package installation
- Intel HD Graphics (optimized for Haswell/Broadwell)
- PipeWire for audio (included in installation)

## 🚀 Installation

### Quick Install

```bash
git clone https://github.com/adrenaline404/arch-i3wm-x11.git
cd arch-i3wm-x11
chmod +x install.sh
./install.sh
```

The installer will:
- Install all required packages
- Backup your existing configurations
- Copy all configuration files
- Set up wallpapers
- Configure executable permissions
- Check system compatibility

## ⌨️ Keybindings

### Application Launchers

| Keybinding | Action |
|------------|--------|
| `Super + Enter` | Open terminal (Alacritty) |
| `Super + D` | Application launcher (Rofi) |
| `Super + Shift + E` | Power menu |
| `Super + Shift + X` | Lock screen |
| `Super + Shift + T` | Theme switcher |

### Window Management

| Keybinding | Action |
|------------|--------|
| `Super + Shift + Q` | Kill focused window |
| `Super + Shift + C` | Reload i3 configuration |
| `Super + Shift + R` | Restart i3 |
| `Super + F` | Toggle fullscreen |
| `Super + Shift + Space` | Toggle floating |

### Layout & Focus

| Keybinding | Action |
|------------|--------|
| `Super + H/V` | Split horizontal/vertical |
| `Super + E` | Toggle split layout |
| `Super + S` | Stacking layout |
| `Super + W` | Tabbed layout |
| `Super + J/K/L/;` | Move focus (vim-style) |
| `Super + Shift + J/K/L/;` | Move container |
| `Super + R` | Enter resize mode |

### Workspaces

| Keybinding | Action |
|------------|--------|
| `Super + 1-0` | Switch to workspace 1-10 |
| `Super + Shift + 1-0` | Move container to workspace 1-10 |
| `Super + U` | Switch to urgent workspace |

### Media Keys

| Keybinding | Action |
|------------|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |
| `Print` | Screenshot (selection → clipboard) |

## 🎨 Themes

Three beautiful themes included:

- **Black** (default) - Black transparent with cyan accents
- **Catppuccin Mocha** - Warm, cozy theme
- **Nord** - Cool, arctic theme

All themes feature:
- Transparent backgrounds with blur effects
- Modern icons (Nerd Font)
- Synchronized colors across all components

Switch themes with `Super + Shift + T` or run:
```bash
~/.config/rofi/theme-switcher.sh
```

The theme switcher synchronizes:
- Wallpaper
- Polybar colors
- Rofi colors
- Dunst colors
- i3 window colors

## 📁 Repository Structure

```
arch-i3wm-x11/
├── install.sh                 # Installation script
├── README.md                  # Documentation
├── LICENSE                    # MIT License
├── config/
│   ├── i3/
│   │   ├── config            # Main i3wm configuration
│   │   ├── autostart.sh      # Autostart script
│   │   ├── lock.sh           # Screen lock script
│   │   └── scripts/
│   │       ├── volume.sh     # Volume control
│   │       ├── brightness.sh # Brightness control
│   │       └── screenshot.sh # Screenshot tool
│   ├── polybar/
│   │   ├── config.ini        # Main polybar config
│   │   ├── launch.sh         # Polybar launcher
│   │   └── themes/
│   │       ├── black.ini     # Black theme
│   │       ├── catppuccin.ini # Catppuccin theme
│   │       └── nord.ini       # Nord theme
│   ├── rofi/
│   │   ├── launcher.rasi     # Application launcher
│   │   ├── powermenu.rasi    # Power menu theme
│   │   ├── powermenu.sh      # Power menu script
│   │   └── theme-switcher.sh # Theme switcher
│   ├── dunst/
│   │   └── dunstrc           # Notification daemon config
│   └── picom/
│       └── picom.conf        # Compositor config with blur
└── wallpaper/
    ├── black.jpg             # Black wallpaper
    ├── catppuccin.jpg        # Catppuccin wallpaper
    ├── nord.jpg              # Nord wallpaper
    └── current.jpg           # Current wallpaper symlink
```

## 🔧 Configuration

### Polybar

Edit `~/.config/polybar/config.ini` to customize the status bar. Theme colors are loaded from `~/.config/polybar/themes/*.ini`.

Notes:
- Launch Polybar via `~/.config/polybar/launch.sh` so the script can auto-detect and export `BACKLIGHT_CARD`, `POLYBAR_BATTERY`, and `POLYBAR_ADAPTER` environment variables used by the modules.
- A simple launcher widget reads `~/.config/polybar/launchers` (format: `icon;command`) and renders clickable icons. The helper script is `~/.config/polybar/scripts/launchers.sh`.

### i3wm

Edit `~/.config/i3/config` to customize window manager behavior, keybindings, and window assignments.

### Picom

Edit `~/.config/picom/picom.conf` to adjust compositor settings. Blur is enabled by default with `dual_kawase` method optimized for Intel HD Graphics.

### Rofi

Edit `~/.config/rofi/launcher.rasi` to customize launcher appearance. The power menu supports theme-specific files named `powermenu-<theme>.rasi` (for example `powermenu-catppuccin.rasi`) and selects them automatically. Note: these `powermenu` themes use numeric `location` values required by `rofi`. Reboot and shutdown entries now prompt for confirmation.

## 🐛 Troubleshooting

### Audio not working (PipeWire)

1. Check if PipeWire is running: `systemctl --user status pipewire pipewire-pulse wireplumber`
2. Verify PipeWire is active: `pactl info | grep "Server Name"` (should show "PulseAudio (on PipeWire)")
3. Restart PipeWire services: `systemctl --user restart pipewire pipewire-pulse wireplumber`
4. Check audio devices: `pactl list short sinks`
5. If issues persist, check logs: `journalctl --user -u pipewire -u pipewire-pulse -u wireplumber`

### Blur not working

1. Ensure picom is running: `pgrep picom`
2. Check picom config: `~/.config/picom/picom.conf`
3. Verify `blur-background = true;` and `blur-method = "dual_kawase";`
4. Restart picom: `killall picom && picom --config ~/.config/picom/picom.conf --daemon`

### Polybar not showing

1. Check if polybar is running: `pgrep polybar`
2. Check logs: `~/.config/polybar/polybar.log`
3. Reload: `~/.config/polybar/launch.sh`

### Transparency not working

1. Ensure picom is running
2. Check opacity rules in `~/.config/picom/picom.conf`
3. Verify `pseudo-transparency = true;` in polybar config

### Icons not showing

1. Ensure `ttf-jetbrains-mono-nerd` is installed
2. Update font cache: `fc-cache -fv`
3. Restart i3: `Super + Shift + R`

### Battery not showing

1. Check battery device: `ls /sys/class/power_supply/`
2. Edit `~/.config/polybar/config.ini` and update `battery = BAT0` if needed
3. Check adapter name: `ls /sys/class/power_supply/ | grep -i "^AC"`

### Brightness not working

1. Check backlight device: `ls /sys/class/backlight/`
2. The setup auto-detects the backlight device and exports `BACKLIGHT_CARD` for Polybar. You can override it by exporting `BACKLIGHT_CARD` before launching Polybar or editing `card = ${env:BACKLIGHT_CARD:intel_backlight}` in `~/.config/polybar/config.ini`.
3. Use the provided udev rule to allow non-root brightness control. Copy `~/.config/udev/99-backlight.rules` to `/etc/udev/rules.d/` and reload udev:

```bash
sudo cp ~/.config/udev/99-backlight.rules /etc/udev/rules.d/99-backlight.rules
sudo udevadm control --reload
sudo udevadm trigger
```

4. Add your user to the `video` group and re-login:

```bash
sudo usermod -aG video $USER
```

## 📝 Customization

### Adding a New Theme

1. Create theme file: `~/.config/polybar/themes/mytheme.ini`
```ini
[colors]
background = #00000080
foreground = #ffffff
accent = #yourcolor
```

2. Add wallpaper: `~/Pictures/mytheme.jpg`

3. Update theme switcher script to include your theme

### Changing Blur Intensity

Edit `~/.config/picom/picom.conf`:
```ini
blur-strength = 5;
blur-size = 8;
```

### Adjusting Transparency

Edit `~/.config/picom/picom.conf`:
```ini
inactive-opacity = 0.85;
active-opacity = 0.95;
```

## 🔒 Security

- Screen lock uses `xsecurelock` (more secure) with fallback to `i3lock`
- Power menu requires confirmation for shutdown/reboot
- All scripts include error handling to prevent security issues

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Credits

- **i3wm** - Window manager
- **Polybar** - Status bar
- **Rofi** - Application launcher
- **Picom** - Compositor with blur support
- **Dunst** - Notification daemon
- **Nerd Fonts** - Modern icons
- **Catppuccin** - Theme colors
- **Nord** - Theme colors

## 📧 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check existing issues for solutions
- Review the troubleshooting section

## 🎯 Target System

This configuration is optimized for:
- **Laptop**: Asus X540LA
- **CPU**: Intel Core i3-4005U (Haswell)
- **GPU**: Intel HD Graphics 4400
- **RAM**: 4GB
- **Display Manager**: LightDM
- **Session**: X11

However, it works great on any Arch Linux system with X11!

---

**Maintained by adrenaline404**

*Enjoy 🚀*
