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
		)
	})

	s.prompt = awful.widget.prompt()
	s.clock = wibox.widget.textclock("<big>%I:%M%P</big>")

	s.popout = wibox({
		visible = false,
		ontop = true,
		height = (beautiful.margin_xl * 8) + beautiful.margin_m,
		width = s.geometry.width,
		bg = beautiful.base
	})
	s.popout:setup({
		{
			text   = 'Hello world!',
			widget = wibox.widget.textbox,
		},
		margins = beautiful.margin_s,
		layout = wibox.container.margin,
	})

	s.popout_button = wibox.widget.textbox("popout")
	s.popout_button:buttons(gears.table.join(
	    awful.button({}, 1, nil, function()
		if s.popout.visible then
			s.popout.visible = false
			s.bar.y = 0
		else
			s.popout.visible = true
			s.bar.y = s.popout.height
		end
	    end)
	))

	s.bar =  awful.wibar({
		height = beautiful.margin_xl + beautiful.margin_m,
		position = "top",
		screen = s,
		ontop = true,
		bg = beautiful.base
	})
	s.bar:setup({
		{
			s.taglist,
			nil,
			{
				s.prompt,
				s.popout_button,
				s.clock,
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		},
		margins = beautiful.margin_s,
		layout = wibox.container.margin,
	})
end)

