# ⚡ ARCH-I3WM-X11

![Arch Linux](https://img.shields.io/badge/OS-Arch_Linux-33b7ff?style=for-the-badge&logo=archlinux&logoColor=white)
![Window Manager](https://img.shields.io/badge/WM-i3wm-black?style=for-the-badge&logo=i3&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-Zsh-black?style=for-the-badge&logo=zsh&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

A highly modular, robust, and fully automated dotfiles deployment for Arch Linux (X11). This project transforms a base Arch Linux installation into a fully functional, aesthetically pleasing, and highly productive desktop environment with just one script.

## ✨ Key Features

- **🚀 Bulletproof Installer:** Automated deployment script (`install.sh`) with safe backup mechanisms, `sudo` keep-alive, strict path resolution, and advanced flags (`--dry-run` and `--link` for developers).
- **🎨 Dynamic Theming Engine:** Built-in Python script (`theme_builder.py`) using `pywal` to automatically generate system-wide color schemes (Polybar, Rofi, Dunst, i3) instantly from any wallpaper. Includes two static themes (`Void Red` and `Void Blue`) out of the box.
- **🖥️ True Multi-Monitor Support:** Polybar automatically detects and scales across all connected displays seamlessly.
- **⌨️ Instant Keybinding Cheatsheet:** Never forget a shortcut. Press `Mod + F1` to instantly parse and view all your active i3 keybindings via an elegant Rofi menu.
- **⚡ Blazing Fast Terminal Environment:** Pre-configured `Zsh` with `Starship` prompt (async Git fetching enabled) and dynamic `Fastfetch` presets.
- **🛠️ Custom Rofi Tooling:** Specialized Rofi menus for:
  - Network Management (`nmcli` GUI)
  - Power Menu
  - Theme / Wallpaper Switcher
  - Dashboard (Calendar, Media Controls)
- **👋 First Boot Greeter:** Interactive setup upon first login to configure default applications like your web browser.

---

## 📦 Prerequisites

Before running the installer, ensure you have:

1. A fresh or existing **Arch Linux** installation (X11 environment).
2. An active internet connection.
3. A user account with `sudo` privileges.

---

## 🚀 Installation

Clone the repository and run the installation script. The script will automatically install necessary packages (AUR included via `yay`), backup your existing dotfiles, and deploy the new configurations.

```bash
git clone https://github.com/adrenaline404/arch-i3wm-x11.git
cd arch-i3wm-x11
./install.sh
```

### Advanced Installer Flags (For Developers)

- `./install.sh --dry-run` : Simulates the installation process without making any actual changes to your system or installing packages. Perfect for reviewing what the script does.
- `./install.sh --link` : Uses `symlinks` instead of copying files. Ideal if you plan to modify the dotfiles and want the changes reflected immediately in your cloned Git repository.

---

## ⌨️ Workflow & Keybindings

Once installed and rebooted, log into the `i3` session. Your main modifier key (`$mod`) is typically the **Windows/Super key**.

### 🆘 The Most Important Shortcut

> **Press `$mod + F1**` at any time to open the **Rofi Cheatsheet**. It dynamically reads your `i3/config` and displays all available shortcuts!

### Basic Navigation

| Keybinding | Action |
| --- | --- |
| `$mod + Enter` | Open Terminal (Kitty) |
| `$mod + d` | Open App Launcher (Rofi) |
| `$mod + Shift + q` | Close focused window |
| `$mod + [1-9]` | Switch to workspace 1-9 |
| `$mod + Shift + [1-9]` | Move focused window to workspace 1-9 |

### System & Scripts

| Keybinding | Action |
| --- | --- |
| `$mod + x` | Open Power Menu |
| `$mod + n` | Open Network Manager |
| `$mod + t` | Open Theme/Wallpaper Switcher |
| `$mod + Shift + w` | Open Rofi Dashboard (Calendar/Media) |

---

## 🎨 Managing Themes & Wallpapers

You can change your system's entire look with a few clicks.

1. **Open the Gallery:** Run the Wallpaper Manager via Rofi.
2. **Import or Select:** Choose an existing image or import a new one.
3. **Dynamic Generation:** Upon selecting an image, you will be prompted to either "Set Wallpaper Only" or **"Generate Dynamic Theme (Pywal)"**.
4. Selecting Pywal will instantly re-color your *Polybar*, *Rofi*, *Dunst notifications*, and *i3 borders* to match your wallpaper!

---

## 📂 Directory Structure

A quick overview of how the repository is organized:

```text
ARCH-I3WM-X11/
├── configs/          # Base configurations (polybar, rofi, dunst, kitty, picom)
├── scripts/          # The brain behind the rice (pywal generator, network, battery, etc.)
├── themes/           # Static theme bases (Void Red, Void Blue) and Pywal targets
├── install.sh        # The robust deployment script
└── .zshrc            # Custom Zsh configuration
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check issues page if you want to contribute.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

---

*Built by adrenaline404.*
