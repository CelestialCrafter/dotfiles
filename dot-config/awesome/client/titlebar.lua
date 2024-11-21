local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local position = 'left'

client.connect_signal("request::titlebars", function(c)
	awful.titlebar(c, { position = position, size = beautiful.spacing_xl + beautiful.spacing_m }):setup({
            {

		awful.titlebar.widget.iconwidget(c),
		nil,
		{
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.closebutton(c),
			spacing = beautiful.spacing_s,
			layout = wibox.layout.fixed.vertical,
		},
		layout = wibox.layout.align.vertical,
            },
            layout = wibox.container.margin,
            margins = beautiful.spacing_m
	})
end)

return {
    position = position
}
