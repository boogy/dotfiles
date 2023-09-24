return {
  "linux-cultist/venv-selector.nvim",
  cmd = "VenvSelect",
  opts = {
    name = {
      "venv",
      ".venv",
      "env",
      ".env",
    },
  },
  keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
}
