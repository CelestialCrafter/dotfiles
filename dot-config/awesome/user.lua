local user = {}

user.wallpaper = "~/Pictures/Wallpapers/normal.jpg"
user.profile = "~/Pictures/user.png"
user.font = "sans-serif 11"
user.preview_update_interval = 0.5
user.connect_update_interval = 0.5
user.titlebar_position = "left"
user.bar_position = "top"
user.terminal = "Alacritty.desktop"
user.pinned_apps = {
	Alacritty = "Alacritty.desktop",
	floorp = "one.ablaze.floorp.desktop",
	Spotify = "com.spotify.Client.desktop",
	vesktop = "dev.vencord.Vesktop.desktop",
}

user.base_spacing = 4
user.roundness = 2
user.spacing_multiplier = 2

local colors = dofile(os.getenv("HOME") .. "/.config/akari-settings/user.lua").colors
for k, v in pairs(colors) do
	user[k] = v
end

return user
