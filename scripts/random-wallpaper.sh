#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Check if directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
   echo "Error: Directory $WALLPAPER_DIR does not exist"
   exit 1
fi

# Get random wallpaper file
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" -o -iname "*.webp" \) | shuf -n 1)

# Check if wallpaper was found
if [ -z "$WALLPAPER" ]; then
   echo "Error: No image files found in $WALLPAPER_DIR"
   exit 1
fi

# Set wallpaper using hyprpaper
# First, unload all current wallpapers
hyprctl hyprpaper unload all
# Preload the new wallpaper
hyprctl hyprpaper preload "$WALLPAPER"
# Set wallpaper for all monitors (get monitor names dynamically)
if command -v jq &> /dev/null; then
    # Use jq for JSON parsing if available
    for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
        hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
    done
else
    # Fallback method without jq
    hyprctl monitors | grep -E "Monitor.*\(ID" | awk '{print $2}' | while read -r monitor; do
        hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
    done
fi

echo "Wallpaper set to: $WALLPAPER"