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
local indicator_margin = (bar_margin + icon_margin - indicator_size) / 2

local function app_widget(app)
	local indicator = wibox.widget({
		forced_width = icon_size + icon_margin,
		forced_height = indicator_size,
		shape = beautiful.rounded,
		widget = wibox.container.background,
	})

	return wibox.widget({
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
			indicator,
			-- i dont know why the +1 is needed but it is
			bottom = indicator_margin + 1,
			top = indicator_margin,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.vertical,
	}),
		indicator
end

local function gen_widget()
	local entries = wibox.widget({
		spacing = bar_margin / 2,
		layout = wibox.layout.fixed.horizontal,
	})

	return wibox.widget({
		{
			entries,
			left = bar_margin,
			right = bar_margin,
			widget = wibox.container.margin,
		},
		bg = beautiful.surface,
		shape = beautiful.rounded,
		widget = wibox.container.background,
	}),
		entries
end

local function init()
	local model = { entries = {} }
	local widget, entries = gen_widget()

	return model,
		widget,
		entries,
		function()
			if not client.focus then
				return
			end

			for id, entry in pairs(model.entries) do
				entry.indicator.bg = id == apps.class_to_id[client.focus.class] and beautiful.accent or "#00000000"
			end
		end
end

return function(s)
	local model, widget, entries_widget, view = init()

	local function prepare(app)
		local w, i = app_widget(app)

		w:add_button(awful.button({}, 1, nil, function()
			app.launch()
			s.launcher.visible = false
		end))

		hover(w)
		entries_widget:add(w)

		return w, i
	end

	for class, id in pairs(user.pinned_apps) do
		apps.class_to_id[class] = id
		local w, i = prepare(assert(apps.entries[id], ("app id %s does not exist"):format(id)))
		model.entries[id] = { widget = w, indicator = i }
	end

	client.connect_signal("request::manage", function(c)
		local app = apps.notify(c.class)
		if not app then
			return
		end

		local entry = model.entries[app.id]
		if not entry then
			local w, i = prepare(app)
			model.entries[app.id] = { widget = w, indicator = i, windows = 1 }
		elseif entry.windows then
			entry.windows = entry.windows + 1
		end
	end)

	client.connect_signal("request::unmanage", function(c)
		local app = apps.entries[apps.class_to_id[c.class]]
		if not app then
			return
		end

		local entry = model.entries[app.id]
		if not entry.windows then
			return
		end

		if entry.windows == 1 then
			entries_widget:remove_widgets(entry.widget)
			model.entries[app.id] = nil
		else
			entry.windows = entry.windows - 1
		end
	end)

	client.connect_signal("focus", view)

	return widget
end
