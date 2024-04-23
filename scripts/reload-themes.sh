wal -i $(swww query | grep -o -E 'image: .+' | tail -c+8)

~/.config/mako/reload-theme
~/.config/kitty/reload-theme
~/.config/spicetify/reload-theme

pkill -SIGUSR2 waybar

~/.config/scripts/disable-gpu.sh

if [ -x "$(command -v nix-shell)" ]
then
	nix-shell ~/.config/neofetch/shell.nix --command ~/.config/neofetch/reload-theme.sh
else
	~/.config/neofetch/reload-theme.sh
fi

