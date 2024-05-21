WALLPAPER_DIR=~/Pictures/Wallpapers
CHOICE=$(ls "$WALLPAPER_DIR" -1 | wofi --prompt "Wallpaper" --show dmenu)
WALLPAPER="$WALLPAPER_DIR/$CHOICE"

if [[ -z $CHOICE ]] then
	echo "no wallpaper selected"
	exit
fi

~/.config/scripts/wallpaper.sh "$WALLPAPER"
~/.config/scripts/reload-themes.sh
