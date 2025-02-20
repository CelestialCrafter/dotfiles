return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000,
	lazy = false,
	opts = {
		highlight_groups = {
			BlinkCmpLabel = { fg = "text" },
			BlinkCmpLabelMatch = { fg = "rose" },
			TroubleNormal = { bg = "base" },
			TroubleNormalNC = { bg = "base" },
			TelescopeNormal = { bg = "base" },
			TelescopeBorder = { bg = "base" },
			StatusLine = { bg = "base" },
		},
	},
	config = function(_, opts)
		require("rose-pine").setup(opts)
		vim.cmd("colorscheme rose-pine-dawn")
	end,
}
