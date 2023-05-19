local M = {}

M.opts = {
	-- set the minimum severity level
	min_diagnostic_severity = {
		-- min = vim.diagnostic.severity.WARN
		min = vim.diagnostic.severity.ERROR,
	},
}

function M.map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.imap(tbl)
	vim.keymap.set("i", tbl[1], tbl[2], tbl[3])
end

function M.nmap(tbl)
	vim.keymap.set("n", tbl[1], tbl[2], tbl[3])
end

function M.toggle_diagnostics()
	if vim.g.diagnostics_visible then
		vim.g.diagnostics_visible = false
		vim.diagnostic.disable()
	else
		vim.g.diagnostics_visible = true
		vim.diagnostic.enable()
	end
end

function M.toggle_virtual_text()
	if not vim.diagnostic.config()["virtual_text"] == false then
		vim.diagnostic.config({ virtual_text = false })
	else
		vim.diagnostic.config({
			virtual_text = {
				severity = M.opts.min_diagnostic_severity, -- { min = vim.diagnostic.severity.WARN },
			},
		})
	end
end

-- function M.set_min_diagnostic_severity(severity)
-- 	if severity == "WARN" then
-- 		M.min_diagnostic_severity = { min = vim.diagnostic.severity.WARN }
-- 	elseif severity == "ERROR" then
-- 		M.min_diagnostic_severity = { min = vim.diagnostic.severity.ERROR }
-- 	elseif severity == "INFO" then
-- 		M.min_diagnostic_severity = { min = vim.diagnostic.severity.WARN }
-- 	end
-- end

return M
