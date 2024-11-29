local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local user = require("user")

local function buttonify(w)
	return wibox.widget {
		{
			w,
			margins = beautiful.spacing_m,
			widget = wibox.container.margin
		},
		bg = beautiful.overlay,
		shape = beautiful.rounded,
		widget = wibox.container.background
	}
end

return function(s)
	local clock = buttonify(wibox.widget.textclock("%I:%M%P"))
	s.prompt = awful.widget.prompt()
	local overview = buttonify(wibox.widget.textbox("Overview"))
	overview:buttons(gears.table.join(awful.button(
		{}, 1, nil,
		function() s.overview.visible = not s.overview.visible end
	)))

	local bar = awful.wibar({
		height = beautiful.spacing_xl + beautiful.spacing_m,
		position = user.bar_position,
		screen = s,
		shape = function(cr, w, h)
			local tl, tr, bl, br
			if user.bar_position == "top" then
				tl, tr, bl, br = false, false, true, true
			elseif user.bar_position == "bottom" then
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
				clock,
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		},
		margins = beautiful.spacing_s,
		layout = wibox.container.margin
	})
end

