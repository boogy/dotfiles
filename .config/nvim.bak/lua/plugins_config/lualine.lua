-- Set lualine as statusline
-- See `:help lualine.txt`
local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

-- shift lualine when nvim-tree is open
-- local nvim_tree_shift = {
--   function()
--     local len = vim.api.nvim_win_get_width(require('nvim-tree.view').get_winnr()) - 2
--     local title = "Nvim-Tree"
--     local left = (len - #title) / 2
--     local right = len - left - #title
--
--     return string.rep(' ', left) .. title .. string.rep(' ', right)
--   end,
--   cond = require('nvim-tree.view').is_visible,
--   color = 'Normal'
-- }

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "gruvbox",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "TelescopePrompt", "packer", "toggleterm", "statusline", "winbar", "NvimTree" },
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = {
			-- nvim_tree_shift,
			{ "mode", icons_enabled = true },
		},
		lualine_b = {
			"branch",
			{
				"diff",
				colored = true,
				diff_color = {
					added = "DiffAdd",
					modified = "DiffChange",
					removed = "DiffDelete",
				},
				symbols = { added = "+", modified = "~", removed = "-" },
			},
			"diagnostics",
			-- {
			--   'buffers',
			--   show_modified_status = true,
			--   hide_filename_extension = false,
			--   mode = 2,
			--   symbols = {
			--     modified = ' ●',    -- Text to show when the buffer is modified
			--     alternate_file = '#', -- Text to show to identify the alternate file
			--     directory = '',    -- Text to show when the buffer is a directory
			--   },
			-- }
		},
		lualine_c = {}, -- filename
		lualine_x = { "encoding", "fileformat", "filetype", "searchcount" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = {
			-- nvim_tree_shift,
			{
				"buffers",
				show_modified_status = true,
				hide_filename_extension = false,
				mode = 2,
				symbols = {
					modified = " ●", -- Text to show when the buffer is modified
					alternate_file = "#", -- Text to show to identify the alternate file
					directory = "", -- Text to show when the buffer is a directory
				},
			},
		},
		lualine_b = { --[[ {"tabs", mode = 2} ]]
		},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	winbar = {},
	inactive_winbar = {},
	extensions = { "quickfix", "fugitive", "toggleterm" },
})
