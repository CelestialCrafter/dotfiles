local utils = require("utils")

local function select()
	local list = require("harpoon"):list()

	vim.ui.select(list:display(), {
		prompt = "Buffers",
	}, function(_, i)
		list:select(i)
	end)
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		default = {
			encode = false,
			display = function(item)
				return vim.fs.basename(item.value)
			end,
		},
	},
	keys = function()
		local harpoon = require("harpoon")

		local keymap = {
			{
				"<leader>fb",
				select,
				mode = utils.default_mode,
			},
			{
				"<leader>b",
				function()
					harpoon:list():add()
				end,
				mode = utils.default_mode
			},
			{
				"<C-S-j>",
				function()
					harpoon:list():next()
				end,
				mode = utils.default_mode
			},
			{
				"<C-S-k>",
				function()
					harpoon:list():prev()
				end,
				mode = utils.default_mode
			},
		}

		for i = 1, 9 do
			table.insert({
				string.format("<C-%d>", i),
				function()
					harpoon:list():select(i)
				end,
				mode = utils.default_mode,
			}, keymap)
		end

		return keymap
	end,
}
