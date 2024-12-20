local utils = require("utils")

local k = vim.keymap
local m = utils.default_mode

-- system clipboard register
k.set(m, "<leader>y", '"+y')
k.set(m, "<leader>Y", '"+y$')
k.set(m, "<leader>p", '"+p')

-- lsp
k.set(m, "<leader><cr>", vim.lsp.buf.code_action)
k.set(m, "<leader>r", vim.lsp.buf.rename)

-- misc
k.set(m, "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "turn off search highlight" })
k.set("t", "<Esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })
k.set(m, "q:", "<Nop>", { desc = "unbind command line window" })
k.set(m, "=", require("conform").format, { desc = "format buffer" })
