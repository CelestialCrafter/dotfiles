local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

client.connect_signal("manage", function(c)
	-- prevent unreachable clients if screens change
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end

	-- rounded corners
	c.shape = beautiful.rounded_rect
end)

-- rounded corners if not fullscreen
client.connect_signal("property::fullscreen", function(c)
	if c.fullscreen then
		c.shape = gears.shape.rect
	else
		c.shape = beautiful.rounded_rect
	end
end)

-- place above if sticky
client.connect_signal("property::sticky", function(c)
	if c.sticky then
		c.above = true
	else
		c.above = false
	end
end)
