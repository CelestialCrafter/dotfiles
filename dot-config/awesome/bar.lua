local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local misc = require("misc")

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
		end)
	))
	s.layout = {
		s.layout,
		margins = beautiful.margin_s,
		widget = wibox.container.margin
	}

	s.taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		widget_template = {
			{
				{
					id = 'text_role',
					widget = wibox.widget.textbox
				},
				id = 'text_margin_role',
				left = beautiful.margin_l - beautiful.margin_s,
				right = beautiful.margin_l - beautiful.margin_s,
				widget = wibox.container.margin
			},
			id = 'background_role',
			widget = wibox.container.background
		},
		buttons = gears.table.join(
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({}, 3, awful.tag.viewtoggle)
		),
	})
	s.taglist = {
		s.taglist,
		margins = beautiful.margin_s,
		widget = wibox.container.margin
	}

	s.prompt = awful.widget.prompt()
	s.clock = wibox.widget.textclock("%I:%M%P")

	s.bar = awful.wibar({ height = beautiful.margin_xl + beautiful.margin_m, position = "top", screen = s })
	s.bar:setup({
		layout = wibox.layout.align.horizontal,
		widget = wibox.container.background,
		bg = beautiful.base,
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
