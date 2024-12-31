local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local user = require("user")
local apps = require("misc.apps")
local hover = require("components.widgets.hover")

local icon_size = beautiful.spacing_xl * 1.5
local spacing = beautiful.spacing_l

local function app_widget(app)
	local widget = wibox.widget({
		image = app.icon,
		forced_width = icon_size,
		forced_height = icon_size,
		widget = wibox.widget.imagebox,
	})

	widget:add_button(awful.button({}, 1, nil, function()
		app.launch()
	end))

	return hover(widget)
end

return function(s)
	local entries_widget = wibox.widget({
		column_count = s.workarea.width / icon_size + spacing,
		spacing = spacing,
		layout = wibox.layout.grid.vertical,
	})

	for class, id in pairs(user.desktop_apps) do
		apps.class_to_id[class] = id
		local entry_widget = app_widget(assert(apps.entries[id], ("app id %s does not exist"):format(id)))
		entries_widget:add(entry_widget)
	end

	return wibox({
		widget = {
			entries_widget,
			margins = beautiful.useless_gap * 2,
			widget = wibox.container.margin,
		},
		bg = "#00000000",
		width = s.workarea.width,
		height = s.workarea.height,
		x = s.workarea.x,
		y = s.workarea.y,
		visible = true,
	})
end
