set laststatus=2
set noshowmode

if !has('gui_running')
  set t_Co=256
endif

" Cool Themes
" PaperColor, wombat, nord, one_dark, jellybeans, PaperColor_dark, seoul256
" deus, material, molokai, materia, ayu_{light,dark,mirage}
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'lightline_hunks','readonly', 'absolutepath', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype', 'coc_status' ] ]
      \ },
      \ 'component_function': {
      \   'lightline_hunks': 'LightLineHunksComposer',
      \   'coc_status': 'coc#status'
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }

let g:lightline.tabline = {
  \   'left': [ ['buffers'] ],
  \   'right': [ ['close'] ]
  \ }
" let g:lightline.tabline = {
"   \   'left': [ ['tabs'] ],
"   \   'right': [ ['close'] ]
"   \ }

let g:lightline.separator = {
	\   'left': '', 'right': ''
  \}
let g:lightline.subseparator = {
	\   'left': '', 'right': ''
  \}

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" COC status force lightline update
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()


" Show git hunk symbols in lightline
" code from : https://github.com/sinetoami/lightline-hunks
let s:branch_symbol = get(g:, 'branch_symbol', ' ')
let s:hunk_symbols = get(g:, 'hunk_symbols', ['+', '~', '-'])
let s:exclude_filetypes = get(g:, 'exclude_filetypes', [])
let s:only_branch = get(g:, 'only_branch', 0)

function! s:get_hunks_gitgutter()
  if !get(g:, 'gitgutter_enabled', 0) || index(s:exclude_filetypes, &filetype) >= 0
    return ''
  endif
  return GitGutterGetHunkSummary()
endfunction

function! LightLineHunksComposer()
  let hunks = s:get_hunks_gitgutter()
  if exists('*FugitiveHead') && !empty(hunks)
    let compose = ''
    for i in [0, 1, 2]
      if winwidth(0) > 100
        let compose .= printf('%s%s', s:hunk_symbols[i], hunks[i]).' '
      endif
    endfor
    let branch = FugitiveHead()
    if branch ==# ''
      return ''
    endif
    if s:only_branch == 1
      return s:branch_symbol . branch
    endif

    return compose . s:branch_symbol . branch
  endif
  return ''
endfunction


"########################################################
" Configuration for lightline-bufferline plugin
"########################################################

let g:lightline.component_raw = {'buffers': 1}

let g:lightline#bufferline#enable_nerdfont=1
let g:lightline#bufferline#unicode_symbols=1
let g:lightline#bufferline#show_number=2
let g:lightline#bufferline#clickable=1

" Quick move to buffers
nmap <leader>1 <Plug>lightline#bufferline#go(1)
nmap <leader>2 <Plug>lightline#bufferline#go(2)
nmap <leader>3 <Plug>lightline#bufferline#go(3)
nmap <leader>4 <Plug>lightline#bufferline#go(4)
nmap <leader>5 <Plug>lightline#bufferline#go(5)
nmap <leader>6 <Plug>lightline#bufferline#go(6)
nmap <leader>7 <Plug>lightline#bufferline#go(7)
nmap <leader>8 <Plug>lightline#bufferline#go(8)
nmap <leader>9 <Plug>lightline#bufferline#go(9)
nmap <leader>0 <Plug>lightline#bufferline#go(10)

" delete buffers
nmap <leader>c1 <Plug>lightline#bufferline#delete(1)
nmap <leader>c2 <Plug>lightline#bufferline#delete(2)
nmap <leader>c3 <Plug>lightline#bufferline#delete(3)
nmap <leader>c4 <Plug>lightline#bufferline#delete(4)
nmap <leader>c5 <Plug>lightline#bufferline#delete(5)
nmap <leader>c6 <Plug>lightline#bufferline#delete(6)
nmap <leader>c7 <Plug>lightline#bufferline#delete(7)
nmap <leader>c8 <Plug>lightline#bufferline#delete(8)
nmap <leader>c9 <Plug>lightline#bufferline#delete(9)
nmap <leader>c0 <Plug>lightline#bufferline#delete(10)

" normal mapping can be added with
" nmap <Leader>1 :call lightline#bufferline#go(1)<CR>
" nmap <D-1> :call lightline#bufferline#delete(1)<CR>

" Delete buffers by asking for its ordinal number
command! -nargs=* DelBufferline :call lightline#bufferline#delete(<q-args>)
nmap <silent> <leader>C :DelBufferline

