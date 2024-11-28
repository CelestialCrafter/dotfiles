local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local misc = require("misc")
local expose = require("layout.expose")

local function tag_expose(s)
	for _, c in ipairs(s.clients) do
		awful.titlebar.hide(c, misc.position)
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
		awful.titlebar.show(c, misc.position)
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

return function(s)
	local popups = {}

	local function destroy_popups()
		for _, p in ipairs(popups) do
			p.visible = false
		end

		popups = {}
	end

	local function create_popups()
		destroy_popups()

		local margin = {
			v = beautiful.spacing_s,
			h = beautiful.spacing_xl
		}

		for _, c in ipairs(s.clients) do
			local width =  math.min(c.width, beautiful.spacing_xl * 10) - (margin.h * 2)

			table.insert(popups, awful.popup {
				widget = {
					{
						markup = "<big>" .. c.name .. "</big>",
						halign = "center",
						forced_width = width,
						widget = wibox.widget.textbox
					},
					top = margin.v,
					bottom = margin.v,
					left = margin.h,
					right = margin.h,
					widget = wibox.container.margin
				},
				bg = beautiful.overlay,
				shape = beautiful.rounded,
				x = c.x + (c.width - width) / 2 - margin.h,
				y = c.y + c.height + beautiful.spacing_m
			})
		end
	end

	-- trust its needed
	local timer = gears.timer {
		timeout = misc.visual_update_delay,
		single_shot = true,
		callback = create_popups
	}

	local function hide()
		destroy_popups()
		undo_tag_expose(s)
	end

	local function show()
		tag_expose(s)
		timer:start()
	end

	local function reshow()
		if s.overview.visible then
			show()
		end
	end

	s.overview:connect_signal("property::visible", function ()
		if s.overview.visible then
			show()
		else
			hide()
		end
	end)
	s:connect_signal("tag::history::update", function()
		if s.overview.visible then
			s.overview.visible = false
			hide()
		end
	end)
	client.connect_signal("request::manage", reshow)
	client.connect_signal("request::unmanage", reshow)
end
