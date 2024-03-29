-- Setup neovim lua configuration
local keymap = vim.keymap -- for conciseness

-- load neodev
local neodev_ok, neodev = pcall(require, "neodev")
if not neodev_ok then
	return
end
neodev.setup()

-- load cmp_nvim_lsp
local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_status_ok then
	return
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Turn on lsp status information
local fidget_ok, fidget = pcall(require, "fidget")
if not fidget_ok then
	return
end
fidget.setup()

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	bashls = {},
	clangd = {},
	gopls = {},
	dockerls = {},
	pyright = {},
	rust_analyzer = {},
	tsserver = {},
	awk_ls = {},
	pylsp = {
		plugins = {
			pyflakes = { enabled = false },
			pycodestyle = { enabled = false },
			flake8 = { enabled = false },
			pylint = {
				enabled = false,
				args = {
					"--disable=C0111,C0103,C0115,C0114,E501",
					"--module-naming-style=snake_case",
				},
			},
			pyright = {
				enabled = true,
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
			},
		},
	},
	jsonls = {},
	yamlls = {
		yaml = {
			keyOrdering = false,
			validate = true,
			completion = true,
			format = {
				enable = false,
				singleQuote = false,
				bracketSpacing = true,
			},
		},
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
	},
	graphql = {},
	ansiblels = {},
	terraformls = {},
	tflint = {
		workspace = { checkThirdParty = false },
		telemetry = { enable = false },
	},

	lua_ls = {
		Lua = {
			workspace = {
				checkThirdParty = false,
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
			telemetry = { enable = false },
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
}

-- Setup mason so it can manage external tooling
-- require('mason').setup()
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end
mason.setup()

-- Ensure the servers above are installed
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	return
end

mason_lspconfig.setup({
	automatic_installation = true,
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		})
	end,
})

-------------------------------------------------------------------------------------------
--
-- LSP Diagnostics
--
-------------------------------------------------------------------------------------------
vim.g.diagnostics_visible = true
local min_diagnostic_severity = require("utils").opts.min_diagnostic_severity

keymap.set("n", "[d", vim.diagnostic.goto_prev)
keymap.set("n", "]d", vim.diagnostic.goto_next)
keymap.set("n", "<leader>E", vim.diagnostic.open_float)
keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- disable diagnostic message and show only on hoover
vim.diagnostic.config({
	virtual_text = false,
	-- signs = true,
	signs = {
		severity = min_diagnostic_severity,
	},
	update_in_insert = false,
	-- underline = true,
	underline = {
		severity = min_diagnostic_severity,
	},
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd(
	[[ autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float( {severity = min_diagnostic_severity}, {focus=false}) ]]
)

-- vim.api.nvim_buf_set_keymap(0, 'n', '<leader>tt', ':call v:lua.require("utils").toggle_diagnostics()<CR>', { silent = true, noremap = true })
-- vim.api.nvim_buf_set_keymap(0, 'n', '<leader>T', ':call v:lua.require("utils").toggle_virtual_text()<CR>', { silent = true, noremap = true })
keymap.set(
	"n",
	"<leader>tt",
	':call v:lua.require("utils").toggle_diagnostics()<CR>',
	{ silent = true, noremap = true }
)
keymap.set(
	"n",
	"<leader>T",
	':call v:lua.require("utils").toggle_virtual_text()<CR>',
	{ silent = true, noremap = true }
)
