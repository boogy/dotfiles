" Enable gitgutter
let g:gitgutter_enabled = 1

" Turn on signs by default
let g:gitgutter_signs = 1

" Turn off line highlighting by default
let g:gitgutter_highlight_lines = 0

" To turn on line number highlighting by default
let g:gitgutter_highlight_linenrs = 1

let g:gitgutter_preview_win_floating = 1

" Use alternative grep command
let g:gitgutter_grep = 'rg'


" GitGutter mappings
"
nnoremap <F10> :GitGutterLineHighlightsToggle<CR>
nnoremap <F9> :GitGutterLineNrHighlightsToggle<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" stage a hunk with <Leader>hs or
" undo a hink with <Leader>hu.
" change these mappings
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)

function! GitGutterNextHunkCycle()
  let line = line('.')
  silent! GitGutterNextHunk
  if line('.') == line
    1
    GitGutterNextHunk
  endif
endfunction

function! NextHunkAllBuffers()
  let line = line('.')
  GitGutterNextHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bnext
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      1
      GitGutterNextHunk
      return
    endif
  endwhile
endfunction

function! PrevHunkAllBuffers()
  let line = line('.')
  GitGutterPrevHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bprevious
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      normal! G
      GitGutterPrevHunk
      return
    endif
  endwhile
endfunction

nmap <silent> ]c :call NextHunkAllBuffers()<CR>
nmap <silent> [c :call PrevHunkAllBuffers()<CR>
