"###################################################
"# => Moving around, tabs, windows and buffers
"###################################################

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
" vnoremap < <gv " better indentation
" vnoremap > >gv " better indentation

" neovim terminal mappings
if has('nvim')
    " tnoremap <Esc> <C-\><C-n>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
endif

" VIM terminal mode mappings
tnoremap <Esc> <C-\><C-n>
nnoremap <leader>Tv :vsplit term://zsh<cr><C-w>r<cr>i<cr>
nnoremap <leader>Th :split term://zsh<cr>i<cr>

" using command history
" nnoremap : q:i
nnoremap / q/i
nnoremap ? q?i

" save read only files with w!!
cmap w!! w !sudo tee % >/dev/null

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-H> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
" map <leader>ba :1,1000 bd!<cr>
map <leader>ba :BufDo bd<cr>

" split all buffers in tabmap <leader>aT :Bufdo tab split<cr>s
map <leader>at :BufDo tab split<cr>

" Useful mappings for managing tabs
" map <leader>tn :tabnew<cr>
" map <leader>to :tabonly<cr>
" map <leader>tc :tabclose<cr>
" map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" easier moving of code blocks
" " Try to go into visual mode (v), thenselect several lines of code here and
" " then press ``>`` several times.
vnoremap < <gv " better indentation
vnoremap > >gv " better indentation

" Convert markdown to html and pdf shortcuts
if has("win32")
    nmap <leader>md :!c:\bin\md-2-html
    nmap <leader>mp :!c:\bin\md-2-pdf.cmd
" elseif has("unix")
else
    nmap <leader>md :!md-2-html
    nmap <leader>mp :!md-2-pdf
endif

"###################################################
"# => vimgrep searching and cope displaying
"###################################################

" Source current line
vnoremap <leader>L y:execute @@<cr>
" Source visual selection
nnoremap <leader>L ^vg_y:execute @@<cr>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
" map <leader>cc :botright cope<cr>
" map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
" map <leader>n :cn<cr>
" map <leader>p :cp<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
" map <leader>sn ]s
" map <leader>sp [s
" map <leader>sa zg
" map <leader>s? z=

"#########################
"# => Misc
"#########################

" map sort function to a key
vnoremap <Leader>s :sort<CR>

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
" map <leader>q :e ~/buffer<cr>

" Copy and paste to clipboard
" noremap <C-V> "+gP<cr>
noremap <C-c> "+y<cr>
vnoremap <C-c> "+y<cr>
noremap <Leader>Y "+y<cr>
noremap <Leader>P "+gP<cr>
vnoremap <Leader>Y "+y<cr>
vnoremap <Leader>P "+gP<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Fast saving / quiting / cpying / pasting
nnoremap <leader>e :bd!<cr>
nnoremap <leader>Q :qa!<cr>
nnoremap <leader>q :q!<cr>
nnoremap <leader>w :w!<cr>
nnoremap <leader>wq :w<bar>bd!<cr>
nnoremap <leader>D :bdelete!<cr>
" delete buffer with ALT+q
nnoremap <A-q> :bd!<cr>

" Save readonly file with :w!!
cmap w!! w !sudo tee > /dev/null %

" Yank content from OS's clipboard
vnoremap <leader>yo "*y
" Paste content from OS's clipboard
nnoremap <leader>po "*p

" Easier split navigation
" Use ctrl-[hjkl] to select the active split!
nnoremap <silent> <c-k> :wincmd k<CR>
nnoremap <silent> <c-j> :wincmd j<CR>
nnoremap <silent> <c-h> :wincmd h<CR>
nnoremap <silent> <c-l> :wincmd l<CR>

" ToggleMovement function for keys
" http://ddrscott.github.io/blog/2016/vim-toggle-movement/
" The original carat 0 swap
nnoremap <silent> 0 :call ToggleMovement('^', '0')<CR>

" How about ; and ,
" nnoremap <silent> ; :call ToggleMovement(';', ',')<CR>
" nnoremap <silent> , :call ToggleMovement(',', ';')<CR>

"""""""""""""""""""""
" Vim Tab shortcuts
"""""""""""""""""""""
" CTRL + l = move to the next tab
" CTRL + h = move to the previous tab
" CTRL + n = Create new tab
map <C-l> :tabn<CR>
map <C-h> :tabp<CR>
map <C-t> :tabnew<CR>
" This mapping makes Ctrl-Tab switch between tabs.
" Ctrl-Shift-Tab goes the other way.
noremap <C-Tab> :tabnext<CR>
noremap <C-S-Tab> :tabprev<CR>
" switch between tabs with cmd+1, cmd+2,..."
map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> 9gt

" Keyboard shortcuts
imap ,wq <Esc>:wq!<CR>
imap ,w <Esc>:w!<CR>
imap ,q <Esc>:q!<CR>
imap ,n <Esc>:tabn<CR>
imap ,p <Esc>:tabp<CR>
imap ,dd <Esc>dd<CR>

map <F8>  :AirlineToggle<CR>
map <F9>  :set wrap!<Bar>set wrap?<CR>
map <F10> :set paste!<Bar>set paste?<CR>
map <F11> :set hls!<Bar>set hls?<CR>
map <F12> :set number!<CR>

" map shift+Tab to insert a real tab
inoremap <S-Tab> <C-V><Tab>

" Vim-Easy-Align plugin
" https://github.com/junegunn/vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" Vim-Easy-Align plugin

"########################################
"# Plugin mappings
"########################################

" map <leader>T :NERDTreeToggle<CR>
map <leader>T :Lexplore<CR>
" map <F4> :NERDTreeToggle<CR>
map <F4> :Lexplore<CR>

nnoremap <F5> :GundoToggle<CR>
nnoremap <leader>U :GundoToggle<CR>

" VimWiki mappings
map <F7> :Vimwiki2HTMLBrowse<CR>
nnoremap <leader>wH :Vimwiki2HTMLBrowse<CR>


" syntastic mappings
map <Leader>S :SyntasticToggleMode<CR>

" Tabularise mappings
" if exists(':Tabularize')
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>
nmap <leader>a; :Tabularize /;\zs<CR>
vmap <leader>a; :Tabularize /;\zs<CR>
nmap <leader>a, :Tabularize /,<CR>
vmap <leader>a, :Tabularize /,<CR>
nmap <leader>a\| :Tabularize /\|<CR>
vmap <leader>a\| :Tabularize /\|<CR>
" endif

"
" Haskell modules
"
" ghc-mod
map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

" SuperTab config for haskell
if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" FZF-vim mappings
nnoremap ; :Files<CR>
nnoremap <leader>b :Buffers<CR>


" ################################
" # Correcting/abreaviating stuff
" ################################
iabbr funcition function
iabbr funciton function
iabbr treu true
iabbr ture true
iabbr fales false
iabbr flase false
iabbr pythnon python

