local wibox = require("wibox")

local misc = require("misc")
local mpris = require("core.mpris")

local function init()
	local model = {}

	local widget = wibox.widget.textbox()
	return model,
		widget,
		function()
			if not model.title then
				widget.text = "No Media"
			else
				widget.text = ("%s - %s"):format(misc.truncate(model.title, 26), misc.truncate(model.artist, 20))
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
	handle_metadata(mpris:metadata())

	return widget
end
