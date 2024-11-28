local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local expose = require("widgets.expose")
local overview = require("widgets.overview")
local launcher = require("widgets.launcher")
local preview = require("screen.preview")
local bar = require("screen.bar")
local misc = require("misc")

screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper {
		screen = s,
		widget = wibox.widget.imagebox(beautiful.wallpaper(s)),
	}
end)

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag(misc.tags, s, awful.layout.layouts[1])

	bar(s)
	launcher(s)
	preview(s)
	overview(s)
	expose(s)
end)
