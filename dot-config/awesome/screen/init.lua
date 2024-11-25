local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local misc = require("misc")
local bar = require("screen.bar")
local launcher  = require("widgets.launcher")

screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper {
		screen = s,
		widget = {
			image = gears.surface.crop_surface {
				surface = gears.surface.load(beautiful.wallpaper),
				ratio = s.geometry.width/s.geometry.height,
			},
			widget = wibox.widget.imagebox
		},
	}
end)

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag(misc.tags, s, awful.layout.layouts[1])

	launcher(s)
	bar(s)
end)
