local beautiful = require("beautiful")
local wibox = require("wibox")

local function widget(width, color)
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
		id = "progress",
	}
end

local function connect(progress, cb)
	progress:connect_signal("button::release", function(self, x, _, _, _, result)
		cb(self, 1 / (result.widget_width / x))
	end)
end

return {
	widget = widget,
	connect = connect,
}
