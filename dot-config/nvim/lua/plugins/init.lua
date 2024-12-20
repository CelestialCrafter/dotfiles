local utils = require("utils")

return {
	{ "wakatime/vim-wakatime", event = "VeryLazy" },
	{
		"zeioth/garbage-day.nvim",
		dependencies = "neovim/nvim-lspconfig",
		event = "VeryLazy",
		-- 10 minutes
		opts = { grace_period = 10 * 60 },
	},
	{
		"CelestialCrafter/persistence.nvim",
		event = "BufReadPre",
		opts = {
			name = function()
				local root, fallback = utils.get_root()
				if fallback then
					return nil
				end

				return root:gsub("[\\/:]+", "%%")
			end,
		},
	},
}
