local gears = require("gears")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local themes_path = "~/.config/awesome/theme/"

local theme = {}

-- margin
theme.margin_s = dpi(4)
theme.margin_m = theme.margin_s * 2
theme.margin_l = theme.margin_m * 2
theme.margin_xl = theme.margin_l * 2

-- misc
theme.useless_gap = theme.margin_s
theme.wallpaper = "~/Pictures/Wallpapers/normal.png"
theme.font = "sans 10"

-- colors
theme.base = "#0B1221"
theme.surface = "#0D1933"
theme.overlay = "#13203B"
theme.subtle = "#667085"

theme.primary = "#87373D"
theme.secondary = "#BD6F33"
theme.accent = "#CCA66A"

theme.text = "#D2DFFC"

-- shapes
theme.rounded_rect = function(cr, w, h)
	gears.shape.rounded_rect(cr, w, h, theme.margin_m)
end

-- awesome
theme.bg_normal = theme.subtle
theme.bg_focus = theme.surface
theme.bg_urgent = theme.accent
theme.bg_minimize = theme.surface
theme.bg_systray = theme.surface

theme.taglist_bg_focus = theme.primary
theme.taglist_bg_occupied = theme.overlay
theme.taglist_shape = theme.rounded_rect
theme.taglist_spacing = theme.margin_s

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

theme.layout_floating = a
theme.layout_max = s
theme.layout_dwindle = p

return theme

