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

	return {
		wibox.widget({
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
		indicator = indicator,
	}
end

local function gen_widget()
	local entries = wibox.widget({
		spacing = bar_margin / 2,
		layout = wibox.layout.fixed.horizontal,
	})

	return {
		wibox.widget({
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
		entries = entries,
	}
end

local function init()
	local model = { entries = {} }
	local widgets = gen_widget()

	return model,
		widgets,
		function()
			if not client.focus then
				return
			end

			for id, app_widgets in pairs(model.entries) do
				app_widgets.indicator.bg = id == apps.class_to_id[client.focus.class] and beautiful.accent
					or "#00000000"
			end
		end
end

return function(s)
	local model, widgets, view = init()

	local function prepare(app)
		local app_widgets = app_widget(app)

		app_widgets[1]:add_button(awful.button({}, 1, nil, function()
			app.launch()
			s.launcher.visible = false
		end))

		hover(app_widgets[1])
		widgets.entries:add(app_widgets[1])

		return app_widgets
	end

	for class, id in pairs(user.pinned_apps) do
		apps.class_to_id[class] = id
		model.entries[id] = prepare(assert(apps.entries[id], ("app id %s does not exist"):format(id)))
	end

	client.connect_signal("request::manage", function(c)
		local app = apps.notify(c.class)
		if not app then
			return
		end

		local entry = model.entries[app.id]
		if not entry then
			model.entries[app.id] = prepare(app)
			model.entries[app.id].windows = 1
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
			widgets.entries:remove_widgets(entry[1])
			model.entries[app.id] = nil
		else
			entry.windows = entry.windows - 1
		end
	end)

	client.connect_signal("focus", view)

	return widgets[1]
end
