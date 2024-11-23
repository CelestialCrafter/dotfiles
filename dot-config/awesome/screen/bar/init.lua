local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local launcher  = require("widgets.launcher")

local taglist = require("screen.bar.taglist")

return function(s)
	s.prompt = awful.widget.prompt()

	local bar =  awful.wibar({
		height = beautiful.spacing_xl + beautiful.spacing_m,
		position = "top",
		screen = s,
		bg = beautiful.base,
		shape = function(cr, w, h)
			gears.shape.partially_rounded_rect(cr, w, h, false, false, true, true, beautiful.spacing_m)
		end
	})

	local launcher_button = wibox.widget {
		wibox.widget {
			text = "+",
			align = "center",
			widget = wibox.widget.textbox
		},
		shape = beautiful.rounded_rect,
		forced_width = beautiful.spacing_xl,
		forced_height = beautiful.spacing_xl,
		bg = beautiful.overlay,
		widget = wibox.container.background
	}

	s.launcher = launcher(launcher_button)

	bar:setup({
		{
			{
				taglist(s),
				launcher_button,
				spacing = beautiful.spacing_s,
				layout = wibox.layout.fixed.horizontal
			},
			nil,
			{
				s.prompt,
				wibox.widget.textclock("<big>%I:%M%P</big>"),
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		},
		margins = beautiful.spacing_s,
		layout = wibox.container.margin
	})
end

