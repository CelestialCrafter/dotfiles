wal -i $(swww query | grep -o -E 'image: .+' | tail -c+8)

if [ -x "$(command -v nix-shell)" ]
then
	nix-shell ~/.config/scripts/shell.nix
fi

~/.config/mako/reload-theme
~/.config/kitty/reload-theme
~/.config/spicetify/reload-theme
~/.config/neofetch/reload-theme.sh

# for some reason reloading waybar with SIGUSR2 randomly crashes my waybar a bit later
pkill waybar
hyprctl dispatch exec waybar

~/.config/scripts/disable-gpu.sh

