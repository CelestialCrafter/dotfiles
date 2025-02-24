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
