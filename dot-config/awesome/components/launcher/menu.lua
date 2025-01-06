local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local misc = require("misc")
local apps = require("misc.apps")
local element = require("components.widgets.element")
local hover = require("components.widgets.hover")

-- https://gist.github.com/Badgerati/3261142
local function levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost

	-- quick cut-offs to save time
	if len1 == 0 then
		return len2
	elseif len2 == 0 then
		return len1
	elseif str1 == str2 then
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
			if str1:byte(i) == str2:byte(j) then
				cost = 0
			else
				cost = 1
			end

			matrix[i][j] = math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
		end
	end

	return matrix[len1][len2]
end

local size = beautiful.spacing_xl * 2
local cols = 12
local rows = 6
local max_matched = rows * cols

local function search(query)
	local matched = {}

	for _, app in pairs(apps.entries) do
		query = query:gsub("%W", "")

		if string.find(app.name:lower(), query:lower(), 1, true) ~= nil then
			table.insert(matched, app)
		end
	end

	table.sort(matched, function(a, b)
		return levenshtein(query, a.name) < levenshtein(query, b.name)
	end)

	return matched
end

local function app_widget(app, focused)
	local widget = {
		{
			{
				{
					image = app.icon,
					resize = true,
					forced_height = size,
					widget = wibox.widget.imagebox,
				},
				widget = wibox.container.place,
			},
			top = beautiful.spacing_m,
			right = beautiful.spacing_m,
			left = beautiful.spacing_m,
			widget = wibox.container.margin,
		},
		{
			markup = focused and misc.wrap_tag("b", app.name) or app.name,
			halign = "center",
			widget = wibox.widget.textbox,
		},
		layout = wibox.layout.fixed.vertical,
		forced_width = size + misc.font_height() * 1.5,
	}

	if focused then
		widget = {
			widget,
			bg = beautiful.primary,
			fg = beautiful.base,
			shape = beautiful.rounded,
			widget = wibox.container.background,
		}
	end

	return wibox.widget(widget)
end

local function gen_widget()
	local search_box = wibox.widget({
		text = "Search: ",
		ellipsize = "start",
		widget = wibox.widget.textbox,
	})

	return {
		wibox.widget({
			{
				{
					{
						{
							{
								element(search_box),
								width = beautiful.spacing_xl * 24,
								height = beautiful.spacing_xl * 4,
								widget = wibox.container.constraint,
							},
							strategy = "min",
							width = beautiful.spacing_xl * 12,
							widget = wibox.container.constraint,
						},
						widget = wibox.container.place,
					},
					{
						column_count = cols,
						row_count = rows,
						spacing = beautiful.spacing_m,
						layout = wibox.layout.grid.vertical,
						id = "entries",
					},
					spacing = beautiful.spacing_m,
					layout = wibox.layout.fixed.vertical,
				},
				margins = beautiful.spacing_m,
				widget = wibox.container.margin,
			},
			shape = beautiful.rounded,
			bg = beautiful.surface,
			widget = wibox.container.background,
		}),
		search_box = search_box,
	}
end

local function init()
	local model = {}
	local widgets = gen_widget()
	local entries = misc.children("entries", widgets[1])

	return model,
		widgets,
		function()
			local results = search(model.query or "")
			local empty = #results == 0

			if empty then
				-- empty entry so theres no weird ui shift with when nothing matched
				table.insert(results, {
					icon = gears.surface.load_from_shape(size, size, gears.shape.rounded_rect, "#00000000"),
					name = " ",
				})

				model.current = nil
			else
				model.current = results[1]
			end

			entries:reset()
			for i, app in ipairs(results) do
				if i > max_matched then
					break
				end

				local w = app_widget(app, i == 1 and not empty)
				if not empty then
					hover(w)
					w:add_button(awful.button({}, 1, nil, function()
						if model.current then
							model.current.launch()
						end
					end))
				end
				entries:add(w)
			end
		end
end

return function(s)
	local model, widgets, view = init()

	local function run_search()
		model.query = ""
		view()

		local original_text = widgets.search_box.text
		awful.prompt.run({
			prompt = original_text,
			textbox = widgets.search_box,
			changed_callback = function(query)
				model.query = query
				view()
			end,
			exe_callback = function()
				if model.current then
					model.current.launch()
				end
			end,
			done_callback = function()
				widgets.search_box.text = original_text
				s.launcher.visible = false
			end,
		})
	end

	return widgets[1], run_search
end
