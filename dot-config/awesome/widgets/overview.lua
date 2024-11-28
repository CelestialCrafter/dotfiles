local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local taglist = require("widgets.taglist")

return function(s)
	s.overview = awful.popup {
		widget = {
			taglist(s),
			layout = wibox.layout.fixed.horizontal
		},
		placement = function(d) awful.placement.left(d, { margins = beautiful.useless_gap * 2 }) end,
		shape = beautiful.rounded,
		bg = beautiful.base,
		ontop = true,
		visible = false
	}

	s.overview:struts {
		left = s.overview.widget.taglist.forced_width
	}
end
