return {
	"tpope/vim-surround",
	{
		"gbprod/cutlass.nvim",
		opts = { cut_key = "m" },
	},
	{
		"jinh0/eyeliner.nvim",
		opts = {
			dim = true,
			highlight_on_key = true,
		},
	},
	{
		"MagicDuck/grug-far.nvim",
		opts = {
			debounceMs = 100,
			replacementInterpreter = "lua",
			windowCreationCommand = "botright split",
			transient = true,
			resultLocation = {
				showNumberLabel = false,
			},
		},
	},
}
