" vim-markdown
set conceallevel=0
let g:vim_markdown_folding_disabled = 1
" 0 to disable conceallevel
let g:vim_markdown_conceal = 0
let g:vim_markdown_new_list_item_indent = 0
let g:markdown_minlines = 100
let g:markdown_fenced_languages = ['bash=sh', 'css', 'django', 'javascript', 'js=javascript', 'json=javascript', 'perl', 'php', 'python', 'erb=eruby', 'ruby', 'sass', 'xml', 'html', 'csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
let g:vim_markdown_fenced_languages = ['bash=sh', 'css', 'django', 'javascript', 'js=javascript', 'json=javascript', 'perl', 'php', 'python', 'erb=eruby', 'ruby', 'sass', 'xml', 'html', 'csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']

" au BufRead,BufNewFile,BufReadPost *.md set filetype=markdown
au BufNewFile,BufFilePre,BufRead,BufReadPost *.md,.*markdown set filetype=markdown
