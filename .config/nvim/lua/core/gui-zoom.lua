-- Handle GUI zoom

-- vim.cmd([[
-- if exists('g:loaded_gui_zoom') || &compatible
--   finish
-- endif
-- let g:loaded_gui_zoom = 1
-- let s:current_font = &guifont
--
-- function! ZoomIn()
--   let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
--   let l:gf_size_whole = l:gf_size_whole + 1
--   let l:new_font_size = ':h'.l:gf_size_whole
--   let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
-- endfunction
--
-- function! ZoomOut()
--   let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
--   let l:gf_size_whole = l:gf_size_whole - 1
--   let l:new_font_size = ':h'.l:gf_size_whole
--   let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
-- endfunction
--
-- function! ZoomReset()
--   let &guifont = s:current_font
-- endfunction
--
-- command! ZoomIn call ZoomIn()
-- command! ZoomOut call ZoomOut()
-- command! ZoomReset call ZoomReset()
-- ]])


vim.cmd([[
if &cp || exists("g:loaded_zoom")
    finish
endif
let g:loaded_zoom = 1

let s:save_cpo = &cpo
set cpo&vim

let s:current_font = &guifont

command! -narg=0 ZoomIn    :call s:ZoomIn()
command! -narg=0 ZoomOut   :call s:ZoomOut()
command! -narg=0 ZoomReset :call s:ZoomReset()

function! s:ZoomIn()
  let l:fsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
  let l:fsize += 1
  let l:guifont = substitute(&guifont, ':h\([^:]*\)', ':h' . l:fsize, '')
  let &guifont = l:guifont
endfunction

function! s:ZoomOut()
  let l:fsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
  let l:fsize -= 1
  let l:guifont = substitute(&guifont, ':h\([^:]*\)', ':h' . l:fsize, '')
  let &guifont = l:guifont
endfunction

function! s:ZoomReset()
  let &guifont = s:current_font
endfunction

let &cpo = s:save_cpo
]])
