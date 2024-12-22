#!/bin/bash

# Wallpaper directory
wallpaperdir="$HOME/Pictures/Wallpapers/"

# Select a random wallpaper
rand_wallpaper=$(find "$wallpaperdir" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)

# Hyprpaper setting
echo "splash = false" > "$HOME/.config/hypr/hyprpaper.conf"
echo "preload = $rand_wallpaper" >> "$HOME/.config/hypr/hyprpaper.conf"
echo "wallpaper = , $rand_wallpaper" >> "$HOME/.config/hypr/hyprpaper.conf"

# # Using pywal to generate color scheme
# wal -i $randompic
#
# # Copy colors from pywal to required places
# cp ~/.cache/wal/color-hyprland.conf ~/.config/hypr/myColors.conf
# cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/myColors.css
# cp ~/.config/waybar/myColors.css ~/.config/swaync/myColors.css

# Restart Hyprpaper
pkill hyprpaper
hyprpaper&
