local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local preview = require("screen.preview")
local taglist = require("widgets.taglist")
local misc = require("misc")
local bar = require("screen.bar")
local launcher = require("widgets.launcher")

screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper {
		screen = s,
		widget = wibox.widget.imagebox(beautiful.wallpaper(s)),
	}
end)

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag(misc.tags, s, awful.layout.layouts[1])

	launcher(s)
	bar(s)
	taglist(s)
	preview(s)
end)
