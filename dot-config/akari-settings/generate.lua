local user = require("user")
local utils = require("utils")

local function resolve(data, processor)
	processor = processor or function(value)
		return value
	end

	local replacements = {}
	local function traverse(trail, tab)
		for key, value in pairs(tab) do
			local iter_trail = table.pack(table.unpack(trail))
			table.insert(iter_trail, key)

			if type(value) == "table" then
				traverse(iter_trail, value)
			else
				replacements["%" .. table.concat(iter_trail, ".") .. "%"] = processor(value)
			end
		end
	end

	traverse({}, user)

	return data:gsub("%%[%._%a]+%%", replacements)
end

local templates = utils.listdir("templates")
for _, path in ipairs(templates) do
	local template = dofile(path)
	template.install(resolve(template.data, template.processor))
	print("installed " .. path)
end
