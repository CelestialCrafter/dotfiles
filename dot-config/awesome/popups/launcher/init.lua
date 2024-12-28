local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local taglist = require("popups.launcher.taglist")
local menu = require("popups.launcher.menu")

return function(s)
	local menu_widget, run_search = menu(s)

	local wallpaper = beautiful.wallpaper(s)
	local _, height = gears.surface.get_size(wallpaper)
	s.launcher = wibox({
		widget = {
			wibox.widget.imagebox(gears.surface.crop_surface({
				surface = wallpaper,
				top = s.workarea.y * (height / s.geometry.height),
			})),
			{
				wibox.container.place({
					taglist(s),
					left = beautiful.useless_gap * 2,
					widget = wibox.container.margin,
				}, nil, "center"),
				wibox.container.place(menu_widget, nil, "center"),
				expand = "none",
				layout = wibox.layout.align.horizontal,
			},
			wibox.container.place({
				s.dock_widget,
				bottom = beautiful.useless_gap * 2,
				widget = wibox.container.margin,
			}, "center", "bottom"),
			layout = wibox.layout.stack,
		},
		ontop = true,
		width = s.workarea.width,
		height = s.workarea.height,
		x = s.workarea.x,
		y = s.workarea.y,
		visible = false,
	})

	s:connect_signal("tag::history::update", function()
		if s.launcher.visible then
			s.launcher.visible = false
			awful.key.execute({}, "Escape")
		end
	end)

	s.launcher:connect_signal("property::visible", function()
		if s.launcher.visible then
			run_search()
		end
	end)

	return s.launcher
end
