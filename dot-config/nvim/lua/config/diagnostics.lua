-- partially stolen from vim.diagnostic

local severity = vim.diagnostic.severity
local highlight_map = {}
for i, v in pairs({ severity.ERROR, severity.WARN, severity.INFO, severity.HINT }) do
	local name = severity[i]
	name = name:sub(1, 1) .. name:sub(2):lower()
	highlight_map[v] = "DiagnosticFloating" .. name
end

local function close(winnr)
	if winnr then
		pcall(vim.api.nvim_win_close, winnr, true)
	end
end

local function render_float(namespace, diagnostics)
	local ns = vim.diagnostic.get_namespace(namespace)
	local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

	-- filter
	diagnostics = vim.tbl_filter(function(d)
		return lnum >= d.lnum and lnum <= d.end_lnum and (d.lnum == d.end_lnum or lnum ~= d.end_lnum or d.end_col ~= 0)
	end, diagnostics)

	if #diagnostics < 1 then
		close(ns.user_data.cd_winnr)
		return
	end

	-- transform
	local prefix = function(i)
		return string.format("(%d) ", i)
	end

	local lines = {}
	local highlights = {}
	for i, diagnostic in ipairs(diagnostics) do
		local p = prefix(i)
		for _, line in ipairs(vim.split(diagnostic.message, "\n")) do
			table.insert(lines, p .. line)
			table.insert(highlights, highlight_map[assert(diagnostic.severity)])
		end
	end

	-- render
	local float_bufnr, winnr = vim.lsp.util.open_floating_preview(lines, "plaintext", {
		relative = "editor",
		offset_x = vim.o.columns - vim.fn.wincol(),
		offset_y = -vim.fn.winline(),
		max_width = math.max(math.floor(vim.o.columns / 4), 42),

		focusable = false,
		close_events = {},
	})
	ns.user_data.cd_winnr = winnr

	for i, line in ipairs(lines) do
		line = #line
		local p = #prefix(i)
		local hl = highlights[i]

		i = i - 1
		vim.highlight.range(float_bufnr, namespace, hl, { i, p }, { i, line })
		vim.highlight.range(float_bufnr, namespace, "DiagnosticUnnecessary", { i, 0 }, { i, p })
	end
end

vim.diagnostic.handlers["celestial/diagnostics"] = {
	show = function(namespace, bufnr, diagnostics, _)
		local ns = vim.diagnostic.get_namespace(namespace)

		if not ns.user_data.cd_augroup then
			ns.user_data.cd_augroup = vim.api.nvim_create_augroup("celestial/diagnostics/" .. ns.name, { clear = true })
		end
		vim.api.nvim_clear_autocmds({ group = ns.user_data.cd_augroup, buffer = bufnr })

		local function render()
			render_float(namespace, diagnostics)
		end

		render()
		vim.api.nvim_create_autocmd({ "CursorMoved", "VimResized" }, {
			buffer = bufnr,
			group = ns.user_data.cd_augroup,
			callback = render,
		})
	end,
	hide = function(namespace, bufnr)
		local ns = vim.diagnostic.get_namespace(namespace)

		if ns.user_data.cd_augroup then
			vim.api.nvim_clear_autocmds({ group = ns.user_data.cd_augroup, buffer = bufnr })
		end

		close(ns.user_data.cd_winnr)
	end,
}

vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	signs = {
		text = {
			[severity.ERROR] = "┨ ",
			[severity.WARN] = "┨ ",
			[severity.INFO] = "┨ ",
			[severity.HINT] = "┨ ",
		},
	},
})

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.diagnostic.enable()
	end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.diagnostic.enable(false)
	end,
})
