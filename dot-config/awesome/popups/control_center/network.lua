local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local nm = require("connect.networkmanager")

local function generate_widget(network)
	local state = ""
	if network[1] == 2 then
		state = "Connected"
	elseif network[1] == 1 then
		state = "Connecting"
	elseif network[1] == 3 then
		state = "Disconnecting"
	end

	local widget = wibox.widget {
		{
			{
				{
					wibox.widget.textbox("^"),
					fg = (network[1] == 1 or network[1] == 2) and beautiful.accent or nil,
					widget = wibox.container.background
				},
				{
					text = network[2],
					widget = wibox.widget.textbox
				},
				spacing = beautiful.spacing_m,
				layout = wibox.layout.fixed.horizontal
			},
			nil,
			wibox.widget.textbox(state),
			layout = wibox.layout.align.horizontal
		},
		fg = network[1] == 0 and beautiful.text_subtle or nil,
		widget = wibox.container.background
	}

	if network[1] ~= 0 then
		widget:add_button(awful.button(
			{}, 1, nil,
			function ()
				local connected = network[1] == 1 or network[1] == 2
				local fn = connected and nm.disconnect or nm.connect
				fn(network[3])
			end
		))
	end

	return widget
end

return function()
	local widget = wibox.widget {
		{
			id = "networks",
			spacing = beautiful.spacing_l,
			layout = wibox.layout.fixed.vertical
		},
		margins = beautiful.spacing_m,
		widget = wibox.container.margin
	}

	local networks_widget = widget:get_children_by_id("networks")[1]
	nm:connect_signal("networks", function(_, lgi_networks)
		if #lgi_networks == 0 then
			return
		end

		local networks = {}
		for i, n in lgi_networks:ipairs() do
			networks[i] = n
		end

		table.sort(networks, function (a, b)
			return a[1] < b[1]
		end)


		local widgets = {}
		for _, n in ipairs(networks) do
			table.insert(widgets, generate_widget(n))
		end

		networks_widget:reset()
		networks_widget:add(table.unpack(widgets))
	end)

	return widget
end
