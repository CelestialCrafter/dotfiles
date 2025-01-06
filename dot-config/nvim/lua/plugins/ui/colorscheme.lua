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
		local ok, settings = pcall(dofile, os.getenv("HOME") .. "/.config/settings/user.lua")
		if ok then
			opts["palette"] = {
				main = {
					base = settings.colors.base,
					surface = settings.colors.surface,
					overlay = settings.colors.overlay,
					muted = settings.colors.subtle,
					subtle = settings.colors.text_subtle,
					text = settings.colors.text,
					highlight_med = settings.colors.overlay,
				},
			}
		end

		require("rose-pine").setup(opts)
		vim.cmd("colorscheme rose-pine")
	end,
}
