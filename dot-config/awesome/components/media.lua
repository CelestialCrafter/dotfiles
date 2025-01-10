local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local progress = require("components.widgets.progress")

local mpris = require("core.mpris")
local misc = require("misc")
local hover = require("components.widgets.hover")
local element = require("components.widgets.element")
local button = require("components.widgets.button")

local function hex(str)
	return (str:gsub(".", function(c)
		return string.format("%02x", string.byte(c))
	end))
end

local function file_exists(name)
	local f = io.open(name, "r")
	return f ~= nil and io.close(f)
end

local function gen_widget()
	local height = beautiful.spacing_xl * 5
	local width = height * 2

	local function tb(id, text)
		return {
			text = text,
			halign = "center",
			widget = wibox.widget.textbox,
			id = id,
		}
	end

	local function sid(id, w)
		return gears.table.crush(w, { id = id })
	end

	local info = {
		tb("title"),
		{
			{
				tb("artist"),
				tb("album"),
				layout = wibox.layout.fixed.vertical,
			},
			fg = beautiful.text_subtle,
			widget = wibox.container.background,
			id = "bg",
		},
		layout = wibox.layout.fixed.vertical,
		forced_width = width,
	}

	local controls = {
		{
			{
				button.array({
					sid("prev", button(tb(nil, "<"), beautiful.primary)),
					sid("play_pause", button(tb("play_pause_text"), beautiful.secondary)),
					sid("next", button(tb(nil, ">"), beautiful.accent)),
				}),
				element({
					widget = wibox.widget.textbox,
					id = "position",
				}),
				spacing = beautiful.spacing_m,
				layout = wibox.layout.fixed.horizontal,
			},
			widget = wibox.container.place,
		},
		gears.table.crush(progress(0), { id = "progress" }),
		spacing = beautiful.spacing_m,
		layout = wibox.layout.fixed.vertical,
	}

	return wibox.widget({
		{
			resize = true,
			forced_height = height,
			forced_width = height,
			widget = wibox.widget.imagebox,
			id = "art",
		},
		{
			{
				info,
				nil,
				controls,
				layout = wibox.layout.align.vertical,
			},
			margins = beautiful.spacing_m,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.horizontal,
	})
end

local function format_sec(s)
	s = math.floor(s)
	return { m = math.floor(s / 60), s = s % 60 }
end

local function init()
	local model = {
		position = { length = 0, current = 0 },
	}

	local widget = gen_widget()
	local children = misc.children({
		"art",
		"title",
		"artist",
		"album",

		"progress",
		"position",

		"prev",
		"next",
		"play_pause",
		"play_pause_text",
	}, widget)

	children.play_pause:add_button(awful.button({}, 1, nil, mpris.play_pause))
	children.next:add_button(awful.button({}, 1, nil, mpris.next))
	children.prev:add_button(awful.button({}, 1, nil, mpris.prev))

	progress.connect(children.progress, function(_, p)
		mpris.seek(p)
	end)

	hover(children.play_pause, hover.bg())
	hover(children.next, hover.bg())
	hover(children.prev, hover.bg())

	return model,
		widget,
		function()
			local l = format_sec(model.position.length or 0)
			local c = format_sec(model.position.current or 0)

			children.art.image = model.art
			children.title.markup = misc.wrap_tag(misc.truncate(model.title or "No Title"), "big")
			children.artist.text = misc.truncate(model.artist or "No Artist")
			children.album.text = misc.truncate(model.album or "", 42)
			children.position.text = ("%02d:%02d/%02d:%02d"):format(table.unpack({ c.m, c.s, l.m, l.s }))
			children.progress.value = model.progress or 0
			children.play_pause_text.text = model.playing and "+" or "-"
		end
end

return function(s)
	local model, widget, view = init()

	local cache_path = gears.filesystem.get_cache_dir() .. "media-art/"
	gears.filesystem.make_directories(cache_path)

	local function handle_metadata(_, metadata)
		if not metadata then
			model.art = nil
			model.title = nil
			model.artist = nil
			model.album = nil
			model.position.length = nil
			view()
			return
		end

		if metadata.art then
			local path, count = metadata.art:gsub("^file://", "")
			if count == 0 then
				path = cache_path .. hex(path)
			end

			local function set()
				model.art = gears.surface.load(path)
				collectgarbage("collect")
			end

			if not file_exists(path) then
				local cmd = string.format("curl -L -s %s -o %s", metadata.art, path)
				awful.spawn.with_line_callback(cmd, {
					exit = function()
						set()
						view()
					end,
				})
			else
				set()
			end
		end

		model.title = metadata.title
		model.artist = table.concat(metadata.artists, ", ")
		model.album = metadata.album ~= "" and metadata.album
		model.position.length = metadata.length
		view()
	end

	local function handle_position(_, pos)
		if pos then
			model.position.current = pos
			model.progress = 1 / (model.position.length / pos)
		else
			model.position.current = nil
			model.progress = nil
		end

		view()
	end

	local function handle_playing(_, playing)
		model.playing = playing
		view()
	end

	mpris:connect_signal("metadata", handle_metadata)
	mpris:connect_signal("position", handle_position)
	mpris:connect_signal("playing", handle_playing)
	handle_metadata(mpris:metadata())
	handle_position(mpris:position())
	handle_playing(mpris:playing())

	return awful.popup({
		widget = widget,
		ontop = true,
		placement = function(d)
			awful.placement.top_right(d, {
				margins = beautiful.useless_gap * 2,
				honor_workarea = true,
			})
		end,
		shape = beautiful.rounded,
		visible = false,
	})
end
