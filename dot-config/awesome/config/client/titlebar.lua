local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local user = require("user")
local hover = require("components.widgets.hover")

client.connect_signal("request::titlebars", function(c)
	awful
		.titlebar(c, {
			position = user.titlebar_position,
			size = beautiful.spacing_xl + beautiful.spacing_m,
			bg_normal = beautiful.subtle,
		})
		:setup({
			{

				awful.titlebar.widget.iconwidget(c),
				nil,
				{
					{
						hover(awful.titlebar.widget.floatingbutton(c)),
						hover(awful.titlebar.widget.stickybutton(c)),
						hover(awful.titlebar.widget.closebutton(c)),
						spacing = beautiful.spacing_m,
						layout = wibox.layout.fixed.vertical,
					},
					margins = beautiful.spacing_s,
					layout = wibox.container.margin,
				},
				layout = wibox.layout.align.vertical,
			},
			layout = wibox.container.margin,
			margins = beautiful.spacing_m,
		})
end)