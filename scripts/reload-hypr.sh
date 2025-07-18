#!/bin/bash

# Reload Hyprland configuration
hyprctl reload

# Optional: Show notification if notify-send is available
if command -v notify-send &> /dev/null; then
   notify-send "Hyprland" "Configuration reloaded"
fi