local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local misc = require("misc")
local bar = require("screen.bar")
local launcher  = require("widgets.launcher")

local function set_wallpaper(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- reset wallpaper when screen shape changes
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	awful.tag(misc.tags, s, awful.layout.layouts[1])

	set_wallpaper(s)
	launcher(s)
	bar(s)
end)
