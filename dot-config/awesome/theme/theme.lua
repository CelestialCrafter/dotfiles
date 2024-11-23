local gears = require("gears")
local xresources = require("beautiful.xresources")

local user = require("theme.user")

local dpi = xresources.apply_dpi
local themes_path = "~/.config/awesome/theme/"

local theme = {}

-- spacing
theme.spacing_s = dpi(user.base_spacing)
theme.spacing_m = theme.spacing_s * 2
theme.spacing_l = theme.spacing_m * 2
theme.spacing_xl = theme.spacing_l * 2

-- misc
theme.useless_gap = theme.spacing_s
theme.wallpaper = user.wallpaper
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

-- awesome
theme.bg_normal = theme.subtle
theme.bg_focus = theme.surface
theme.bg_urgent = theme.accent
theme.bg_minimize = theme.surface
theme.bg_systray = theme.surface

theme.fg_normal = theme.text
theme.fg_focus = theme.text
theme.fg_urgent = theme.text
theme.fg_minimize = theme.text

local p = themes_path .. "primary.png"
local s = themes_path .. "secondary.png"
local a = themes_path .. "accent.png"

theme.titlebar_close_button_normal = p
theme.titlebar_close_button_focus = p

theme.titlebar_sticky_button_normal_inactive = s
theme.titlebar_sticky_button_focus_inactive = s
theme.titlebar_sticky_button_normal_active = s
theme.titlebar_sticky_button_focus_active = s

theme.titlebar_floating_button_normal_inactive = a
theme.titlebar_floating_button_focus_inactive = a
theme.titlebar_floating_button_normal_active = a
theme.titlebar_floating_button_focus_active = a

return theme

