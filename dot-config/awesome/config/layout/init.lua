local awful = require("awful")

local dwindle = require("config.layout.dwindle")

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		dwindle,
		awful.layout.suit.max,
		awful.layout.suit.floating,
	})
end)
