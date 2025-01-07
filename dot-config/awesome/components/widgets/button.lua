local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local element = require("components.widgets.element")

local M = {}

local size = beautiful.spacing_xl + beautiful.spacing_s
local function widget(_, w, color)
	return gears.table.crush(
		element({
			w,
			widget = wibox.container.place,
		}, nil, color),
		{
			forced_width = size,
			forced_height = size,
		}
	)
end

function M.array(buttons, orientation)
	orientation = orientation or "horizontal"
	buttons.layout = wibox.layout.fixed[orientation]

	return {
		buttons,
		shape = beautiful.rounded,
		bg = beautiful.overlay,
		widget = wibox.container.background,
	}
end

setmetatable(M, {
	__call = widget,
})

return M
