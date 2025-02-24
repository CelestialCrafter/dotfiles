local utils = require("utils")

local k = vim.keymap
local m = utils.default_mode

-- system clipboard register
k.set(m, "<leader>m", '"+m')
k.set(m, "<leader>M", '"+M')
k.set(m, "<leader>y", '"+y')
k.set(m, "<leader>Y", '"+y$')
k.set(m, "<leader>P", '"+P')
k.set(m, "<leader>p", '"+p')

-- quickfix
k.set(m, "<C-j>", vim.cmd.cnext)
k.set(m, "<C-k>", vim.cmd.cprev)
k.set(m, "<leader>c", function()
	for _, win in ipairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			vim.cmd.cclose()
			return
		end
	end

	vim.cmd.copen()
end, { desc = "toggle quickfix" })

-- lsp
k.set(m, "<leader><cr>", vim.lsp.buf.code_action)
k.set(m, "<leader>r", vim.lsp.buf.rename)

-- misc
k.set(m, "<Esc>",  "<cmd>nohlsearch<cr><Esc>", { desc = "turn off search highlight" })
k.set(m, "q:", "<Nop>", { desc = "unbind command line window" })
k.set(m, "=", function() require("conform").format() end, { desc = "format buffer" })
