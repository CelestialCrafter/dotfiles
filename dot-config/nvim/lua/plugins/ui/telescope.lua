local utils = require("utils")

local function vcs_picker(opts)
	local builtin = require("telescope.builtin")
	local jj = require("telescope").extensions.jj

	local jj_ok, _ = pcall(jj.files, opts)
	if jj_ok then
		return
	end

	local git_ok, _ = pcall(builtin.git_files, opts)
	if git_ok then
		return
	end

	builtin.find_files(opts)
end

local function key(lhs_suffix, picker, opts)
	return {
		"<leader>" .. lhs_suffix,
		function()
			picker(opts)
		end,
		mode = utils.default_mode,
	}
end

local open_with_trouble = function(...)
	require("trouble.sources.telescope").open(...)
end

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = function()
			local builtin = require("telescope.builtin")

			return {
				key("ff", builtin.find_files, { no_ignore = true, hidden = true }),
				key("fg", builtin.live_grep),
				key("fr", builtin.lsp_references),
				key("fd", builtin.lsp_definitions),
				key("fs", builtin.lsp_document_symbols),
				key("fD", builtin.diagnostics, { bufnr = 0 }),
			}
		end,
		opts = {
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<C-t>"] = open_with_trouble,
					},
					n = { ["<C-t>"] = open_with_trouble },
				},
				layout_config = {
					height = 0.7,
					flex = { flip_columns = 120 },
					horizontal = { preview_width = 0.45 },
				},
			},
			pickers = {
				buffers = {
					mappings = {
						i = {
							["<C-d>"] = "delete_buffer",
						},
					},
				},
			},
		},
	},
	{
		"zschreur/telescope-jj.nvim",
		config = function()
			require("telescope").load_extension("jj")
		end,
		keys = function()
			local jj = require("telescope").extensions.jj

			return {
				key("<leader>", vcs_picker),
				key("fc", jj.conflicts),
			}
		end,
	},
}