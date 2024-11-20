local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local taglist = require("screen.bar.taglist")
local popout = require("screen.bar.popout")

return function(s)
	s.prompt = awful.widget.prompt()

	local bar =  awful.wibar({
		height = beautiful.margin_xl + beautiful.margin_m,
		position = "top",
		screen = s,
		bg = beautiful.base,
		shape = function(cr, w, h)
			gears.shape.partially_rounded_rect(cr, w, h, false, false, true, true, beautiful.margin_m)
		end
	})

	local popout_button = wibox.widget {
		wibox.widget {
			text = "+",
			align = "center",
			widget = wibox.widget.textbox
		},
		shape = beautiful.rounded_rect,
		forced_width = beautiful.margin_xl,
		forced_height = beautiful.margin_xl,
		bg = beautiful.overlay,
		widget = wibox.container.background
	}
	popout(s, bar, popout_button)

	bar:setup({
		{
			{
				taglist(s),
				popout_button,
				spacing = beautiful.margin_s,
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
		margins = beautiful.margin_s,
		layout = wibox.container.margin
	})
end

