local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local taglist = require("popups.overview.taglist")
local expose  = require("popups.overview.expose")

return function(s)
	local expose_popup = expose(s)
	local popup = awful.popup {
		widget = {
			taglist(s),
			layout = wibox.layout.fixed.horizontal
		},
		placement = function(d) awful.placement.left(d, { margins = beautiful.useless_gap * 2 }) end,
		shape = beautiful.rounded,
		ontop = true,
		visible = false
	}

	popup:struts {
		left = popup.widget.taglist.forced_width
	}

	popup:connect_signal("property::visible", function() expose_popup.visible = popup.visible end)
	s:connect_signal("tag::history::update", function() popup.visible = false end)

	return popup
end
