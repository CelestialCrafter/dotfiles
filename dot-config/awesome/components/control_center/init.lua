local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local notifications = require("components.control_center.notifications")
local calendar = require("components.control_center.calendar")
local general = require("components.control_center.general")
local gauges = require("components.control_center.gauges")

local function gen_widget()
	return wibox.widget({
		{
			{
				general(),
				gauges(),
				{
					calendar(),
					valign = "bottom",
					halign = "left",
					widget = wibox.container.place,
				},
				fill_space = true,
				spacing = beautiful.spacing_m,
				widget = wibox.layout.fixed.vertical,
			},
			gears.table.crush(notifications(), {
				forced_width = beautiful.spacing_xl * 10,
			}),
			spacing = beautiful.spacing_m,
			widget = wibox.layout.fixed.horizontal,
		},
		margins = beautiful.spacing_m,
		widget = wibox.container.margin,
	})
end

return function()
	local widget = gen_widget()

	return awful.popup({
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
