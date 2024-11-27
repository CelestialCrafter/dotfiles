local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

return function(s)
	local overview = wibox.widget {
		{
			wibox.widget.textbox("Overview"),
			margins = beautiful.spacing_m,
			widget = wibox.container.margin
		},
		bg = beautiful.overlay,
		shape = beautiful.rounded,
		widget = wibox.container.background
	}

	overview:buttons(gears.table.join(awful.button(
		{},
		1,
		nil,
		function()
			s.taglist.visible = not s.taglist.visible
		end
	)))
	s.prompt = awful.widget.prompt()

	local bar = awful.wibar({
		height = beautiful.spacing_xl + beautiful.spacing_m,
		position = "top",
		screen = s,
		bg = beautiful.base,
		shape = function(cr, w, h)
			gears.shape.partially_rounded_rect(cr, w, h, false, false, true, true, beautiful.spacing_m)
		end
	})

	bar:setup({
		{
			{
				overview,
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

