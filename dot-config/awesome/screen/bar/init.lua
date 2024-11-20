local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local taglist = require("screen.bar.taglist")
local popout = require("screen.bar.popout")

return function(s)
	s.prompt = awful.widget.prompt()

	local bar =  awful.wibar({
		height = beautiful.margin_xl + beautiful.margin_m,
		position = "top",
		screen = s,
		bg = beautiful.base
	})

	local popout_button = wibox.widget.textbox("popout")
	popout(s, bar, popout_button)

	bar:setup({
		{
			taglist(s),
			nil,
			{
				s.prompt,
				popout_button,
				wibox.widget.textclock("<big>%I:%M%P</big>"),
				spacing = beautiful.margin_s,
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		},
		margins = beautiful.margin_s,
		layout = wibox.container.margin,
	})
end

