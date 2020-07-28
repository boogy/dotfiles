let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/dotfiles/bin
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +123 ~/dotfiles/.config/bspwm/bspwmrc
badd +248 ~/dotfiles/.config/sxhkd/sxhkdrc
badd +97 ~/dotfiles/.config/bspwm/scripts/bspwm-autostart.sh
badd +408 ~/dotfiles/.config/i3/config
badd +33 ~/dotfiles/.config/bspwm/scripts/bspwm-toggle-visibility
badd +3 ~/dotfiles/.config/bspwm/scripts/termite-class-scratchpad.sh
badd +81 ~/dotfiles/.config/bspwm/scripts/bspwm-external-rules.sh
argglobal
%argdel
$argadd ~/dotfiles/.config/bspwm/bspwmrc
edit ~/dotfiles/.config/sxhkd/sxhkdrc
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 247 - ((35 * winheight(0) + 46) / 92)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
247
normal! 06|
tabnext 1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOFc
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
