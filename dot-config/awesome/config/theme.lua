local gears = require("gears")
local beautiful = require("beautiful")

local user = require("user")

local dpi = beautiful.xresources.apply_dpi

local theme = {}

-- spacing
theme.spacing_s = dpi(user.base_spacing)
theme.spacing_m = theme.spacing_s * user.spacing_multiplier
theme.spacing_l = theme.spacing_m * user.spacing_multiplier
theme.spacing_xl = theme.spacing_l * user.spacing_multiplier

-- misc
theme.tasklist_plain_task_name = true
theme.useless_gap = theme.spacing_s
theme.wallpaper_path = user.wallpaper
theme.wallpaper = function(s)
	return gears.surface.crop_surface({
		surface = gears.surface(beautiful.wallpaper_path),
		ratio = s.geometry.width / s.geometry.height,
	})
end
theme.font = user.font
theme.rounded = function(cr, w, h)
	local r = theme.spacing_s * (2 ^ (user.roundness - 1))
	gears.shape.rounded_rect(cr, w, h, r)
end

-- colors
theme.base = user.base
theme.surface = user.surface
theme.overlay = user.overlay
theme.subtle = user.subtle

theme.primary = user.primary
theme.secondary = user.secondary
theme.accent = user.accent

theme.text = user.text
theme.text_subtle = user.text_subtle

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

function theme.colored_circle(color)
	local size = 64
	local surface = gears.surface.load_from_shape(size, size, gears.shape.circle, color)

	return surface
end

theme.primary_circle = theme.colored_circle(theme.primary)
theme.secondary_circle = theme.colored_circle(theme.secondary)
theme.accent_circle = theme.colored_circle(theme.accent)

theme.titlebar_close_button_normal = theme.primary_circle
theme.titlebar_close_button_focus = theme.primary_circle

theme.titlebar_sticky_button_normal_inactive = theme.secondary_circle
theme.titlebar_sticky_button_focus_inactive = theme.secondary_circle
theme.titlebar_sticky_button_normal_active = theme.secondary_circle
theme.titlebar_sticky_button_focus_active = theme.secondary_circle

theme.titlebar_floating_button_normal_inactive = theme.accent_circle
theme.titlebar_floating_button_focus_inactive = theme.accent_circle
theme.titlebar_floating_button_normal_active = theme.accent_circle
theme.titlebar_floating_button_focus_active = theme.accent_circle

beautiful.init(theme)
