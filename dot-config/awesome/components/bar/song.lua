local wibox = require("wibox")
local beautiful = require("beautiful")

local misc = require("misc")
local mpris = require("dbus.mpris")
local element = require("components.widgets.element")

local function gen_widget()
	return element({
		{
			widget = wibox.widget.textbox,
			id = "song",
		},
		widget = wibox.container.constraint,
		width = beautiful.spacing_xl * 10,
	})
end

local function init()
	local model = {}

	local widget = gen_widget()
	local song = misc.children("song", widget)

	return model, widget, function()
		song.text = model.song or "No Media"
	end
end

return function()
	local model, widget, view = init()

	local function handle_metadata(_, metadata)
		model.song = metadata and metadata.title .. " - " .. metadata.artists[1]
		view()
	end

	mpris:connect_signal("metadata", handle_metadata)
	view()

	return widget
end
