" Use deoplete.
let g:deoplete#enable_at_startup = 1

" open split window below and not on top
set splitbelow

" close hint window once auto-completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
