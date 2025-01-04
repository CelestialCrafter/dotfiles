local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local beautiful = require("beautiful")

local misc = require("misc")
local notification_template = require("components.widgets.notification")

local max_notifications = 6
local notif_height = beautiful.spacing_xl * 2
local notif_spacing = beautiful.spacing_s
local height = (max_notifications * (notif_height + notif_spacing)) - notif_spacing

local function gen_widget()
	local entries = wibox.widget({
		max_widget_size = beautiful.spacing_xl * 2,
		spacing = notif_spacing,
		layout = wibox.layout.flex.vertical,
	})

	local empty = {
		{
			{
				text = "No Notifications",
				widget = wibox.widget.textbox,
			},
			fg = beautiful.text_subtle,
			widget = wibox.container.background,
		},
		id = "empty",
		widget = wibox.container.place,
	}

	return {
		wibox.widget({
			{
				{
					entries,
					empty,
					forced_height = height,
					layout = wibox.layout.stack,
				},
				margins = beautiful.spacing_s,
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
	local model = { notifications = {} }
	local widgets = gen_widget()

	local empty = misc.children("empty", widgets[1])

	local function view()
		local is_empty = #model.notifications == 0
		empty.visible = is_empty
		widgets.entries.visible = not is_empty

		widgets.entries:reset()
		for i = #model.notifications, 1, -1 do
			local n = model.notifications[i]
			if i <= #model.notifications - max_notifications then
				break
			end

			local w = wibox.widget(notification_template)

			awful.widget.common._set_common_property(w, "notification", n)
			w:add_button(awful.button({}, 1, nil, function()
				table.remove(model.notifications, i)
				view()
			end))

			widgets.entries:add(w)
		end
	end

	return model, widgets, view
end

return function()
	local model, widgets, view = init()

	naughty.connect_signal("request::display", function(n)
		table.insert(model.notifications, n)
		view()
	end)

	return widgets[1]
end
