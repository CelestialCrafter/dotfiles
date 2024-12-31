local M = {}

M.data = function() end

function M.install(resolved)
	local file = assert(io.open(os.getenv("HOME") .. "/.config/alacritty/color.toml", "w"))
	file:write(resolved)
	file:close()
end

return M
