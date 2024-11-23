local awful = require("awful")
local beautiful = require("beautiful")
local dwindle = require("layouts.dwindle")
local expose = require("layouts.expose")
require("awful.autofocus")

beautiful.init("~/.config/awesome/theme/theme.lua")

awful.layout.layouts = {
	dwindle,
	expose,
	awful.layout.suit.max,
	awful.layout.suit.floating,
}

local editor = "nvim"
local terminal = "alacritty"
local tags = { "1", "2", "3", "4", "5", "6", "S" }

return {
	editor = editor,
	terminal = terminal,
	tags = tags
}
