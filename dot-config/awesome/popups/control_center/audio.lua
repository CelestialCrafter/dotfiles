local wibox = require("wibox")
local beautiful = require("beautiful")

local element = require("widgets.element")

local function volume(name)
	return {
		{
			text = name .. " Volume",
			widget = wibox.widget.textbox,
		},
		{
			forced_width = beautiful.spacing_xl * 4,
			forced_height = beautiful.spacing_l,
			widget = wibox.widget.progressbar,
			color = beautiful.accent,
			background_color = beautiful.subtle,
			shape = beautiful.rounded,
			value = 0.5,
			id = "progress",
		},
		layout = wibox.layout.fixed.vertical,
	}
end

return function()
	return wibox.widget({
		element({
			wibox.widget.textbox("Built-in Audio Analog Stereo (#191)"),
			nil,
			{
				wibox.widget.textbox("="),
				fg = beautiful.text_subtle,
				widget = wibox.container.background,
			},
			layout = wibox.layout.align.horizontal,
		}),
		{
			element({
				volume("Main"),
				volume("Media"),
				spacing = beautiful.spacing_m,
				layout = wibox.layout.fixed.vertical,
			}),
			fg = beautiful.text_subtle,
			widget = wibox.container.background,
		},
		spacing = beautiful.spacing_s,
		layout = wibox.layout.fixed.vertical,
	})
end
