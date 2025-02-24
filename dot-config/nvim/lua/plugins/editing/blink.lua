return {
	"saghen/blink.cmp",
	version = "v0.*",
	opts = {
		keymap = {
			preset = "super-tab",
			["<Up>"] = {},
			["<Down>"] = {},
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
		},
		signature = { enabled = true },
		completion = {
			ghost_text = { enabled = true },
			documentation = { auto_show = true, auto_show_delay_ms = 0 },
		},
	},
}
