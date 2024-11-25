local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local misc = require("misc")

return function()
    client.connect_signal("request::titlebars", function(c)
	local titlebar = awful.titlebar(c, { position = misc.position, size = beautiful.spacing_xl + beautiful.spacing_m })
	titlebar.widget = {
	    {

		awful.titlebar.widget.iconwidget(c),
		nil,
		{
		    {
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.closebutton(c),
			spacing = beautiful.spacing_m,
			layout = wibox.layout.fixed.vertical,
		    },
		    margins = beautiful.spacing_s,
		    layout = wibox.container.margin
		},
		layout = wibox.layout.align.vertical,
	    },
	    layout = wibox.container.margin,
	    margins = beautiful.spacing_m
	}
    end)
end
