local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local misc      = require("misc")

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
	set_wallpaper(s)
	awful.tag(misc.tags, s, awful.layout.layouts[1])


	s.layout = awful.widget.layoutbox(s)
	s.layout:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	s.taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = gears.table.join(
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({}, 3, awful.tag.viewtoggle)
		),
	})

	s.prompt = awful.widget.prompt()
	s.clock = wibox.widget.textclock("%I:%M%P")

	s.bar = awful.wibar({ height = 24, position = "top", screen = s })
	s.bar:setup({
		layout = wibox.layout.align.horizontal,
		s.taglist,
		nil,
		{
			layout = wibox.layout.fixed.horizontal,
			s.prompt,
			s.clock,
			s.layout,
		},
	})
end)
--
