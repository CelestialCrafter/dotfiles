local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local bar_element = require("popups.bar.element")

return function(s)
	return awful.widget.tasklist {
		screen = s,
		filter = awful.widget.tasklist.filter.focused,
		base_layout = wibox.layout.fixed.horizontal,
		widget_template = bar_element({
			{
				id     = "icon_role",
				widget = wibox.widget.imagebox,
			},
			{
				{
					id     = "text_role",
					widget = wibox.widget.textbox,
				},
				widget = wibox.container.constraint,
				width = beautiful.spacing_xl * 10
			},
			spacing = beautiful.spacing_m,
			layout = wibox.layout.fixed.horizontal
		})
	}
end
