local utils = require("utils")

utils.bootstrap(vim.fn.stdpath("data") .. "/lazy/lazy.nvim", "https://github.com/folke/lazy.nvim", "stable")

local ok, lazy = pcall(require, "lazy")
if ok then
	lazy.setup({
		spec = {
			{ import = "plugins" },
			{ import = "plugins.editing" },
			{ import = "plugins.ui" },
		},
		checker = { enabled = true },
		change_detection = { notify = false },
	})
end
