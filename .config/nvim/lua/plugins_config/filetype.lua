-- Do not source the default filetype.vim
vim.g.did_load_filetypes = 1

local function bash_literal()
    vim.bo.filetype = 'sh'
    vim.b.is_bash = true
end

-- In init.lua or filetype.nvim's config file
require("filetype").setup({
	overrides = {
		extensions = {
			tf = "terraform",
			tfvars = "terraform",
			tfstate = "json",
			hcl = "terraform",
			sh = "bash",
			zsh = "bash"
		},
		complex = {
			-- Set the filetype of any full filename matching the regex to gitconfig
			[".*git/config"] = "gitconfig", -- Included in the plugin
		},

		-- The same as the ones above except the keys map to functions
		function_extensions = {
			["pdf"] = function()
				vim.bo.filetype = "pdf"
				-- Open in PDF viewer (Skim.app) automatically
				vim.fn.jobstart("open -a skim " .. '"' .. vim.fn.expand("%") .. '"')
			end,
		},
		function_literal = {
			['.bashrc'] = bash_literal,
			['.bash_profile'] = bash_literal,
			['.bash_history'] = bash_literal,
			['.bash_logout'] = bash_literal,
			Brewfile = function()
				vim.cmd("syntax off")
			end,
		},

		shebang = {
			-- Set the filetype of files with a dash shebang to sh
			dash = "sh",
		},
	},
})
