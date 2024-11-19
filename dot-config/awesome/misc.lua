local awful = require("awful")
local menubar = require("menubar")
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

-- set terminal for apps that need it
menubar.utils.terminal = terminal

return {
	editor = editor,
	terminal = terminal,
	tags = tags
}
