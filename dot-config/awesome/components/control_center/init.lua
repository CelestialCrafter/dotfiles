local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local notifications = require("components.control_center.notifications")
local calendar = require("components.control_center.calendar")
local general = require("components.control_center.general")

local function gen_widget()
	local notifications_widget = notifications()
	notifications_widget.forced_width = beautiful.spacing_xl * 8

	return wibox.widget({
		{
			{
				general(),
				{
					calendar(),
					valign = "bottom",
					widget = wibox.container.place,
				},
				fill_space = true,
				spacing = beautiful.spacing_m,
				widget = wibox.layout.fixed.vertical,
			},
			notifications_widget,
			spacing = beautiful.spacing_m,
			widget = wibox.layout.fixed.horizontal,
		},
		margins = beautiful.spacing_m,
		widget = wibox.container.margin,
	})
end

return function(s)
	local widget = gen_widget()

	s.control_center = awful.popup({
		widget = widget,
		shape = beautiful.rounded,
		ontop = true,
		visible = false,
		placement = function(d)
			awful.placement.top_left(d, {
				margins = beautiful.useless_gap * 2,
				honor_workarea = true,
			})
		end,
	})
end
