~/.config/mako/reload-theme

~/.config/kitty/reload-theme

if command -v nix-shell &> /dev/null then
	nix-shell ~/.config/neofetch/shell.nix --command ~/.config/neofetch/reload-theme.sh
else
	~/.config/neofetch/reload-theme.sh
fi
~/.config/spicetify/reload-theme
spicetify-cli apply

pkill -SIGUSR2 waybar

~/.config/scripts/disable-gpu.sh

