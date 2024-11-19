local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local themes_path = "~/.config/awesome/theme/"

-- variable sets:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

local theme = {}

theme.base = "#0B1221"
theme.surface = "#0D1933"
theme.overlay = "#13203B"
theme.subtle = "#667085"

theme.primary = "#87373D"
theme.secondary = "#BD6F33"
theme.accent = "#CCA66A"

theme.text = "#D2DFFC"
theme.font = "sans 8"

theme.bg_normal = theme.subtle
theme.bg_focus = theme.surface
theme.bg_urgent = theme.accent
theme.bg_minimize = theme.surface
theme.bg_systray = theme.surface

theme.taglist_bg_occupied = theme.overlay
theme.wibar_bg = theme.base

theme.fg_normal = theme.text
theme.fg_focus = theme.text
theme.fg_urgent = theme.text
theme.fg_minimize = theme.text

theme.useless_gap = dpi(4)
theme.wallpaper = "~/Pictures/Wallpapers/normal.png"

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

