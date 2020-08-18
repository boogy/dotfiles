set laststatus=2
set noshowmode

if !has('gui_running')
  set t_Co=256
endif

" Cool Themes
" PaperColor, wombat, nord, one_dark, jellybeans, PaperColor_dark, seoul256
" deus, material, molokai, materia, ayu_{light,dark,mirage}
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'lightline_hunks','readonly', 'absolutepath', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype', 'coc_status' ] ]
      \ },
      \ 'component_function': {
      \   'lightline_hunks': 'LightLineHunksComposer',
      \   'coc_status': 'coc#status'
      \ },
      \ }

let g:lightline.tabline = {
  \   'left': [ ['tabs'] ],
  \   'right': [ ['close'] ]
  \ }

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
