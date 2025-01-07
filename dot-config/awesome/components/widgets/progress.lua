local beautiful = require("beautiful")
local wibox = require("wibox")

local hover = require("components.widgets.hover")

local M = {}

local function widget(_, width, color)
	if not color then
		color = beautiful.accent
	end

	return {
		forced_height = beautiful.spacing_l,
		forced_width = width,
		widget = wibox.widget.progressbar,
		color = color,
		background_color = beautiful.subtle,
		shape = beautiful.rounded,
	}
end

function M.connect(progress, cb)
	hover(progress)
	progress:connect_signal("button::release", function(self, x, _, _, _, result)
		cb(self, 1 / (result.widget_width / x))
	end)
end

setmetatable(M, {
	__call = widget,
})

return M
