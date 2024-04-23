WALLPAPER_DIR=~/Pictures/Wallpapers
WALLPAPER="$WALLPAPER_DIR/$(ls "$WALLPAPER_DIR" -1 | wofi --prompt "Wallpaper" --show dmenu)"

swww img "$WALLPAPER"
~/.config/scripts/reload-themes.sh
