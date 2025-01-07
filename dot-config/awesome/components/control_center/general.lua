local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local misc = require("misc")
local pulseaudio = require("system.pulseaudio")
local progress = require("components.widgets.progress")
local hover = require("components.widgets.hover")
local button = require("components.widgets.button")

local function top()
	local function power_action(text, color, cmd)
		local w = wibox.widget(button(text, text, color))
		hover(w, hover.bg())

		w:add_button(awful.button({}, 1, nil, function()
			awful.spawn(cmd)
		end))

		return w
	end

	local logout = power_action("L", beautiful.accent, "loginctl lock-session")
	logout:add_button(awful.button({ "Shift" }, 1, nil, function()
		awful.spawn("loginctl terminate-session")
	end))

	local poweroff = power_action("S", beautiful.primary, "systemctl poweroff")
	poweroff:add_button(awful.button({ "Shift" }, 1, nil, function()
		awful.spawn("systemctl suspend")
	end))

	local power = button.array({
		poweroff,
		power_action("R", beautiful.secondary, "systemctl reboot"),
		logout,
	})

	local size = beautiful.spacing_xl * 1.85
	return {
		{
			image = gears.surface.load(os.getenv("HOME") .. "/Pictures/user.png"),
			forced_height = size,
			forced_width = size,
			clip_shape = beautiful.rounded,
			widget = wibox.widget.imagebox,
		},
		{
			{
				markup = misc.wrap_tag(os.getenv("USER"), "big"),
				widget = wibox.widget.textbox,
			},
			power,
			spacing = beautiful.spacing_s,
			layout = wibox.layout.fixed.vertical,
		},
		spacing = beautiful.spacing_m,
		layout = wibox.layout.fixed.horizontal,
	}
end

local function gauges()
	local function gauge(id)
		return {
			{
				widget = wibox.widget.textbox,
				id = id .. "_text",
			},
			gears.table.crush(progress(0, beautiful.accent), { id = id }),
			fill_space = true,
			spacing = beautiful.spacing_s,
			layout = wibox.layout.fixed.horizontal,
		}
	end

	return {
		gauge("volume"),
		gauge("brightness"),
		gauge("battery"),
		spacing = beautiful.spacing_m,
		layout = wibox.layout.flex.vertical,
	}
end

local function gen_widget()
	return wibox.widget({
		top(),
		gauges(),
		spacing = beautiful.spacing_m,
		layout = wibox.layout.fixed.vertical,
	})
end

local function init()
	local model = {}
	local widget = gen_widget()

	local children = misc.children({
		"volume",
		"volume_text",
		"brightness",
		"brightness_text",
		"battery",
		"battery_text",
	}, widget)

	return model,
		widget,
		function()
			local v = pulseaudio.volume
			local b = model.brightness or 0
			local bt = model.battery or 0

			children.volume.value = v
			children.volume_text.text = ("V %d%%"):format(v * 100)

			-- @TODO brightness/battery
			children.brightness.value = b
			children.brightness_text.text = ("B %d%%"):format(b * 100)

			children.battery.value = bt
			children.battery_text.text = ("T %d%%"):format(bt * 100)
		end
end

return function()
	local model, widget, view = init()
	view()

	local children = misc.children({
		"volume",
		"brightness",
	}, widget)

	gears.timer({
		timeout = misc.general_update_interval,
		autostart = true,
		callback = view,
	})

	progress.connect(children.volume, function(_, p)
		pulseaudio.volume = p
	end)

	view()

	return widget
end
