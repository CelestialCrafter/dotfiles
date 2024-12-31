local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local user = require("user")
local apps = require("misc.apps")
local hover = require("components.widgets.hover")

local icon_size = beautiful.spacing_xl * 1.25
local icon_margin = icon_size * 0.25
local bar_margin = beautiful.spacing_m
local indicator_size = beautiful.spacing_s

local function app_widget(app, s)
	local indicator_margin = (bar_margin + icon_margin - indicator_size) / 2
	local widget = wibox.widget({
		{
			{
				image = app.icon,
				forced_width = icon_size,
				forced_height = icon_size,
				widget = wibox.widget.imagebox,
			},
			left = icon_margin,
			top = bar_margin + icon_margin,
			right = icon_margin,
			widget = wibox.container.margin,
		},
		{
			wibox.widget({
				forced_width = icon_size + icon_margin,
				forced_height = indicator_size,
				shape = beautiful.rounded,
				widget = wibox.container.background,
			}),
			-- i dont know why the +1 is needed but it is
			bottom = indicator_margin + 1,
			top = indicator_margin,
			widget = wibox.container.margin,
			id = "icon",
		},
		layout = wibox.layout.fixed.vertical,
	})

	widget:add_button(awful.button({}, 1, nil, function()
		app.launch()
		s.launcher.visible = false
	end))

	return hover(widget)
end

return function(s)
	local entries_widget = wibox.widget({
		spacing = bar_margin / 2,
		layout = wibox.layout.fixed.horizontal,
	})

	local entries = {}

	for class, id in pairs(user.pinned_apps) do
		apps.class_to_id[class] = id
		local entry_widget = app_widget(assert(apps.entries[id], ("app id %s does not exist"):format(id)), s)
		entries_widget:add(entry_widget)
		entries[id] = { entry_widget }
	end

	client.connect_signal("focus", function(c)
		for id, entry in pairs(entries) do
			-- indicator.bg = beautiful.accent if focused else blank
			entry[1]:get_children_by_id("icon")[1].children[1].bg = id == apps.class_to_id[c.class] and beautiful.accent
				or "#00000000"
		end
	end)

	client.connect_signal("request::manage", function(c)
		local app = apps.notify(c.class)
		if not app then
			return
		end

		local entry = entries[app.id]
		if not entry then
			local entry_widget = app_widget(app, s)
			entries_widget:add(entry_widget)
			entries[app.id] = { entry_widget, windows = 1 }
		elseif entry.windows then
			entry.windows = entry.windows + 1
		end
	end)

	client.connect_signal("request::unmanage", function(c)
		local app = apps.entries[apps.class_to_id[c.class]]
		if not app then
			return
		end

		local entry = entries[app.id]
		if not entry.windows then
			return
		end

		if entry.windows == 1 then
			entries_widget:remove_widgets(entry[1])
			entries[app.id] = nil
		else
			entry.windows = entry.windows - 1
		end
	end)

	return wibox.widget({
		{
			entries_widget,
			left = bar_margin,
			right = bar_margin,
			widget = wibox.container.margin,
		},
		bg = beautiful.surface,
		shape = beautiful.rounded,
		widget = wibox.container.background,
	})
end
