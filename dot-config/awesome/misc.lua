local beautiful = require("beautiful")
require("awful.autofocus")
beautiful.init(require("theme"))

local editor = "nvim"
local terminal = "alacritty"
local tags = { "1", "2", "3", "4", "5", "6", "S" }

return {
	editor = editor,
	terminal = terminal,
	tags = tags
}
