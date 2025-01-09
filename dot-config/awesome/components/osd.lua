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

return function()
	local widget = gen_widget()
	local popup = awful.popup({
		shape = beautiful.rounded,
		widget = widget,
		placement = function(d)
			awful.placement.bottom(d, {
				margins = beautiful.useless_gap * 4,
				honor_workarea = true,
			})
		end,
		ontop = true,
		visible = false,
	})

	local children = misc.children({ "progress", "text" }, widget)

	local timer = gears.timer({
		timeout = user.osd_dismiss_timeout,
		single_shot = true,
		callback = function()
			popup.visible = false
		end,
	})

	local prev_volume = -1
	pulseaudio:connect_signal("volume", function(_, volume)
		if prev_volume == volume then
			return
		end

		-- ignore initial emission
		if prev_volume ~= -1 then
			popup.visible = true
			timer:again()
		end

		prev_volume = volume
		children.text.text = "V"
		children.progress.value = volume / 100
	end)

	local prev_brightness = -1
	backlight:connect_signal("brightness", function(_, brightness)
		if prev_brightness == brightness then
			return
		end

		-- ignore initial emission
		if prev_brightness ~= -1 then
			popup.visible = true
			timer:again()
		end

		prev_brightness = brightness
		children.text.text = "B"
		children.progress.value = brightness / 100
	end)
end
