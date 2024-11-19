local awful = require("awful")
local beautiful = require("beautiful")

-- prevent unreachable clients if screens change
client.connect_signal("manage", function(c)
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)

-- rounded corners
client.connect_signal("manage", function (c)
    c.shape = beautiful.rounded_rect
end)

