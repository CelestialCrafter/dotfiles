return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
			rust = { "rustfmt" },
			javascript = { "prettierd" },
			go = { "goimports", "gofmt" },
			css = { "stylelint" },
			nix = { "nixfmt" },
			gleam = { "gleam" },
			zig = { "zigfmt" },
		},
	},
}
