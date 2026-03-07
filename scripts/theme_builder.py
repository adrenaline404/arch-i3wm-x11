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
background = #E6{colors['color0'][1:]}
background-alt = #66{colors['color0'][1:]}
foreground = #FFFFFF
primary = {colors['color4']}
secondary = {colors['color5']}
alert = {colors['color1']}
disabled = #898c95
"""
    with open(os.path.join(theme_dir, "colors.ini"), "w") as f:
        f.write(polybar_colors)

    rofi_override = f"""* {{
    background: #0A0A0EE6;
    bg-alt: {colors['color0']};
    foreground: #FFFFFF;
    primary: {colors['color4']};
    disabled: #707880;
    
    background-color: @background;
    text-color: @foreground;
}}"""
    with open(os.path.join(theme_dir, "rofi.rasi"), "w") as f:
        f.write(rofi_override)

    i3_colors = f"""# class                 border  backgr. text    indicator child_border
client.focused          {colors['color4']} #0A0A0E #FFFFFF {colors['color4']}   {colors['color4']}
client.focused_inactive #313244 #0A0A0E #A6ADC8 #313244   #313244
client.unfocused        #181825 #181825 #A6ADC8 #181825   #181825
client.urgent           {colors['color1']} #0A0A0E #FFFFFF {colors['color1']}   {colors['color1']}
client.placeholder      #11111B #11111B #FFFFFF #11111B   #11111B
client.background       #0A0A0E
"""
    with open(os.path.join(theme_dir, "i3_colors"), "w") as f:
        f.write(i3_colors)

    print(f"Professional Pywal theme generated for {image_path}!")
    
    switcher = os.path.expanduser("~/.config/i3/scripts/theme_switcher.sh")
    subprocess.run(["bash", switcher, "pywal-custom"])

if __name__ == "__main__":
    generate_theme(sys.argv[1])