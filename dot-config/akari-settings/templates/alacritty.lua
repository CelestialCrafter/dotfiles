local M = {}

M.data = [[[colors]
indexed_colors = [
	{ index = 229, color = "%colors.primary%" },
	{ index = 230, color = "%colors.secondary%"},
	{ index = 231, color = "%colors.accent%" },
]

[colors.primary]
foreground = "%colors.text%"
background = "%colors.base%"
dim_foreground = "%colors.text_subtle%"

[colors.selection]
text = "CellForeground"
background = "%colors.overlay%"

[colors.normal]
black = "%colors.overlay%"
red = "%colors.red%"
green = "%colors.green%"
yellow = "%colors.yellow%"
blue = "%colors.blue%"
magenta = "%colors.purple%"
cyan = "%colors.orange%"
white = "%colors.text%"

[colors.bright]
black = "%colors.subtle%"
red = "%colors.red%"
green = "%colors.green%"
yellow = "%colors.yellow%"
blue = "%colors.blue%"
magenta = "%colors.purple%"
cyan = "%colors.orange%"
white = "%colors.text%"

[colors.dim]
black = "%colors.subtle%"
red = "%colors.red%"
green = "%colors.green%"
yellow = "%colors.yellow%"
blue = "%colors.blue%"
magenta = "%colors.purple%"
cyan = "%colors.orange%"
white = "%colors.text%"]]

function M.install(resolved)
	local file = assert(io.open(os.getenv("HOME") .. "/.config/alacritty/color.toml", "w"))
	file:write(resolved)
	file:close()
end

return M
