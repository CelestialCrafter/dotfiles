~/.config/mako/reload-theme

~/.config/kitty/reload-theme

pkill -SIGUSR2 waybar

~/.config/scripts/disable-gpu.sh

~/.config/spicetify/reload-theme
spicetify-cli apply

if [ -x "$(command -v nix-shell)" ]
then
	nix-shell ~/.config/neofetch/shell.nix --command ~/.config/neofetch/reload-theme.sh
else
	~/.config/neofetch/reload-theme.sh
fi

