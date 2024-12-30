local wibox = require("wibox")
local beautiful = require("beautiful")

local mpris = require("connect.mpris")
local element = require("components.widgets.element")

return function()
	local function format(metadata)
		return metadata.title .. " - " .. metadata.artist
	end

	local widget = element({
		{
			widget = wibox.widget.textbox,
			id = "song",
		},
		widget = wibox.container.constraint,
		width = beautiful.spacing_xl * 10,
	})

	local s = widget:get_children_by_id("song")[1]
	local function handle_metadata(_, metadata)
		s.text = format(metadata)
	end

	local function handle_empty()
		s.text = "No Media"
	end

	handle_empty()
	mpris:connect_signal("metadata", handle_metadata)
	mpris:connect_signal("empty", handle_empty)

	return widget
end
