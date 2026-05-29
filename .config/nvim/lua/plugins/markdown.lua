return {
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_theme = "light"
      vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/css/github-markdown.css")
      vim.g.mkdp_highlight_css = vim.fn.expand("~/.config/nvim/css/github-highlight.css")
    end,
  },
}
