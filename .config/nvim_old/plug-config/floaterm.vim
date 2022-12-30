" Floaterm

let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_next   = '<F2>'
let g:floaterm_keymap_prev   = '<F3>'
let g:floaterm_keymap_new    = '<F4>'

let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1

" nnoremap <leader>t :FloatermToggle<CR>
" nnoremap <leader>z :FloatermNew fzf<CR>
" nnoremap <leader>v :FloatermNew vifm<CR>

command! Vifm FloatermNew vifm
command! Ranger FloatermNew ranger
command! FZF FloatermNew fzf
command! PY FloatermNew python
