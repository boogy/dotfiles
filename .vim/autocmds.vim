" Delete trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" If it is an assembly file use asm
au BufRead,BufNewFile *.asm set filetype=asm
au BufRead,BufNewFile *.nasm set filetype=asm

au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */playbooks/*.yaml set filetype=yaml.ansible
au BufRead,BufNewFile */grc-ansible/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */grc-ansible/*.yaml set filetype=yaml.ansible
au BufRead,BufNewFile */hosts_playbooks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */hosts_playbooks/*.yaml set filetype=yaml.ansible

" au BufRead,BufNewFile,BufReadPost *.md set filetype=markdown
au BufNewFile,BufFilePre,BufRead,BufReadPost *.md,.*markdown set filetype=markdown

" VIM terminal mode remove line numbers
if has('nvim')
    augroup TerminalStuff
      "au! " Clear old autocommands
      autocmd TermOpen * setlocal nonumber norelativenumber
    augroup END
endif

" Quickly change font size un GUI
command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

" Smarter cursorline
" Disabled when in insert mode
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" If it is an vim file use vim syntax
au BufRead,BufNewFile *.vim set filetype=vim

" Add the proper PEP8 indentation
au BufRead,BufNewFile *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
"
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

" Automatic reloading of .vimrc
" autocmd! bufwritepost .vimrc source %

" open each file in a tab
" autocmd BufReadPost * tab ball

" ANSIBLE
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */defaults/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */taks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */handlers/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */roles/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */vars/*.yml set filetype=yaml.ansible

augroup ansible_vim_fthosts
  autocmd!
  autocmd BufNewFile,BufRead hosts setfiletype yaml.ansible
augroup END
