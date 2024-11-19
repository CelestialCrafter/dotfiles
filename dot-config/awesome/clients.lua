local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

-- prevent unreachable clients if screens change
client.connect_signal("manage", function(c)
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)

local m = 4
local function marginify(w)
	return {
		w,
		left = dpi(m),
		right = dpi(m),
		bottom = dpi(m),
		widget = wibox.container.margin
	}
end

-- titlebar
client.connect_signal("request::titlebars", function(c)
	awful.titlebar(c, { position = 'left', size = dpi(32) }):setup({
		gears.table.join(
			marginify(awful.titlebar.widget.iconwidget(c)),
			{ top = dpi(m) }
		),
		nil,
		{
			marginify(awful.titlebar.widget.floatingbutton(c)),
			marginify(awful.titlebar.widget.stickybutton(c)),
			marginify(awful.titlebar.widget.closebutton(c)),
			layout = wibox.layout.fixed.vertical,
		},
		layout = wibox.layout.align.vertical,
	})
end)

-- focus follows cursor
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

local function warp_to_focused(c)
    if mouse.object_under_pointer() ~= c then
        local geometry = c:geometry()
        local x = geometry.x + geometry.width / 2
        local y = geometry.y + geometry.height / 2
        mouse.coords({ x = x, y = y }, true)
    end
end

client.connect_signal("swapped", warp_to_focused)
client.connect_signal("focus", warp_to_focused)

