local awful = require("awful")
local beautiful = require("beautiful")
local apps = require("misc.apps")

local M = {
	visual_update_delay = 0.05,
	media_position_update_interval = 0.5,
}

function M.setup()
	awful.spawn("picom")
	apps.setup()
end

function M.font_height()
	return beautiful.get_font_height(beautiful.font)
end

return M
