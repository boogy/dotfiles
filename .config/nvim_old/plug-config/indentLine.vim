let g:indentLine_enabled = 1
let g:indentLine_setColors = 1

" Vim
" let g:indentLine_color_term = 239

" GVim
" let g:indentLine_color_gui = '#6b776b'

" none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)

" Background (Vim, GVim)
" let g:indentLine_bgcolor_term = 202
" let g:indentLine_bgcolor_gui = '#FF5F00'

let g:indentLine_char = '▏'
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" let g:indentLine_concealcursor = 'inc'
" let g:indentLine_conceallevel = 2

" specify whether the first indent level should be shown
" let g:indentLine_showFirstIndentLevel = 1

" Specify a character to show for leading spaces
" let g:indentLine_leadingSpaceChar = '˽'
" let g:indentLine_leadingSpaceChar='·'
" let g:indentLine_leadingSpaceEnabled='1'

" Specify whether to auto redraw the indentLines after 'shiftwidth' or 'tabstop' change
let g:indentLine_autoResetWidth = 1

nnoremap <leader>I :IndentLinesToggle<cr>
