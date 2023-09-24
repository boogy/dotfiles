-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")

require("telescope").setup({
	defaults = {
		mappings = {
			n = {
				["<C-i>"] = action_layout.toggle_preview,
			},
			i = {
				["<C-u>"] = false,
				["<C-d>"] = actions.delete_buffer + actions.move_to_top, -- ['<C-d>'] = false
				["<esc>"] = actions.close,
				["<C-i>"] = action_layout.toggle_preview,
			},
		},
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--trim", -- add this value
		},
	},
	pickers = {
		find_files = {
			find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
			-- find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
			-- layout_strategy='vertical',
			layout_config = { width = 0.8 },
		},
	},
	file_ignore_patterns = { "node%_modules/.*" },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
require("telescope").load_extension("file_browser")
