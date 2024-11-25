local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

return function(s)
	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		style = {
			spacing = beautiful.spacing_s,
			shape = beautiful.rounded,
			bg_focus = beautiful.primary,
			bg_occupied = beautiful.overlay
		},
		widget_template = {
			{
				{
					{
						id = "text_role",
						align = "center",
						widget = wibox.widget.textbox
					},
					id = "text_margin_role",
					forced_width = beautiful.spacing_xl,
					forced_height = beautiful.spacing_xl,
					widget = wibox.container.margin
				},
				id = "background_role",
				widget = wibox.container.background
			},
			layout = wibox.layout.fixed.vertical
		},
		buttons = gears.table.join(
		awful.button({}, 1, function(t)
			t:view_only()
		end),
		awful.button({}, 3, awful.tag.viewtoggle)
		)
	})
end
