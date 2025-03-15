local utils = require("utils")
local k = vim.keymap
local m = utils.default_mode

local function wrap(next, prev)
	return function()
		local _, ok = pcall(next)
		if not ok then
			pcall(prev)
		end
	end
end

k.set(m, "<C-j>", wrap(vim.cmd.cnext, vim.cmd.cprev))
k.set(m, "<C-k>", wrap(vim.cmd.cprev, vim.cmd.cnext))
k.set(m, "<leader>c", function()
	for _, win in ipairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			vim.cmd.cclose()
			return
		end
	end

	vim.cmd.copen()
end, { desc = "toggle quickfix" })

local pre_qf
vim.api.nvim_create_autocmd({ "QuickFixCmdPre", "QuickFixCmdPost", "BufEnter" }, {
	pattern = "*",
	callback = function(ev)
		local map = {
			QuickFixCmdPre = function()
				pre_qf = vim.fn.bufwinnr(0)
			end,
			QuickFixCmdPost = function()
				vim.cmd("botright copen 8")
				vim.schedule(function()
					vim.cmd(pre_qf .. "wincmd w")
				end)
			end,

			-- quit if no other files open
			BufEnter = function()
				local persistent_windows = vim.tbl_filter(function(win)
					return vim.bo[win.bufnr].bufhidden ~= "wipe"
				end, vim.fn.getwininfo())

				local last = #persistent_windows < 2
				local qf = vim.bo.buftype == "quickfix"
				if qf and last then
					vim.cmd("quit!")
				end
			end,
		}

		map[ev.event]()
	end,
})
