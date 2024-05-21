# for some reason reloading waybar with SIGUSR2 randomly crashes my waybar a bit later
pkill waybar
hyprctl dispatch exec waybar