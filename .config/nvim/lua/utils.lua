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

function M.ansi_colorize()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.statuscolumn = ""
  vim.wo.signcolumn = "no"
  vim.opt.listchars = { space = " " }

  local buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
  vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
  vim.api.nvim_create_autocmd("TextChanged", { buffer = buf, command = "normal! G$" })
  vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
end

return M
