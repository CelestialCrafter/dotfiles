local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

return function(s)
	 return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		widget_template = {
			{
				{
					id = 'text_role',
					widget = wibox.widget.textbox
				},
				id = 'text_margin_role',
				left = beautiful.margin_l - beautiful.margin_s,
				right = beautiful.margin_l - beautiful.margin_s,
				widget = wibox.container.margin
			},
			id = 'background_role',
			widget = wibox.container.background
		},
		buttons = gears.table.join(
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({}, 3, awful.tag.viewtoggle)
		)
	})
end
