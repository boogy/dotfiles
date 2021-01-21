" au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm alternatively you can run :source $MYVIMRC

" Delete trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" augroup TerminalStuff
"   "au! " Clear old autocommands
"   autocmd TermOpen * setlocal nonumber norelativenumber
" augroup END

" Smarter cursorline
" Disabled when in insert mode
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" Add the proper PEP8 indentation
au BufRead,BufNewFile *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Add the proper yml indentation
au BufRead,BufNewFile *.yml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=120 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

