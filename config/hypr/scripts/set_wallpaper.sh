#!/bin/bash

# Wallpaper directory
wallpaperdir="$HOME/Pictures/Wallpapers/"

# Select a random wallpaper
rand_wallpaper=$(find "$wallpaperdir" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)

# Extract wallpaper number (expects format: wallpaper-N.jpg)
wallpaper_filename=$(basename "$rand_wallpaper")
wallpaper_num=$(echo "$wallpaper_filename" | rg -oP 'wallpaper-\K[0-9]+')

# Hyprpaper setting
hyprpaper_conf="$HOME/.config/hypr/hyprpaper.conf"
echo "splash = false" > "$hyprpaper_conf"
echo "preload = $rand_wallpaper" >> "$hyprpaper_conf"
echo "wallpaper = , $rand_wallpaper" >> "$hyprpaper_conf"

# Define color mappings
declare -A active_colors
declare -A inactive_colors

active_colors["1"]="rgba(4ed5d3ee) rgba(074a77ee) 45deg"
inactive_colors["1"]="rgba(595959aa)"

active_colors["2"]="rgba(ffcaabee) rgba(d86373ee) 45deg"
inactive_colors["2"]="rgba(595959aa)"

active_colors["3"]="rgba(58b1e0ee) rgba(ffe3e7ee) 45deg"
inactive_colors["3"]="rgba(595959aa)"

active_colors["4"]="rgba(f79345ee) rgba(85556fee) 45deg"
inactive_colors["4"]="rgba(595959aa)"

active_colors["5"]="rgba(72cce8ee) rgba(81476Dee) 45deg"
inactive_colors["5"]="rgba(595959aa)"

# Modify border colors in borders.conf inside the `general {}` block
borders_conf="$HOME/.config/hypr/conf/borders.conf"

if [[ -n "${active_colors[$wallpaper_num]}" ]]; then
    sed -i -E \
        -e "/^\s*col\.active_border\s*=.*/s|=.*|= ${active_colors[$wallpaper_num]}|" \
        -e "/^\s*col\.inactive_border\s*=.*/s|=.*|= ${inactive_colors[$wallpaper_num]}|" \
        "$borders_conf"
else
    echo "Warning: No color scheme defined for wallpaper number $wallpaper_num"
fi

# Restart hyprpaper
pkill hyprpaper
hyprpaper &

# Reload Hyprland config to apply border changes
hyprctl reload
