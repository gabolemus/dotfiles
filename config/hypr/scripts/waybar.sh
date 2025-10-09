#!/usr/bin/env bash

if pgrep -x "waybar" > /dev/null; then
    pkill -SIGUSR1 waybar
else
        hyprctl dispatch exec waybar
fi
