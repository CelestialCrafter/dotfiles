wal -i $(swww query | grep -o -E 'image: .+' | tail -c+8)

~/.config/mako/reload-theme
~/.config/kitty/reload-theme

# for some reason reloading waybar with SIGUSR2 randomly crashes my waybar a bit later
pkill waybar
hyprctl dispatch exec waybar

~/.config/spicetify/reload-theme

~/.config/scripts/disable-gpu.sh

