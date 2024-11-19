local awful = require("awful")
local beautiful = require("beautiful")
local spiral = require("spiral")
require("awful.autofocus")

beautiful.init("~/.config/awesome/theme.lua")

awful.layout.layouts = {
	spiral,
	awful.layout.suit.max,
	awful.layout.suit.floating,
}

local editor = "nvim"
local terminal = "alacritty"
local tags = { "1", "2", "3", "4", "5", "6", "7", "8", "S" }

return {
	editor = editor,
	terminal = terminal,
	tags = tags
}
