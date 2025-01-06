local gears = require("gears")
local lgi = require("lgi")

local gio = lgi.Gio
local gtk = lgi.require("Gtk", "3.0")

local M = gears.object({})
M.entries = {}
M.class_to_id = {}
M.pending = nil

function M.notify(class)
	if not class then
		return
	end

	local id = M.class_to_id[class]
	if id then
		return M.entries[id]
	end

	if not M.pending then
		return
	end

	id = M.pending
	M.class_to_id[class] = id
	M.pending = nil

	return M.entries[id]
end

local gtk_theme = gtk.IconTheme.get_default()
local function icon_path(icon)
	local info = gtk_theme:lookup_by_gicon(icon, 64, 0)
	return info and info:get_filename()
end

function M.parse_appinfo(app)
	local icon = app:get_icon()
	if icon then
		icon = gears.surface(icon_path(icon))
	end

	local id = app:get_id()
	-- the == true is required, dont know why
	local terminal = app:get_string("Terminal") == true

	return {
		id = id,
		name = app:get_name(),
		temrinal = terminal,
		launch = function()
			app:launch()
			if not terminal then
				M.pending = id
			end
		end,
		icon = icon,
	}
end

function M.setup()
	local info = gio.AppInfo
	for _, appinfo in ipairs(info.get_all()) do
		if not appinfo:should_show() then
			goto continue
		end

		local app = M.parse_appinfo(appinfo)
		M.entries[app.id] = app

		::continue::
	end
end

return M
