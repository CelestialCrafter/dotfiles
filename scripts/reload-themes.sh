wal -i $(swww query | grep -o -E 'image: .+' | tail -c+8)

~/.config/mako/reload-theme.sh
~/.config/kitty/reload-theme
~/.config/obsidian/reload-theme

# for some reason reloading waybar with SIGUSR2 randomly crashes my waybar a bit later
pkill waybar
hyprctl dispatch exec waybar

~/.config/spicetify/reload-theme

~/.config/scripts/disable-gpu.sh

VENCORD_THEME_DIR=/home/celestial/.var/app/dev.vencord.Vesktop/config/vesktop/themes
install $HOME/.cache/wal/discord.theme.css $VENCORD_THEME_DIR/pywal.theme.css