return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000,
	lazy = false,
	opts = {
		highlight_groups = {
			BlinkCmpSignatureHelp = { bg = "overlay" },
			BlinkCmpLabel = { fg = "text" },
			BlinkCmpMenuSelection = { fg = "rose", bg = "overlay" },
			BlinkCmpLabelMatch = { fg = "rose" },
			TroubleNormal = { bg = "base" },
			TroubleNormalNC = { bg = "base" },
			TelescopeNormal = { bg = "base" },
			TelescopeBorder = { bg = "base" },
			StatusLine = { bg = "surface" },
		},
	},
	config = function(_, opts)
		require("rose-pine").setup(opts)
		vim.cmd("colorscheme rose-pine-dawn")
	end,
}
