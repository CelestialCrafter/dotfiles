local wibox = require("wibox")

local misc = require("misc")
local mpris = require("dbus.mpris")
local element = require("components.widgets.element")

local function gen_widget()
	return wibox.widget(element({
		widget = wibox.widget.textbox,
		id = "song",
	}))
end

local function init()
	local model = {}

	local widget = gen_widget()
	local song = misc.children("song", widget)

	return model,
		widget,
		function()
			if not model.title then
				song.text = "No Media"
			else
				song.text = ("%s - %s"):format(misc.truncate(model.title, 24), misc.truncate(model.artist, 16))
			end
		end
end

return function()
	local model, widget, view = init()

	local function handle_metadata(_, metadata)
		if metadata then
			model.title = metadata.title
			model.artist = metadata.artists[1]
		else
			model.title = nil
			model.artist = nil
		end
		view()
	end

	mpris:connect_signal("metadata", handle_metadata)
	view()

	return widget
end
