#!/bin/bash

# Config file path
conf_file="$HOME/.config/hypr/conf/inactive_window_transparency.conf"

# Read the current opacity value
current_opacity=$(rg -oP 'inactive_opacity\s*=\s*\K[0-9.]+' "$conf_file")

# Determine new opacity
if [[ "$current_opacity" == "0.85" ]]; then
    new_opacity="1.0"
else
    new_opacity="0.85"
fi

# Update the file with new value
sed -i -E "s/(inactive_opacity\s*=\s*)[0-9.]+/\1$new_opacity/" "$conf_file"

# Reload Hyprland config
hyprctl reload

# # Notification
# notify-send -t 5000 "Inactive Opacity" "Set to $(awk "BEGIN { printf \"%.0f\", $new_opacity * 100 }")%"
