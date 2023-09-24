local M = {}

M.opts = {
  -- set the minimum severity level
  min_diagnostic_severity = {
    -- min = vim.diagnostic.severity.WARN
    min = vim.diagnostic.severity.ERROR,
  },
}

function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  if opts.remap and not vim.g.vscode then
    opts.remap = nil
  end
  vim.keymap.set(mode, lhs, rhs, opts)
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

return M
