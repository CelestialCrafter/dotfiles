return function(widget)
	local prev_cursor, prev_wibox

	widget:connect_signal("mouse::enter", function()
		local wibox = mouse.current_wibox
		if wibox then
			prev_cursor, prev_wibox = wibox.cursor, wibox
			wibox.cursor = "hand2"
		end
	end)

	widget:connect_signal("mouse::leave", function()
		if prev_wibox then
			prev_wibox.cursor = prev_cursor
			prev_wibox = nil
		end
	end)

	return widget
end
