local utils = require("utils")

return {
	"CelestialCrafter/nap.nvim",
	lazy = false,
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"RRethy/vim-illuminate",
		"folke/trouble.nvim",
	},
	keys = function()
		local nap = require("nap")
		local function rep(dir)
			return function()
				for _ = 1, math.max(1, vim.api.nvim_eval("v:count")) do
					nap["repeat_" .. dir]()
				end
			end
		end

		return {
			{ "<C-j>", rep("next"), mode = utils.default_mode },
			{ "<C-k>", rep("prev"), mode = utils.default_mode },
		}
	end,
	config = function(_, opts)
		local nap = require("nap")
		nap.setup(opts)

		nap.map("g", nap.gitsigns())
		nap.map("i", nap.illuminate())
		nap.map("t", nap.trouble())
		nap.map("u", nap.undo())
	end,
}
