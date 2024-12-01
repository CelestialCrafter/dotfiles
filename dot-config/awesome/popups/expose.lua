local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local user = require("user")
local misc = require("misc")
local expose = require("layout.expose")

local function tag_expose(s)
	-- @FIX changing layouts is not disabled when expose is active
	for _, c in ipairs(s.clients) do
		awful.titlebar.hide(c, user.titlebar_position)
	end

	local t = s.selected_tag
	if t.prev ~= nil then
		return
	end

	t.prev = {
		layout = t.layout,
		gap = t.gap
	}

	t.layout = expose
	t.gap = beautiful.spacing_xl
end

local function undo_tag_expose(s)
	for _, c in ipairs(s.all_clients) do
		-- @FIX if the titlebar was hidden before overview, it will be shown.
		-- the api to check the titlebar state is not exposed
		awful.titlebar.show(c, user.titlebar_position)
	end

	for _, t in ipairs(s.tags) do
		if t.prev == nil then
			goto continue
		end

		t.layout = t.prev.layout
		t.gap = t.prev.gap
		t.prev = nil

		::continue::
	end
end

local function label(c)
	local margin = {
		v = beautiful.spacing_s,
		h = beautiful.spacing_xl
	}

	return {
		{
			{
				markup = "<big>" .. gears.string.xml_escape(c.name) .. "</big>",
				halign = "center",
				widget = wibox.widget.textbox
			},
			top = margin.v,
			bottom = margin.v,
			left = margin.h,
			right = margin.h,
			widget = wibox.container.margin
		},
		bg = beautiful.overlay,
		widget = wibox.container.background,
		shape = beautiful.rounded,
		forced_width = math.min(c.width, beautiful.spacing_xl * 10) - (margin.h * 2),
		forced_height = beautiful.spacing_xl
	}
end

local function icon(c)
	return {
		{
			client = c,
			forced_width = beautiful.spacing_xl,
			forced_height = beautiful.spacing_xl,
			widget = awful.widget.clienticon
		},
		margins = beautiful.spacing_m,
		widget = wibox.container.margin
	}
end

return function(s)
	local popup = awful.popup {
		widget = wibox.widget {
			layout = wibox.layout.manual
		},
		bg = "#00000000",
		ontop = true,
		visible = false,
		input_passthrough = true
	}

	-- @TODO update overlays instead of completely resetting them every update
	local function create_overlays()
		local overlays = {}
		for _, c in ipairs(s.clients) do
			-- @FIX re-arranging clients while expose is active does not re-arrange labels
			table.insert(overlays, {
				{
					icon(c),
					widget = wibox.container.place,
					halign = "left",
					valign = "top",
				},
				{
					label(c),
					widget = wibox.container.place,
					valign = "bottom",
				},
				forced_width = c.width,
				forced_height = c.height + (beautiful.spacing_xl / 2),
				fill_space = true,
				layout = wibox.layout.fixed.vertical,
				point = {
					x = c.x,
					y = c.y,
				}
			})
		end

		popup.widget:reset()
		popup.widget:add(table.unpack(overlays))
	end

	local timer = gears.timer {
		timeout = misc.visual_update_delay,
		single_shot = true,
		callback = create_overlays
	}

	local function start() timer:again() end
	popup:connect_signal("property::visible", function()
		if popup.visible then
			tag_expose(s)
			start()
			client.connect_signal("request::manage", start)
			client.connect_signal("request::unmanage", start)
		else
			undo_tag_expose(s)
			client.disconnect_signal("request::manage", start)
			client.disconnect_signal("request::unmanage", start)
		end
	end)

	return popup
end
