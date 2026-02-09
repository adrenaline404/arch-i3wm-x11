# Arch-i3wm-x11

![Arch Linux](https://img.shields.io/badge/Distro-Arch%20Linux-1793d1?style=for-the-badge&logo=arch-linux&logoColor=white)
![i3wm](https://img.shields.io/badge/WM-i3wm-e8e8e8?style=for-the-badge&logo=i3&logoColor=black)

> **Created by: adrenaline404**

---

## 📥 Installation

This repository includes an automated `install.sh` script that handles package installation, configuration deployment, and system hardening for Arch Linux.

### 1. Clone the Repository

Open your terminal and clone this repository to your local machine:

```bash
git clone https://github.com/adrenaline404/arch-i3wm-x11.git
cd arch-i3wm-x11
```

### 2. Run the Installer

Make the script executable and run it. Note: Do not run as root (sudo); the script will ask for sudo permissions when needed.

```Bash
chmod +x install.sh
./install.sh
```

### ⚙️ What the Installer Does

**Package Management:** *Checks for yay (AUR Helper) and installs it if missing.
Installs all core components (i3-wm, polybar, picom, etc.) and optional tools(Neovim, Zsh, Fonts).*

**Conflict Resolution:** *Automatically detects and removes conflicting packages (e.g., standard vim vs neovim, or different picom forks).*

**Backup:** *Creates a timestamped backup of your existing configurations in ~/dotfiles_backup_YYYYMMDD_HHMMSS.*

**Neovim Setup:** *Offers a "Fresh Install" mode to clean old caches and bootstrap plugins (Lazy.nvim & Mason) automatically.*

**System Hardening:** *Sets up udev rules for backlight control and adds your user to necessary groups (video, input, audio).*

### ⚠️ Post-Installation

> *After the installation is complete:*

**Reboot your system to apply group permissions and udev rules.**

**Select i3 as your session in the login manager / display manager.**

---

## ⌨️ Keybindings & Shortcuts

The **Super Key** (Windows Key) is referred to as **`Mod`** in this configuration.

### 🚀 Applications

| Keybinding | Action |
| :--- | :--- |
| **`Mod` + `Enter`** | Open Terminal (Kitty) |
| **`Mod` + `b`** | Open Web Browser (Firefox) |
| **`Mod` + `c`** | Open Code Editor (VS Code) |
| **`Mod` + `e`** | Open File Manager (Thunar) |
| **`Mod` + `Shift` + `v`** | Open Neovim (in Terminal) |
| **`Mod` + `q`** | Close/Kill Focused Window |

### 🖥️ Menus & Widgets (Rofi)

| Keybinding | Action |
| :--- | :--- |
| **`Mod` + `d`** | **App Launcher** (Search & Launch Apps) |
| **`Mod` + `Shift` + `d`** | **Dashboard** (Time, Weather, Calendar) |
| **`Mod` + `Shift` + `e`** | **Power Menu** (Shutdown, Reboot, Lock) |
| **`Mod` + `Shift` + `n`** | **Network Manager** (Wifi/Ethernet) |
| **`Mod` + `t`** | **Theme Switcher** (Change Colorscheme) |
| **`Mod` + `Shift` + `w`** | **Wallpaper Manager** |

### 📸 System & Utilities

| Keybinding | Action |
| :--- | :--- |
| **`Mod` + `Shift` + `x`** | Lock Screen |
| **`Print`** | Screenshot (GUI Selection) |
| **`Mod` + `Shift` + `s`** | Screenshot (Alternative Shortcut) |
| **`Mod` + `Shift` + `c`** | Reload i3 Configuration |
| **`Mod` + `Shift` + `r`** | Restart i3 |

### ⬅️ Window Navigation

You can use **Arrow Keys** or **Vim Keys** (`h`, `j`, `k`, `l`).

| Keybinding | Action |
| :--- | :--- |
| **`Mod` + `h`** / **`←`** | Focus Window Left |
| **`Mod` + `j`** / **`↓`** | Focus Window Down |
| **`Mod` + `k`** / **`↑`** | Focus Window Up |
| **`Mod` + `l`** / **`→`** | Focus Window Right |
| **`Mod` + `Shift` + `h`** | Move Window Left |
| **`Mod` + `Shift` + `j`** | Move Window Down |
| **`Mod` + `Shift` + `k`** | Move Window Up |
| **`Mod` + `Shift` + `l`** | Move Window Right |

### 🔲 Workspaces

| Keybinding | Action |
| :--- | :--- |
| **`Mod` + `1-9`** | Switch to Workspace 1-9 |
| **`Mod` + `Shift` + `1-9`** | Move Window to Workspace 1-9 |
| **`Mod` + `n`** | Create New Empty Workspace (Auto-detected) |

### 📐 Layout Management

| Keybinding | Action |
| :--- | :--- |
| **`Mod` + `f`** | Toggle Fullscreen |
| **`Mod` + `Shift` + `Space`** | Toggle Floating Mode |
| **`Mod` + `Space`** | Toggle Focus (Between Tiling/Floating) |
| **`Mod` + `s`** | Layout: Stacking |
| **`Mod` + `w`** | Layout: Tabbed |
| **`Mod` + `v`** | Layout: Split Toggle (Horizontal/Vertical) |

### 🔊 Hardware Controls

| Keybinding | Action |
| :--- | :--- |
| **`Volume Up`** | Volume +5% |
| **`Volume Down`** | Volume -5% |
| **`Mute`** | Mute Audio |
| **`Play/Pause`** | Media Play/Pause |
| **`Brightness Up`** | Screen Brightness +5% |
| **`Brightness Down`** | Screen Brightness -5% |

---

> ***The information in this "README.md" is not complete, I will add more information at a later time.***

---
