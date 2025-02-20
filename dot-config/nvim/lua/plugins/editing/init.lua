return {
	"tpope/vim-surround",
	"tpope/vim-sleuth",
	"wellle/targets.vim",
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
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
