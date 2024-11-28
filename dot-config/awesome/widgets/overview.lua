local awful = require("awful")
local beautiful = require("beautiful")
local expose = require("layout.expose")
local misc = require("misc")

local taglist = require("widgets.taglist")

local function show(s)
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

local function hide(s)
	for _, c in ipairs(s.all_clients) do
		-- @FIX if the titlebar is hidden, it will be shown.
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
	s.overview = awful.popup {
		widget = taglist(s),
		placement = function(d) awful.placement.left(d, { margins = beautiful.useless_gap * 2 }) end,
		shape = beautiful.rounded,
		bg = beautiful.base,
		ontop = true,
		visible = false
	}

	s.overview:struts {
		left = s.overview.widget.forced_width
	}

	local function hide_wrapper()
		hide(s)
		s.overview.visible = false
	end

	s.overview:connect_signal("property::visible", function ()
		if s.overview.visible then
			show(s)
		else
			hide(s)
		end
	end)
	s:connect_signal("tag::history::update", hide_wrapper)
	client.connect_signal("request::manage", hide_wrapper)
end
