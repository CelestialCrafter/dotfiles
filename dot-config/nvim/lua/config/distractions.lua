vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
	callback = function(ev)
		local gok, gitsigns = pcall(require, "gitsigns")
		if not gok then
			gitsigns = { toggle_signs = function(_) end }
		end

		if ev.event == "InsertEnter" then
			vim.diagnostic.disable()
			gitsigns.toggle_signs(false)
		else
			vim.diagnostic.enable()
			gitsigns.toggle_signs(true)
		end
	end,
})
