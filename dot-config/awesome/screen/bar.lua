local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local misc = require("misc")

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
		function() s.overview.visible = not s.overview.visible end
	)))
	s.prompt = awful.widget.prompt()

	local bar = awful.wibar({
		height = beautiful.spacing_xl + beautiful.spacing_m,
		position = misc.bar_position,
		screen = s,
		bg = beautiful.base,
		shape = function(cr, w, h)
			local tl, tr, bl, br
			if misc.bar_position == "top" then
				tl, tr, bl, br = false, false, true, true
			elseif misc.bar_position == "bottom" then
				tl, tr, bl, br = true, true, false, false
			end

			gears.shape.partially_rounded_rect(cr, w, h, tl, tr, bl, br, beautiful.spacing_m)
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

