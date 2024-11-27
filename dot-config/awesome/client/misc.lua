local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local keybinds  = require("keybinds")

return function()
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
end
