local beautiful = require("beautiful")
local wibox = require("wibox")
local menu_gen = require("menubar.menu_gen")

local margin = beautiful.margin_m
local size = (beautiful.margin_xl * 2) - margin

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
	{
		{
			spacing = margin,
			forced_num_cols = 16,
			layout = wibox.layout.grid.vertical,
			id = "entries"
		},
		widget = wibox.container.margin,
		margins = margin,
		id = "margin"
	},
	bg = beautiful.surface,
	shape = beautiful.rounded_rect,
	widget = wibox.container.background,
}

menu_gen.generate(function(new_entries)
	for _, entry in ipairs(new_entries) do
		launcher.margin.entries:add(generate_widget(entry))
	end
end)

return launcher
