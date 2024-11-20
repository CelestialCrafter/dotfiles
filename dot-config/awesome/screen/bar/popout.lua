local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

return function(s, bar, widget)
	local popout = wibox({
		visible = false,
		ontop = true,
		height = (beautiful.margin_xl * 8) + beautiful.margin_m,
		width = s.geometry.width,
		bg = beautiful.base
	})
	popout:setup({
		{
			text   = 'Hello world!',
			widget = wibox.widget.textbox,
		},
		margins = beautiful.margin_s,
		layout = wibox.container.margin,
	})

	widget:buttons(gears.table.join(
	    awful.button({}, 1, nil, function()
		if popout.visible then
			popout.visible = false
			bar.y = 0
			bar.ontop = false
		else
			popout.visible = true
			bar.y = popout.height
			bar.ontop = true
		end
	    end)
	))
end
