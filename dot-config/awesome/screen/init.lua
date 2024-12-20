local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local misc = require("misc")
local popups = require("popups")
local preview = require("screen.preview")

screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper {
		screen = s,
		widget = wibox.widget.imagebox(beautiful.wallpaper(s)),
	}
end)

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag(misc.tags, s, awful.layout.layouts[1])

	popups(s)
	preview(s)
end)
