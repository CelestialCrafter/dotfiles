local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local misc = require("misc")
local pulseaudio = require("core.pulseaudio")
local backlight = require("core.backlight")
local progress = require("components.widgets.progress")

local function gen_widget()
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

	return wibox.widget({
		gauge("volume"),
		gauge("brightness"),
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
	}, widget)

	return model,
		widget,
		function()
			local v = model.volume or 0
			local b = model.brightness or 0

			children.volume.color = model.muted and beautiful.text_subtle or beautiful.accent
			children.volume.value = v / 100
			children.volume_text.text = ("V %d%%"):format(v)

			children.brightness.value = b / 100
			children.brightness_text.text = ("B %d%%"):format(b)
		end
end

return function()
	local model, widget, view = init()

	local children = misc.children({
		"volume",
		"brightness",
	}, widget)

	pulseaudio:connect_signal("volume", function(_, volume)
		model.volume = volume
		view()
	end)

	pulseaudio:connect_signal("muted", function(_, muted)
		model.muted = muted
		view()
	end)

	progress.connect(children.volume, function(_, p)
		pulseaudio.volume = p * 100
	end)

	backlight:connect_signal("brightness", function(_, brightness)
		model.brightness = brightness
		view()
	end)

	progress.connect(children.brightness, function(_, p)
		backlight.brightness = p * 100
	end)

	view()

	return widget
end
