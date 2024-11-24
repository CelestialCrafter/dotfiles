local awful = require("awful")
local dwindle = require("layout.dwindle")
local expose = require("layout.expose")

awful.layout.layouts = {
	dwindle,
	expose,
	awful.layout.suit.max,
	awful.layout.suit.floating,
}
