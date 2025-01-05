local awful = require("awful")
local beautiful = require("beautiful")
local apps = require("misc.apps")

local M = {
	visual_update_delay = 0.05,
	preview_update_interval = 0.5,
	media_position_update_interval = 0.5,
}

function M.setup()
	awful.spawn("picom")
	apps.setup()
end

function M.font_height()
	return beautiful.get_font_height(beautiful.font)
end

function M.children(ids, widget)
	local single = false
	if type(ids) == "string" then
		single = true
		ids = { ids }
	end

	local widgets = {}

	for _, id in ipairs(ids) do
		widgets[id] = widget:get_children_by_id(id)[1]
	end

	return single and widgets[ids[1]] or widgets
end

return M
