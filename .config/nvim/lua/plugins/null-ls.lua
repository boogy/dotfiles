-- load cmp_nvim_lsp
local null_ls_ok, null_ls = pcall(require, 'null-ls')
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

-- Docs
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
local sources = {
	----------------------------------------------------------------------------------------
	-- Code Actions
	----------------------------------------------------------------------------------------
	-- markdown formating
	null_ls.builtins.code_actions.ltrs,


	----------------------------------------------------------------------------------------
	-- Formating
	----------------------------------------------------------------------------------------
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.formatting.beautysh,
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.yamlfmt,
	null_ls.builtins.formatting.yamlfix,
	null_ls.builtins.formatting.xmllint,
	null_ls.builtins.formatting.xmlformat,
	null_ls.builtins.formatting.rustfmt,
	null_ls.builtins.formatting.isort,
	null_ls.builtins.formatting.reorder_python_imports,
	null_ls.builtins.formatting.black,
	null_ls.builtins.formatting.sqlformat,
	null_ls.builtins.formatting.sqlfmt,
	null_ls.builtins.formatting.terraform_fmt,
	null_ls.builtins.formatting.terrafmt,
	-- format terraform code in markdow:n files
	null_ls.builtins.formatting.usort,
	null_ls.builtins.formatting.trim_whitespace,
	-- JavaScript standard style
	null_ls.builtins.formatting.standardts,


	----------------------------------------------------------------------------------------
	-- Diagnostics
	----------------------------------------------------------------------------------------
	null_ls.builtins.diagnostics.eslint,
	null_ls.builtins.diagnostics.zsh,

	-- python
	null_ls.builtins.diagnostics.pylint.with({ method = null_ls.methods.DIAGNOSTICS_ON_SAVE }),

	null_ls.builtins.diagnostics.yamllint,
	null_ls.builtins.diagnostics.golangci_lint,
	null_ls.builtins.diagnostics.gospel,

	-- git commit message linter
	null_ls.builtins.diagnostics.gitlint,


	----------------------------------------------------------------------------------------
	-- Completions
	----------------------------------------------------------------------------------------
	null_ls.builtins.completion.spell,

	----------------------------------------------------------------------------------------
	-- Hover
	----------------------------------------------------------------------------------------
	null_ls.builtins.hover.dictionary,
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
					end
				})
			end
		})
	end,
})
