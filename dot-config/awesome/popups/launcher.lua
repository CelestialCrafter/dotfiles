local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local lgi = require("lgi")
local gio = lgi.Gio
local gtk = lgi.require("Gtk", "3.0")
local user = require("user")

local size = beautiful.spacing_xl * 1.5

local entries = {}
local current = nil

local function generate_widget(entry)
	local image = {
		{
		image = entry.icon,
		resize = true,
		forced_height = size,
		forced_width = size,
		widget = wibox.widget.imagebox
		},
		margins = beautiful.spacing_s,
		widget = wibox.container.margin
	}

	local widget = {
		image,
		{
			text = entry.name,
			halign = "center",
			valign = "center",
			widget = wibox.widget.textbox
		},
		spacing = beautiful.spacing_s,
		layout = wibox.layout.fixed.horizontal
	}

	if entry.focused then
		widget = {
			widget,
			bg = beautiful.accent,
			shape = beautiful.rounded,
			widget = wibox.container.background
		}
	end

	return wibox.widget(widget)
end

-- https://gist.github.com/Badgerati/3261142
local function levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost

        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end

        -- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end

        -- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (str1:byte(i) == str2:byte(j)) then
				cost = 0
			else
				cost = 1
			end

			matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
		end
	end

	return matrix[len1][len2]
end
local function handle_search(query)
	local matched = {}

        for _, entry in pairs(entries) do
            query = query:gsub("%W", "")

            if string.find(entry.name:lower(), query:lower(), 1, true) ~= nil then
                table.insert(matched, entry)
            end
        end

	table.sort(matched, function (a, b)
		return levenshtein(query, a.name) < levenshtein(query, b.name)
	end)

	current = matched[1]
	if current ~= nil then
		current.focused = true
	end

	local widgets = {}
	for i, entry in ipairs(matched) do
		if i > user.max_launcher_entries then
			break
		end

		table.insert(widgets, generate_widget(entry))
		entry.focused = false
	end

	return widgets
end

local function icon_path(gicon, gtk_theme)
	if gicon == nil then
		return ""
	end

	local info = gtk_theme:lookup_by_gicon(gicon, size, 0)
	if info then
		local path = info:get_filename()
		if path then
			return path
		end
	end

	return ""
end

local function generate_entries()
	local info = gio.AppInfo
	local apps = info.get_all()
	local gtk_theme = gtk.IconTheme.get_default()

	for _, app in ipairs(apps) do
		if not app.should_show(app) then
			goto continue
		end

		table.insert(entries, {
			name = info.get_name(app),
			launch = function() info.launch(app) end,
			icon = icon_path(info.get_icon(app), gtk_theme),
		})

		::continue::
	end
end

return function()
	generate_entries()

	local widget = wibox.widget {
		{
			{
				{
					{
						markup = "Search: ",
						id = "search",
						widget = wibox.widget.textbox
					},
					margins = beautiful.spacing_m,
					widget = wibox.container.margin
				},
				bg = beautiful.overlay,
				shape = beautiful.rounded,
				widget = wibox.container.background
			},
			{
				forced_width = beautiful.spacing_xl * 8,
				spacing = beautiful.spacing_s,
				layout = wibox.layout.fixed.vertical,
				id = "entries",
			},
			fill_space = true,
			spacing = beautiful.spacing_m,
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.margin,
		margins = beautiful.spacing_m
	}

	local launcher = awful.popup {
		widget = widget,
		bg = beautiful.surface,
		shape = beautiful.rounded,
		placement = function(d) awful.placement.top_left(d, {
			margins = beautiful.useless_gap * 2,
			honor_workarea = true
		}) end,
		ontop = true,
		visible = false
	}

	local search = widget:get_children_by_id("search")[1]
	local function set_entries(query)
		widget:get_children_by_id("entries")[1]:set_children(handle_search(query))
	end

	launcher:connect_signal("property::visible", function()
		if not launcher.visible then
			launcher.placement = nil
			return
		end

		set_entries("")

		local current_text = search.markup
		awful.prompt.run {
			prompt = current_text,
			textbox = search,
			changed_callback = set_entries,
			exe_callback = function()
				if current ~= nil then
					current.launch()
				end
			end,
			done_callback = function()
				search.markup = current_text
				launcher.visible = false
			end
		}
	end)

	return launcher
end

