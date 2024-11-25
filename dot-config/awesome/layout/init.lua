local awful = require("awful")
local dwindle = require("layout.dwindle")
local expose = require("layout.expose")

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		dwindle,
		expose,
		awful.layout.suit.max,
		awful.layout.suit.floating,
	})
end)
