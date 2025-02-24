return {
	{ "wakatime/vim-wakatime", event = "VeryLazy" },
	{
		"zeioth/garbage-day.nvim",
		dependencies = "neovim/nvim-lspconfig",
		event = "VeryLazy",
		-- 10 minutes
		opts = { grace_period = 10 * 60 },
	},
}
