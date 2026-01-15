# Arch-i3wm-x11

![Arch Linux](https://img.shields.io/badge/Distro-Arch%20Linux-1793d1?style=for-the-badge&logo=arch-linux&logoColor=white)
![i3wm](https://img.shields.io/badge/WM-i3wm-e8e8e8?style=for-the-badge&logo=i3&logoColor=black)

## **A modern, aesthetic, and high-performance i3wm configuration for Arch Linux.**

Designed with a focus on "Glassmorphism" aesthetics (Blur + Transparency + Rounded Corners) while maintaining optimization for older hardware (specifically tuned for Intel HD Graphics 4400 / Haswell architecture).

---

## ✨ Features

* **⚡ Optimized Performance:** Picom animations and blur tuned for Intel HD Graphics (Zero lag on Haswell CPUs).
* **🎨 Dual Theme System:** Instant hot-swapping between **Ocean** (Navy Blue) and **Black** (OLED/Dark) themes without restarting.
* **🔊 Modern Audio Stack:** Full **PipeWire** integration with WirePlumber (replacing PulseAudio).
* **💎 Glassmorphism UI:** Consistent rounded corners and blur across i3, Polybar, Rofi, and Dunst.
* **🛠️ Developer Ready:** Pre-configured Alacritty (TOML), Starship prompt, and VIM-style navigation.
* **📦 Automated Installer:** One-click script to handle packages, fonts, symlinks, and permissions.

---

## 🚀 Installation

### Prerequisites

* A fresh minimal installation of **Arch Linux**.
* **Git** installed (`sudo pacman -S git`).
* **Internet Connection**.

### Quick Start

Run the following commands in your terminal. **Do not run as root**, the script will ask for sudo when needed.

* **1. Clone the repository**

```bash
git clone https://github.com/adrenaline404/arch-i3wm-x11.git
cd arch-i3wm-x11
```

* **2. Run the installer**

```bash
chmod +x scripts/setup/install.sh
./scripts/setup/install.sh
```

* **3. Reboot your system**

```bash
systemctl reboot
```

> **Note:** After rebooting, select i3 from your Login Manager (LightDM/GDM/SDDM) session menu.

---

## ⌨️ Keybindings

The Mod key is set to the **Windows / Super** key.

### 🖥️ Applications & System

**Key Combination | Action**
`Mod + Enter` : Open Terminal (Alacritty)
`Mod + d` : Open App Launcher (Rofi)
`Mod + b` : Open Web Browser (Firefox)
`Mod + e` : Open File Manager (Thunar)
`Mod + c` : Open Code Editor (VS Code)
`Mod + x` : Open Power Menu (Shutdown/Reboot)
`Mod + Esc` : Lock Screen (Blur Effect)
`Print` : Take Screenshot (Flameshot GUI)

### 🧭 Window Navigation

**Key Combination | Action**
`Mod + h` / `←` : Focus Left
`Mod + j` / `↓` : Focus Down
`Mod + k` / `↑` : Focus Up
`Mod + l` / `→` : Focus Right
`Mod + Space` : Toggle Focus between Tiling/Floating

### 🪟 Window Management

**Key Combination | Action**
`Mod + Shift + q` : Close focused window
`Mod + Shift + h` / `←` : Move window Left
`Mod + Shift + j` / `↓` : Move window Down
`Mod + Shift + k` / `↑` : Move window Up
`Mod + Shift + l` / `→` : Move window Right
`Mod + f` : Toggle Fullscreen
`Mod + Shift + Space` : Toggle Floating mode

### 🔊 Hardware Controls

**Key Combination | Action**
`Vol Up` : Volume +5%
`Vol Down` : Volume -5%
`Mute` : Toggle Mute
`Brightness Up` : Brightness +5%
`Brightness Down` : Brightness -5%

### 🔄 Session Management

**Key Combination | Action**
`Mod + Shift + c` : Reload i3 Config (In-place)
`Mod + Shift + r` : Restart i3 (Restart Session)
`Mod + Shift + e` : Logout / Exit i3

---

## 🎨 Theme Switching

You can switch themes instantly using the included script. This will update colors for i3, Polybar, Rofi, Alacritty, and the Wallpaper.

```bash
# Switch to Ocean Theme (Navy Blue)
~/arch-i3wm-x11/scripts/theme-switcher/switch.sh ocean
# Switch to Black Theme (Deep Dark)
~/arch-i3wm-x11/scripts/theme-switcher/switch.sh black
```

---

## 📂 Project Structure

```bash
arch-i3wm-x11/
├── .config/
│   ├── alacritty/       # Terminal config (TOML)
│   ├── dunst/           # Notification styling
│   ├── i3/              # Window Manager config
│   ├── picom/           # Animations & Blur
│   ├── polybar/         # Status Bar modules
│   ├── rofi/            # App Launcher & Menus
│   └── starship/        # Shell Prompt
├── scripts/
│   ├── setup/           # Installation scripts
│   ├── theme-switcher/  # Theming logic
│   └── utils/           # Lock, Screenshot, Wallpaper tools
└── themes/              # Wallpaper & Xresources assets
```

---

## 🔧 Troubleshooting

### 1. Icons are missing / Squares (Tofu)?

Ensure Nerd Fonts are installed and cache is refreshed. The installer does this automatically, but you can force it:

```bash
fc-cache -fv
```

### 2. Wallpaper not showing?

The system uses `nitrogen` with a fallback to `feh`. Try setting it manually once:

```bash
nitrogen --set-zoom-fill ~/arch-i3wm-x11/themes/ocean/wallpaper.jpg --save
```

### 3. Brightness keys not working?

Ensure your user is in the `video` group (handled by installer) and **REBOOT** your system.

---

## 🤝 Credits

**WM:** [i3-wm](https://i3wm.org/)
**Bar:** [Polybar](https://github.com/polybar/polybar)
**Compositor:** [picom-git](https://github.com/yshui/picom)
**Launcher:** [Rofi](https://github.com/davatorium/rofi)
**Terminal:** [Alacritty](https://github.com/alacritty/alacritty)

---

> Made with ❤️ for the **Arch Linux** Community
