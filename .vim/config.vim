"###################################################
"# => General vim configuration (no plugin needed)
"###################################################

set timeout
set timeoutlen=750
set ttimeoutlen=250
if has('nvim')
    set ttimeout
    set ttimeoutlen=0
endif

" Sets how many lines of history VIM has to remember
set history=1000

" Hide mouse after chars typed
set mousehide
" enbable the mouse in term
set mouse=a
" set mouse=nicr

" set termguicolors

" enable only scrolling mouse
" set mouse=nicr

" Move the cursor eaven if there is nothing there
"set virtualedit=all

" Set a dolar at the end of the word when changing that word
set cpoptions+=$

" Faster keywork completion
set complete-=i   " disable scanning included files
set complete-=t   " disable searching tags

" Enable filetype plugins
" filetype plugin on
" filetype indent on

" Yanks go on clipboard instead.
" if has("win32")
"     set clipboard+=unnamed
" else
"     set clipboard=unnamed,unnamedplus
" endif

" Writes on make/shell commands
set autowrite

" Add extra characters that are valid parts of variables
set iskeyword+=\$,-

" Keep three lines below the last line when scrolling
set scrolloff=3

" Switch to an existing buffer if one exists
" set switchbuf=useopen

" Make vim completion popup menu work like in an IDE
set completeopt=menuone,longest,preview

" Show some line numbers the nice way
set relativenumber
set number

" Automatically reload changes if detected
set autoread

" code folding; using 3 open/closing braces
" http://vim.wikia.com/wiki/Folding
set foldmethod=marker

" Enable paste mode
set pastetoggle=<F3>

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Hide the mouse pointer while typing
set mousehide

" Show the current mode
set showmode

" When completing by tag, show the whole tag, not just the function name
set showfulltag

" Add ignorance of whitespace to diff
set diffopt+=iwhite

" Set up the gui cursor to look nice
"set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

"###################################################
"# => VIM UI
"###################################################

" Show cursorline
set cul
" Show cursorcolumn
" set cuc

" Make the command area two lines high
set cmdheight=2

" Set the title of the window in the terminal to the file
set title

" Show invisible caracters
set list
" show trailing spaces as dots
" set listchars+=trail:•
" set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:␣
" set showbreak=↪
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*~,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,
    \*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,
    \*.gif,.DS_Store,*.aux,*.out,*.toc,*.tmp,*.pyc,*.cabal-sandbox,
    \*.swo

"Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"#######################
"# => Colors and Fonts
"#######################

" Enable syntax highlighting
syntax enable

" Enable terminal colors if possible
if $TERM =~ "-256color"
    set t_Co=256
endif

" colorscheme monokai
colorscheme material-monokai
set background=dark

" set background transparent
" hi Normal guibg=NONE ctermbg=NONE

" change highlight color
" hi Visual guifg=White guibg=LightBlue gui=none
hi Visual guifg=Black guibg=LightGreen gui=none

" hi CursorLine term=NONE cterm=NONE ctermbg=darkgrey ctermfg=white
hi CursorLine term=NONE cterm=bold guibg=Grey40

