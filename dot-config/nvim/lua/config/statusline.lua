-- statusline data functions
-- st_mode/st_mode_hl maps stolen from lualine/utils/mode.lua
St_mode = function()
	return ({
		["n"] = "Normal",
		["no"] = "O-Pending",
		["nov"] = "O-Pending",
		["noV"] = "O-Pending",
		["no\22"] = "O-Pending",
		["niI"] = "Normal",
		["niR"] = "Normal",
		["niV"] = "Normal",
		["nt"] = "Normal",
		["ntT"] = "Normal",
		["v"] = "Visual",
		["vs"] = "Visual",
		["V"] = "V-Line",
		["Vs"] = "V-Line",
		["\22"] = "V-Block",
		["\22s"] = "v-Block",
		["s"] = "Select",
		["S"] = "S-Line",
		["\19"] = "S-Block",
		["i"] = "Insert",
		["ic"] = "Insert",
		["ix"] = "Insert",
		["R"] = "Replace",
		["Rc"] = "Replace",
		["Rx"] = "Replace",
		["Rv"] = "V-Replace",
		["Rvc"] = "V-Replace",
		["Rvx"] = "v-replace",
		["c"] = "Command",
		["cv"] = "Ex",
		["ce"] = "Ex",
		["r"] = "Replace",
		["rm"] = "More",
		["r?"] = "Confirm",
		["!"] = "Shell",
		["t"] = "Terminal",
	})[vim.fn.mode()]
end

St_mode_hl = function()
	local group = ({
		["v"] = "visual",
		["\22"] = "visual",
		["V"] = "visual",
		["s"] = "visual",
		["S"] = "visual",
		["\19"] = "visual",
		["R"] = "replace",
		["Rv"] = "replace",
		["i"] = "insert",
		["c"] = "command",
		["cv"] = "command",
		["rm"] = "command",
		["r?"] = "command",
		["t"] = "terminal",
	})[vim.fn.mode()] or "normal"

	return "%#st_" .. group .. "#"
end

St_lsp = function()
	local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
	local clients = vim.lsp.get_clients()

	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end

	return ""
end

St_filename = function()
	local ok, id = pcall(vim.api.nvim_eval, "b:toggle_number")
	if ok then
		for _, t in pairs(Terminals) do
			if id == t.id then
				return t.display_name .. " Terminal"
			end
		end

		return "Terminal " .. id
	end

	return vim.fn.expand("%:t") .. " %m"
end

-- mode highlighting
-- based off of lualine/utils/utils.lua
local function extract_color(groups)
	local key = "fg"
	for _, group in ipairs(groups) do
		if vim.fn.hlexists(group) == 0 then
			goto continue
		end

		local color = vim.api.nvim_get_hl(0, { name = group, link = false })
		if color[key] ~= nil then
			return color[key]
		end

		::continue::
	end

	return "#000000"
end

local highlights = {
	st_normal = { "Function", "Type", "Special" },
	st_insert = { "String", "Character" },
	st_replace = { "Operator", "Macro" },
	st_visual = { "Identifier", "Statement", "Conditional" },
	st_command = { "Number", "Boolean", "Constant" },
}

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local fg = extract_color({ "Substitute" })
		for name, data in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, {
				bg = extract_color(data),
				fg = fg,
				bold = true,
			})
		end
	end,
})

-- statusline
local l = "%{%v:lua.St_mode_hl()%} %{v:lua.St_mode()} %#Statusline# %{%v:lua.St_filename()%}"
local r = "%{v:lua.St_lsp()} %l:%c "
vim.opt.statusline = l .. "%=" .. r
