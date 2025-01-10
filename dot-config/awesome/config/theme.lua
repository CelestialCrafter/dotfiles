local gears = require("gears")
local beautiful = require("beautiful")

local user = require("user")

local dpi = beautiful.xresources.apply_dpi

local theme = {}

local base = dpi(user.base_spacing)
local function level(l)
	return base * (user.spacing_multiplier ^ (l - 1))
end

-- spacing
theme.spacing_s = level(1)
theme.spacing_m = level(2)
theme.spacing_l = level(3)
theme.spacing_xl = level(4)

-- misc
theme.useless_gap = level(user.gap_level) / 2
theme.wallpaper_path = user.wallpaper
theme.wallpaper = function(s)
	return gears.surface.crop_surface({
		surface = gears.surface(theme.wallpaper_path),
		ratio = s.geometry.width / s.geometry.height,
	})
end
theme.font = table.concat(user.font, " ")
theme.rounded = function(cr, w, h)
	gears.shape.rounded_rect(cr, w, h, level(user.round_level))
end

-- colors
local colors = dofile(os.getenv("HOME") .. "/.config/settings/user.lua").colors
for k, v in pairs(colors) do
	theme[k] = v
end

-- awesome
theme.bg_normal = theme.base
theme.bg_focus = theme.surface
theme.bg_urgent = theme.accent
theme.bg_minimize = theme.surface
theme.bg_systray = theme.surface

theme.fg_normal = theme.text
theme.fg_focus = theme.text
theme.fg_urgent = theme.text
theme.fg_minimize = theme.text
theme.prompt_bg_cursor = theme.text

theme.tasklist_plain_task_name = true

theme.notification_bg = theme.overlay
theme.notification_border_color = "#00000000"
theme.notification_shape = theme.rounded
theme.notification_margin = theme.spacing_s
theme.notification_spacing = theme.spacing_s

function theme.colored_circle(color)
	local size = 64
	local surface = gears.surface.load_from_shape(size, size, gears.shape.circle, color)

	return surface
end

theme.primary_circle = theme.colored_circle(theme.primary)
theme.secondary_circle = theme.colored_circle(theme.secondary)
theme.accent_circle = theme.colored_circle(theme.accent)
theme.text_subtle_circle = theme.colored_circle(theme.text_subtle)

theme.titlebar_close_button_normal = theme.primary_circle
theme.titlebar_close_button_focus = theme.primary_circle

theme.titlebar_sticky_button_active = theme.secondary_circle
theme.titlebar_sticky_button_inactive = theme.text_subtle_circle

theme.titlebar_floating_button_active = theme.accent_circle
theme.titlebar_floating_button_inactive = theme.text_subtle_circle

local default_layouts = gears.filesystem.get_themes_dir() .. "default/layouts/"
theme.layout_dwindle = default_layouts .. "dwindlew.png"
theme.layout_floating = default_layouts .. "floatingw.png"
theme.layout_max = default_layouts .. "maxw.png"

beautiful.init(theme)
