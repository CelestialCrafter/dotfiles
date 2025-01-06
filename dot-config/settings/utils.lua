local M = {}

-- @HACK please dont use weird characters in your filename :3
function M.listdir(directory)
	local files = {}

	-- this is recursive
	local handle = assert(io.popen(("find '%s' -type f,l -print0"):format(directory)))
	for path in handle:read("*a"):gmatch("[^\0]+") do
		table.insert(files, path)
	end
	handle:close()

	return files
end

return M
