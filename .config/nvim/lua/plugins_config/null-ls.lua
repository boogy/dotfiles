-- load cmp_nvim_lsp
local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
	return
end

local defaults = {
	border = nil,
	cmd = { "nvim" },
	debounce = 250,
	debug = false,
	default_timeout = 5000,
	diagnostic_config = {},
	diagnostics_format = "#{m}",
	fallback_severity = vim.diagnostic.severity.ERROR,
	log_level = "warn",
	notify_format = "[null-ls] %s",
	on_attach = nil,
	on_init = nil,
	on_exit = nil,
	root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
	should_attach = nil,
	sources = nil,
	temp_dir = nil,
	update_in_insert = false,
}

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion
local hover = null_ls.builtins.hover
local code_actions = null_ls.builtins.code_actions

-- Docs
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
local sources = {
	----------------------------------------------------------------------------------------
	-- Code Actions
	----------------------------------------------------------------------------------------
	-- markdown formating
	code_actions.ltrs,
	code_actions.gitsigns,
	code_actions.shellcheck,

	----------------------------------------------------------------------------------------
	-- Formating
	----------------------------------------------------------------------------------------
	formatting.prettier,
	formatting.shfmt,
	formatting.beautysh,
	formatting.stylua,
	-- formatting.yamlfmt,
	-- formatting.yamlfix,
	-- formatting.xmllint,
	-- formatting.xmlformat,
	-- formatting.rustfmt,
	formatting.isort,
	formatting.black,
	formatting.reorder_python_imports,
	formatting.sqlformat,
	formatting.sqlfmt,
	formatting.terraform_fmt,
	formatting.terrafmt,
	-- format terraform code in markdow:n files
	formatting.usort,
	formatting.trim_whitespace,
	-- JavaScript standard style
	formatting.standardts,

	----------------------------------------------------------------------------------------
	-- Diagnostics
	----------------------------------------------------------------------------------------
	diagnostics.eslint,
	diagnostics.zsh,
	diagnostics.ansiblelint,

	-- python
	diagnostics.pylint.with({
		method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
		diagnostics_postprocess = function(diagnostic)
			diagnostic.code = diagnostic.message_id
		end,
	}),
	-- diagnostics.flake8,

	-- diagnostics.yamllint,
	-- diagnostics.flake8,
	diagnostics.golangci_lint,
	diagnostics.gospel,

	-- git commit message linter
	diagnostics.gitlint,

	----------------------------------------------------------------------------------------
	-- Completions
	----------------------------------------------------------------------------------------
	completion.spell,

	----------------------------------------------------------------------------------------
	-- Hover
	----------------------------------------------------------------------------------------
	hover.dictionary,
}

null_ls.setup({
	debug = true,
	sources = sources,
	defaults = defaults,

	-- format on save
	on_attach = function()
		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				vim.lsp.buf.format({
					filter = function(client)
						return client.name == "null-ls"
					end,
				})
			end,
		})
	end,
})
