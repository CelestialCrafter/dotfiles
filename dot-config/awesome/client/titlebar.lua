local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

client.connect_signal("request::titlebars", function(c)
	awful.titlebar(c, { position = 'left', size = beautiful.margin_xl + beautiful.margin_m }):setup({
            {

		awful.titlebar.widget.iconwidget(c),
		nil,
		{
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.closebutton(c),
			spacing = beautiful.margin_s,
			layout = wibox.layout.fixed.vertical,
		},
		layout = wibox.layout.align.vertical,
            },
            layout = wibox.container.margin,
            margins = beautiful.margin_m
	})
end)

