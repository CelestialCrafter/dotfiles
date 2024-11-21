local beautiful = require("beautiful")
local wibox = require("wibox")
local menu_gen = require("menubar.menu_gen")

local size = beautiful.margin_xl * 2


local function generate_widget(entry)
	return wibox.widget {
		{
			image  = entry.icon,
			resize = true,
			forced_height = size,
			widget = wibox.widget.imagebox
		},
		{
			text = entry.name,
			align  = 'center',
			widget = wibox.widget.textbox
		},
		forced_width = size,
		layout = wibox.layout.fixed.vertical
	}
end

local launcher = wibox.widget {
	spacing = beautiful.margin_s,
	forced_num_cols = 16,
	layout = wibox.layout.grid.vertical
}

menu_gen.generate(function(new_entries)
	for _, entry in ipairs(new_entries) do
		launcher:add(generate_widget(entry))
	end
end)

return launcher
