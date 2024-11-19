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

-- set terminal for apps that need it
menubar.utils.terminal = terminal

return {
	editor = editor,
	terminal = terminal
}
