#!/usr/bin/env python3
import os
import subprocess
import json
import sys
import shutil

def generate_theme(image_path):
    theme_dir = os.path.expanduser("~/.config/i3/themes/pywal-custom")
    os.makedirs(theme_dir, exist_ok=True)
    
    target_img = os.path.join(theme_dir, "wallpaper.jpg")
    shutil.copy2(image_path, target_img)

    subprocess.run(["wal", "-i", target_img, "-q", "-n"])
    
    wal_cache = os.path.expanduser("~/.cache/wal/colors.json")
    with open(wal_cache, 'r') as f:
        colors = json.load(f)["colors"]

    polybar_colors = f"""[colors]
background = #99{colors['color0'][1:]}
background-alt = #33{colors['color1'][1:]}
foreground = {colors['color7']}
primary = {colors['color4']}
secondary = {colors['color5']}
alert = {colors['color1']}
disabled = #707880
"""
    with open(os.path.join(theme_dir, "colors.ini"), "w") as f:
        f.write(polybar_colors)

    rofi_override = f"""* {{
    background: #050a1aE6;
    bg-alt: {colors['color0']};
    foreground: {colors['color7']};
    primary: {colors['color4']};
    disabled: #707880;
    
    background-color: @background;
    text-color: @foreground;
}}"""
    with open(os.path.join(theme_dir, "rofi.rasi"), "w") as f:
        f.write(rofi_override)

    i3_colors = f"""# class                 border  backgr. text    indicator child_border
client.focused          {colors['color4']} {colors['color0']} {colors['color7']} {colors['color4']}   {colors['color4']}
client.focused_inactive #333333 {colors['color0']} #888888 #484e50   #5f676a
client.unfocused        #333333 {colors['color0']} #888888 #292d2e   #222222
client.urgent           #2f343a {colors['color1']} #ffffff {colors['color1']}   {colors['color1']}
client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c
client.background       #ffffff
"""
    with open(os.path.join(theme_dir, "i3_colors"), "w") as f:
        f.write(i3_colors)

    print(f"Tema dinamis 'pywal-custom' berhasil dibuat berdasarkan {image_path}!")
    
    switcher = os.path.expanduser("~/.config/i3/scripts/theme_switcher.sh")
    subprocess.run(["bash", switcher, "pywal-custom"])

if __name__ == "__main__":
    generate_theme(sys.argv[1])