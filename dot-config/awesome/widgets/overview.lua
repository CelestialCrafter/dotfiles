local awful = require("awful")
local beautiful = require("beautiful")
local expose = require("layout.expose")
local misc = require("misc")

local taglist = require("widgets.taglist")

local function show(s, t)
	for _, c in ipairs(s.clients) do
		awful.titlebar.hide(c, misc.position)
	end

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

local function hide(s, t)
	for _, c in ipairs(s.all_clients) do
		-- @FIX if the titlebar is hidden, it will be shown.
		-- the api to check the titlebar state is not exposed
		awful.titlebar.show(c, misc.position)
	end

	if t.prev == nil then
		return
	end

	t.layout = t.prev.layout
	t.gap = t.prev.gap
	t.prev = nil
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

	local function handle_expose()
		if s.overview.visible then
			show(s, s.selected_tag)
		else
			for _,  t in ipairs(s.tags) do
				hide(s, t)
			end
		end
	end

	s.overview:connect_signal("property::visible", handle_expose)
	s:connect_signal("tag::history::update", handle_expose)
	client.connect_signal("request::manage", handle_expose)
end
