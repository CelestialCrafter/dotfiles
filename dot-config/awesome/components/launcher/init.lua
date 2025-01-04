local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local taglist = require("components.launcher.taglist")
local menu = require("components.launcher.menu")
local dock = require("components.launcher.dock")

return function(s)
	local menu_widget, run_search = menu(s)
	local dock_widget = dock(s)

	local wallpaper = beautiful.wallpaper(s)
	local _, height = gears.surface.get_size(wallpaper)
	wallpaper = gears.surface.crop_surface({
		surface = wallpaper,
		top = s.workarea.y * (height / s.geometry.height),
	})

	s.launcher = wibox({
		widget = {
			{
				image = wallpaper,
				widget = wibox.widget.imagebox,
			},
			{
				{
					{
						taglist(s),
						left = beautiful.useless_gap * 2,
						widget = wibox.container.margin,
					},
					widget = wibox.container.place,
				},
				{
					menu_widget,
					widget = wibox.container.place,
				},
				expand = "none",
				layout = wibox.layout.align.horizontal,
			},
			{
				{
					dock_widget,
					bottom = beautiful.useless_gap * 2,
					widget = wibox.container.margin,
				},
				valign = "bottom",
				widget = wibox.container.place,
			},
			layout = wibox.layout.stack,
		},
		ontop = true,
		width = s.workarea.width,
		height = s.workarea.height,
		x = s.workarea.x,
		y = s.workarea.y,
		visible = false,
	})

	s.launcher:connect_signal("property::visible", function()
		if s.launcher.visible then
			run_search()
		else
			awful.key.execute({}, "Escape")
		end
	end)

	return s.launcher
end
