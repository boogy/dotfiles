-- vim-markdown

vim.o.conceallevel=0
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_frontmatter = 1

vim.g.vim_markdown_new_list_item_indent = 0
vim.g.markdown_minlines = 100
-- vim.g.markdown_fenced_languages = "['bash=sh', 'css', 'django', 'javascript', 'js=javascript', 'json=javascript', 'perl', 'php', 'python', 'erb=eruby', 'ruby', 'sass', 'xml', 'html', 'csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'terraform=terraform']"
-- vim.g.vim_markdown_fenced_languages = "['bash=sh', 'css', 'django', 'javascript', 'js=javascript', 'json=javascript', 'perl', 'php', 'python', 'erb=eruby', 'ruby', 'sass', 'xml', 'html', 'csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'terraform=terraform']"
vim.g.vim_markdown_conceal = 0

vim.cmd([[
  au BufNewFile,BufFilePre,BufRead,BufReadPost *.md,.*markdown set filetype=markdown
]])

