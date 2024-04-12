#!/usr/bin/env bash

randomchars=$(echo "abcdefghijklmnopqrstuvwxyz" | grep -z -o . | shuf -z -n6 | perl -ne '/\000/ and print;')
date=$(date +'%Y-%m-%d-')
hyprpicker_pid=-1

freeze() {
	hyprpicker -r -z &
	sleep 0.2
	hyprpicker_pid=$!
}

unfreeze() {
  if [ ! $hyprpicker_pid -eq -1 ]; then
    kill $hyprpicker_pid 2> /dev/null
  fi
}

fade() {
  if [[ -n $FADELAYERS ]]; then
    hyprctl keyword animation "$FADELAYERS" >/dev/null
  fi
}

unfade() {
	FADELAYERS="$(hyprctl -j animations | jq -jr '.[0][] | select(.name == "fadeLayers") | .name, ",", (if .enabled == true then "1" else "0" end), ",", (.speed|floor), ",", .bezier')"
 	hyprctl keyword animation 'fadeLayers,0,1,default' >/dev/null
}

menu() {
	actions="Window
Screen
Region"

	action=$(echo "$actions" | wofi --prompt Mode --show dmenu)
}

action="Region"

if [ "$1" != "skip" ]; then
	menu
	unfade
fi

teeout="$HOME/Pictures/Screenshots/$date$randomchars.png"

# lots of repeated code - cry about it (bash is weird and hard.)
case $action in
	Region)
		freeze
		slurpout=$(slurp)
		if [ -z "$slurpout" ]; then
			unfreeze
			fade
			exit 1
		fi
		grim -g "$slurpout" - | tee "$teeout" | wl-copy --type image/png
		;;
	Screen)
		grim - | tee "$teeout" | wl-copy --type image/png
		;;
	Window)
		freeze
		# stolen from https://github.com/hyprwm/contrib/blob/main/grimblast/grimblast#L223C1-L223C73
	  workspaces="$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
	  windows="$(hyprctl clients -j | jq -r --argjson workspaces "$workspaces" 'map(select([.workspace.id] | inside($workspaces)))')"
		slurpout=$(echo "$windows" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp $SLURP_ARGS)
		if [ -z "$slurpout" ]; then
			unfreeze
			fade
			exit 1
		fi
		grim -g "$slurpout" - | tee "$teeout" | wl-copy --type image/png
esac
unfreeze