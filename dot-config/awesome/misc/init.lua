local gears = require("gears")
local apps = require("misc.apps")

local M = {
	preview_update_interval = 0.5,
	general_update_interval = 0.1,
}

function M.setup()
	apps.setup()
	require("misc.autostart")
end

function M.truncate(text, chars)
	chars = chars or 32

	if #text <= chars then
		return text
	end

	return text:sub(1, chars - 3):gsub("%s$", "") .. "..."
end

function M.wrap_tag(text, tag, args)
	args = args or {}
	if #args > 0 then
		table.insert(args, "")
	end

	return ("<%s%s>%s</%s>"):format(tag, table.concat(args, " "), gears.string.xml_escape(text), tag)
end

function M.debug(data, depth)
	require("naughty").notify({ text = gears.debug.dump_return(data, depth or 3) })
end

function M.children(ids, widget)
	local single = false
	if type(ids) == "string" then
		single = true
		ids = { ids }
	end

	local widgets = {}

	for _, id in ipairs(ids) do
		widgets[id] = widget:get_children_by_id(id)[1]
	end

	return single and widgets[ids[1]] or widgets
end

return M
