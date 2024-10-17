local awful = require("awful")
local beautiful = require("beautiful")

beautiful.init("~/.config/awesome/theme.lua")

require("awful.autofocus")

awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
}
