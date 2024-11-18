local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- prevent unreachable clients if screens change
client.connect_signal("manage", function(c)
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)

-- titlebar
client.connect_signal("request::titlebars", function(c)
	awful.titlebar(c):setup({
		awful.titlebar.widget.titlewidget(c),
		nil,
		{
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- focus follows cursor
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

local function warp_to_focused(c)
    if mouse.object_under_pointer() ~= c then
        local geometry = c:geometry()
        local x = geometry.x + geometry.width/2
        local y = geometry.y + geometry.height/2
        mouse.coords({x = x, y = y}, true)
    end
end

client.connect_signal("swapped", warp_to_focused)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
	warp_to_focused(c)
end)

client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

