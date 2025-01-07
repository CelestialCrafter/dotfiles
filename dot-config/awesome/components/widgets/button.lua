local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local element = require("components.widgets.element")

local M = {}

local function widget(_, id, text, color)
	return gears.table.crush(
		element({
			text = text,
			halign = "center",
			widget = wibox.widget.textbox,
			id = id .. "_text",
		}, nil, color),
		{
			id = id,
			forced_width = beautiful.spacing_xl + beautiful.spacing_s,
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
