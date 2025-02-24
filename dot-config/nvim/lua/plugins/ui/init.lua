local utils = require("utils")

return {
	{
		"j-hui/fidget.nvim",
		opts = {
			progress = { suppress_on_insert = true },
			notification = { override_vim_notify = true },
		},
	},
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
		opts = {
			delay = 50,
			should_enable = function(bufnr)
				return not utils.large_file(bufnr, 500)
			end,
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},
}
