-- Enable `lukas-reineke/indent-blankline.nvim`

local status_ok, indent_blankline = pcall(require, 'indent_blankline')
if not status_ok then
  return
end

indent_blankline.setup {
	char = '┊',
	space_char_blankline = " ",
	show_trailing_blankline_indent = false,
	show_current_context = true,
	show_current_context_start = true,
	use_treesitter = true,
	filetype_exclude = {
		"help",
		"man",
		"dashboard",
		"checkhealth",
		"startify",
		"dashboard",
		"packer",
		"neogitstatus",
		"NvimTree",
		"Trouble",
		"lspinfo",
		"git",
	},
	buftype_exclude = {
		'terminal',
		'nofile',
		'quickfix',
		'prompt',
	},
	context_patterns = {
		"class",
		"return",
		"function",
		"method",
		"^if",
		"^while",
		"jsx_element",
		"^for",
		"^object",
		"^table",
		"block",
		"arguments",
		"if_statement",
		"else_clause",
		"jsx_element",
		"jsx_self_closing_element",
		"try_statement",
		"catch_clause",
		"import_statement",
		"operation_type",
	}
}

vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

