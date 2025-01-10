local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local misc = require("misc")
local user = require("user")
local progress = require("components.widgets.progress")
local backlight = require("core.backlight")
local pulseaudio = require("core.pulseaudio")

local function gen_widget()
	return wibox.widget({
		{
			{
				widget = wibox.widget.textbox,
				id = "text",
			},
			gears.table.crush(progress(beautiful.spacing_xl * 8, beautiful.accent), { id = "progress" }),
			spacing = beautiful.spacing_m,
			layout = wibox.layout.fixed.horizontal,
		},
		margins = beautiful.spacing_l,
		widget = wibox.container.margin,
	})
end

local function init()
	local model = {}
	local widget = gen_widget()

	local children = misc.children({ "progress", "text" }, widget)

	return model,
		widget,
		function()
			if model.type == "pulseaudio" then
				children.text.text = "V"
				children.progress.color = pulseaudio.muted and beautiful.text_subtle or beautiful.accent
				children.progress.value = (pulseaudio.volume or 0) / 100
			else
				children.text.text = "B"
				children.progress.color = beautiful.accent
				children.progress.value = backlight.brightness / 100
			end
		end
end

return function()
	local model, widget, view = init()
	local popup = awful.popup({
		widget = widget,
		shape = beautiful.rounded,
		placement = function(d)
			awful.placement.bottom(d, {
				margins = beautiful.useless_gap * 4,
				honor_workarea = true,
			})
		end,
		ontop = true,
		visible = false,
	})

	local timer = gears.timer({
		timeout = user.dismiss_timeout,
		single_shot = true,
		callback = function()
			popup.visible = false
		end,
	})

	popup:connect_signal("show", function(_, type)
		model.type = type
		view()
		popup.visible = true
		timer:again()
	end)

	return popup
end
