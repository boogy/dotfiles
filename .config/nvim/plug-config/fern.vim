" Fern file explorer configurations

let g:fern#disable_default_mappings   = 1
let g:fern#disable_drawer_auto_quit   = 1
let g:fern#disable_viewer_hide_cursor = 1

" let g:fern#mark_symbol                       = '●'
" let g:fern#renderer#default#collapsed_symbol = '▷ '
" let g:fern#renderer#default#expanded_symbol  = '▼ '
" let g:fern#renderer#default#leading          = ' '
" let g:fern#renderer#default#leaf_symbol      = ' '
" let g:fern#renderer#default#root_symbol      = '~ '

noremap <silent> ,d :Fern . -drawer -width=45 -toggle<CR><C-w>=
noremap <silent> <leader>p :Fern . -drawer -reveal=% -width=45 -toggle<CR><C-w>=
noremap <silent> ,f :Fern %:h -drawer -width=45 -toggle<CR><C-w>=


function! FernInit() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> n <Plug>(fern-action-new-file)
  nmap <buffer> N <Plug>(fern-action-new-dir)
  nmap <buffer> M <Plug>(fern-action-mark:toggle)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> r <Plug>(fern-action-rename)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> R <Plug>(fern-action-reload)
  nmap <buffer> y <Plug>(fern-action-copy)
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> <nowait> . <Plug>(fern-action-hidden:toggle)
  nmap <buffer> <nowait> < <Plug>(fern-action-leave)
  nmap <buffer> <nowait> > <Plug>(fern-action-enter)
endfunction

augroup FernEvents
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

" Automatically update the tree upon entering fern window
augroup FernTypeGroup
    autocmd! * <buffer>
    autocmd BufEnter <buffer> silent execute "normal \<Plug>(fern-action-reload)"
augroup END

" Fern git status
" Plug 'lambdalisue/fern-git-status.vim'
let g:fern_git_status#disable_ignored    = 1
let g:fern_git_status#disable_untracked  = 1
let g:fern_git_status#disable_submodules = 1

" fern-renderer-devicons.vim
let g:fern#renderer = "devicons"

