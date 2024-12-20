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
		palette = function()
			local path = os.getenv("HOME") .. "/.config/awesome/user.lua"
			local ok, user = pcall(dofile, path)
			if not ok then
				return
			end

			return {
				main = {
					base = user.base,
					surface = user.surface,
					overlay = user.overlay,
					muted = user.subtle,
					subtle = user.text_subtle,
					text = user.text,
					highlight_med = user.overlay,
				},
			}
		end,
	},
	config = function(_, opts)
		if type(opts.palette) == "function" then
			opts.palette = opts.palette()
		end
		require("rose-pine").setup(opts)
		vim.cmd("colorscheme rose-pine")
	end,
}
