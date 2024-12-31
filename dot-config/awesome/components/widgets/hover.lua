local wibox = require("wibox")
local beautiful = require("beautiful")

return function(w)
	local oldcursor, oldwibox

	w:connect_signal("mouse::enter", function()
		local wb = mouse.current_wibox
		if wb then
			oldcursor, oldwibox = wb.cursor, wb
			wb.cursor = "hand2"
		end
	end)

	w:connect_signal("mouse::leave", function()
		if oldwibox then
			oldwibox.cursor = oldcursor
			oldwibox = nil
		end
	end)

	return w
end