" set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    " Disable scrollbars (real hackers don't use scrollbars for navigation!)
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    set guioptions+=e

    " windows colors correction
    set t_Co=256
    set term=xterm
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"

    set guitablabel=%M\ %t
    set lines=50 columns=160

    if has("win32")
        set gfn=Liberation\ Mono:h10
    endif

    if has("unix")
        " set gfn=Ubuntu\ Mono\ derivative\ Powerline\ 11
        set gfn=Source\ Code\ Pro\ for\ Powerline\ Regular\ 10
    endif

    " colorscheme monokai
    colorscheme material-monokai
    set background=dark
    hi Visual guifg=Black guibg=LightGreen gui=none
    " hi Visual guifg=White guibg=LightBlue gui=none
endif

" Set utf8 as standard encoding
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"#############################
"# => Files, backups and undo
"#############################

" Turn backup off
" set backupdir=~/.vim/.backup/
" set directory=~/.vim/.tmp/
set nobackup
set nowb
set noswapfile

"##################################
"# => Text, tab and indent related
"##################################

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

" Auto indent
set ai

" Smart indent
set si

" Wrap lines
set wrap

" Remember info about open buffers on close
set viminfo^=%

"###################
"# => Status line
"###################

" Always show the status line
set laststatus=2

" Format the status line
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
" set stl=%f\ %m\ %r%{HasPaste()}%fugitive#statusline()}\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]\ Type:%Y

" Turn off some vim logging stuff to .viminfo
set viminfo=<0,'100,<50,s10,h


"#############################
"# => Plugins configurations
"#############################

" Use deoplete.
let g:deoplete#enable_at_startup = 1

let g:airline_theme="wombat"
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']
let g:airline#extensions#hunks#non_zero_only = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#tagbar#enabled = 1

" Windows bugs with these on
" and window resize is shitty
if !has("win32")
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_tabs = 1
    let g:airline#extensions#tabline#show_splits = 0
    let airline#extensions#tabline#show_buffers = 0
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline#extensions#tabline#right_sep = ''
    let g:airline#extensions#tabline#right_alt_sep = ''

    let g:airline_powerline_fonts = 1
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
endif

" ##################
" # python-mode settings
" ##################
let g:pymode = 1
let g:pymode_folding = 0
let g:pymode_indent = 1
let g:pymode_doc = 1
let g:pymode_options_colorcolumn = 0
let g:pymode_rope_show_doc_bind = ""
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_autoimport_modules = ['os', 'sys']
let g:pymode_lint_checker = ["pyflakes", "pep8" ]
let g:pymode_syntax_print_as_function = 1
let g:pymode_trim_whitespaces = 1
" show documentation for current word
let g:pymode_doc_bind = 'K'
" Check code on every save (if file has been modified)
let g:pymode_lint_on_write = 0
let g:pymode_rope = 0
" Turn off plugin's warnings
let g:pymode_warnings = 1
let g:syntastic_python_pylint_post_args="--max-line-length=180"


" ##################
" # NERDTree settings
" ##################
let g:NERDTreeIgnore=[
            \ '\.pyc$', '\~$', '\.DS_Store', '\.ropeproject',
            \ '\.swap', '\.git*',
            \ ]
let NERDTreeShowBookmarks=1
" let g:NERDTreeShowHidden=1


" ##################
" # UtilSnips settings
" ##################
" Trigger configuration
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" multiple-cursor Default mapping
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Python ISort imports mappings
let g:vim_isort_map = '<C-i>'

" ###################
" Jedi configuration
" ###################
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#auto_initialization = 1
" show function signature in insert mode
let g:jedi#show_call_signatures = "1"
" left, right, top, bottom or winwidth
let g:jedi#use_splits_not_buffers = "winwidth"
" let g:jedi#use_tabs_not_buffers = 1
" let g:jedi#use_tabs_not_buffers = 1
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>D"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"

" syntastic options
" See mappings.vim for syntastic mappings
let g:syntastic_enable_highlighting = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

"
" Markdown
"
let g:vim_markdown_folding_disabled = 1
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
" let g:pandoc#filetypes#pandoc_markdown = 0

" vim-markdown
set conceallevel=0
" 0 to disable conceallevel
let g:vim_markdown_conceal = 1
let g:vim_markdown_new_list_item_indent = 0
let g:markdown_minlines = 100
let g:markdown_fenced_languages = ['bash=sh', 'css', 'django', 'javascript', 'js=javascript', 'json=javascript', 'perl', 'php', 'python', 'erb=eruby', 'ruby', 'sass', 'xml', 'html', 'csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
let g:vim_markdown_fenced_languages = ['bash=sh', 'css', 'django', 'javascript', 'js=javascript', 'json=javascript', 'perl', 'php', 'python', 'erb=eruby', 'ruby', 'sass', 'xml', 'html', 'csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']

"
" Rust plugin configurations
"
let g:rustfmt_autosave = 1
let g:rust_clip_command = 'xclip -selection clipboard'
let g:racer_experimental_completer = 1


"
" FZF configurations
"
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" ANSIBLE configurations
let g:ansible_attribute_highlight = "ob"
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1
let g:ansible_normal_keywords_highlight = 'Constant'
let g:ansible_with_keywords_highlight = 'Constant'
let g:ansible_template_syntaxes = { '*.rb.j2': 'ruby' }

