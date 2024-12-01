local wibox = require("wibox")

local player = require("playerctl").player
local bar_element = require("widgets.bar_element")

return function()
	local function format(metadata)
		return metadata.title .. ' - ' .. metadata.artist
	end

	local widget = bar_element({
		widget = wibox.widget.textbox,
		id = "song"
	})

	local s = widget:get_children_by_id("song")[1]
	local function handle_metadata(_, metadata)
		if metadata == nil then
			s.text = ""
			widget.visible = false
			return
		end

		s.text = format(metadata)
		widget.visible = true
	end

	player:connect_signal("metadata", handle_metadata)
	handle_metadata(nil, player.metadata())

	return widget
end

