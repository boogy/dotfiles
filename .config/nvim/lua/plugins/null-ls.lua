local null_ls = require("null-ls")

-- Docs
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.completion.spell,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.beautysh,
		null_ls.builtins.diagnostics.zsh,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.sqlformat,
		null_ls.builtins.formatting.sqlfmt,
		null_ls.builtins.formatting.terraform_fmt,
		-- format terraform code in markdown files
		null_ls.builtins.formatting.terrafmt,
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.diagnostics.gospel,
		null_ls.builtins.formatting.usort,
		null_ls.builtins.formatting.trim_whitespace,

		-- JavaScript standard style
		null_ls.builtins.formatting.standardts,

		-- markdown formating
		null_ls.builtins.code_actions.ltrs,

		-- git commit message linter
		null_ls.builtins.diagnostics.gitlint
	},
})
