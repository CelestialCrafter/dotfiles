local gears = require("gears")
local beautiful = require("beautiful")
require("awful.autofocus")

local keybinds = require("config.keybinds")
require("config.client.titlebar")

-- focus follows cursor
client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)

-- cursor follows focus
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

client.connect_signal("request::manage", function(c)
	-- rounded corners
	c.shape = beautiful.rounded
end)

-- rounded corners if not fullscreen
client.connect_signal("property::fullscreen", function(c)
	if c.fullscreen then
		c.shape = gears.shape.rect
	else
		c.shape = beautiful.rounded
	end
end)

-- place above if floating
client.connect_signal("property::floating", function(c)
	if c.floating then
		c.above = true
	else
		c.above = false
	end
end)

client.connect_signal("request::default_keybindings", keybinds.clientkeys)
client.connect_signal("request::default_mousebindings", keybinds.clientbuttons)
