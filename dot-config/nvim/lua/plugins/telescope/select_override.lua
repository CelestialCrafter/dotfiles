local function default_kind(items, opts, on_choice)
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	return {
		prompt_title = opts.prompt,
		sorter = conf.generic_sorter(opts),
		finder = finders.new_table({
			results = items,
			entry_maker = function(item)
				local formatted = opts.format_item(item)
				return {
					display = formatted,
					ordinal = formatted,
					value = item,
				}
			end,
		}),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)

				local selection = action_state.get_selected_entry()
				if selection then
					on_choice(selection.value, selection.index)
				else
					on_choice(nil, nil)
				end
			end)

			actions.close:enhance({
				post = function()
					on_choice(nil, nil)
				end,
			})

			return true
		end,
	}
end

local function codeaction_kind(items, opts, on_choice)
	local entry_display = require("telescope.pickers.entry_display")
	local finders = require("telescope.finders")
	local displayer

	local function make_display(entry)
		local columns = {
			{ entry.idx .. ":", "TelescopePromptPrefix" },
			entry.text,
			{ entry.client_name, "Comment" },
		}

		return displayer(columns)
	end

	local entries = {}
	local client_width = 1
	local text_width = 1
	local idx_width = 1
	for idx, item in ipairs(items) do
		local client_name = vim.lsp.get_client_by_id(item.ctx.client_id).name
		local text = opts.format_item(item)

		client_width = math.max(client_width, vim.api.nvim_strwidth(client_name))
		text_width = math.max(text_width, vim.api.nvim_strwidth(text))
		idx_width = math.max(idx_width, vim.api.nvim_strwidth(tostring(idx)))

		table.insert(entries, {
			idx = idx,
			display = make_display,
			text = text,
			client_name = client_name,
			ordinal = idx .. " " .. text .. " " .. client_name,
			value = item,
		})
	end

	displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = idx_width + 1 },
			{ width = text_width },
			{ width = client_width },
		},
	})

	local default = default_kind(items, opts, on_choice)
	default.finder = finders.new_table({
		results = entries,
		entry_maker = function(item)
			return item
		end,
	})

	return default
end

return function()
	local pickers = require("telescope.pickers")
	vim.ui.select = function(items, opts, on_choice)
		opts = opts or {}
		on_choice = vim.schedule_wrap(on_choice)

		opts.prompt = opts.prompt or "Select one of"
		if opts.prompt:sub(-1, -1) == ":" then
			opts.prompt = opts.prompt:sub(1, -2)
		end

		opts.format_item = opts.format_item or tostring

		local picker_config_fn = (opts.kind == "codeaction" and codeaction_kind or default_kind)
		pickers.new(opts, picker_config_fn(items, opts, on_choice)):find()
	end
end


