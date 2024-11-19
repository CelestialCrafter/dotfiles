local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function space(w)
    return {
        w,
        layout = wibox.container.margin,
        bottom = beautiful.margin_s,
        left = beautiful.margin_s,
        right = beautiful.margin_s
    }
end

client.connect_signal("request::titlebars", function(c)
	awful.titlebar(c, { position = 'left', size = beautiful.margin_xl + beautiful.margin_m }):setup({
            {

		awful.titlebar.widget.iconwidget(c),
		nil,
		{
			space(awful.titlebar.widget.floatingbutton(c)),
			space(awful.titlebar.widget.stickybutton(c)),
			space(awful.titlebar.widget.closebutton(c)),
			layout = wibox.layout.fixed.vertical,
		},
		layout = wibox.layout.align.vertical,
            },
            layout = wibox.container.margin,
            margins = beautiful.margin_m
	})
end)

