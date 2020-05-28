" set leader key
let mapleader = ","
let g:mapleader = ","

syntax enable                           " Enables syntax highlighing
" set hidden                              " Required to keep multiple buffers open multiple buffers
set nowrap                              " Display long lines as just one line
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler              			            " Show the cursor position all the time
set cmdheight=2                         " More space for displaying messages
set iskeyword+=-                      	" treat dash separated words as a word text object"
set mouse=a                             " Enable your mouse
set mousehide                           " Hide mouse after chars are typed
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=4                           " Insert 2 spaces for a tab
set softtabstop=4                       " Nb of spaces that Tab counts for while performing edit operations
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
set laststatus=0                        " Always display the status line
set number                              " Line numbers
set relativenumber                      " Show relative line numbers
set cursorline                          " Enable highlighting of the current line
set background=dark                     " tell vim what the background color looks like
set showtabline=2                       " Always show tabs
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set updatetime=300                      " Faster completion
set timeoutlen=100                      " By default timeoutlen is 1000 ms
set formatoptions-=cro                  " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
set autoread                            " Automatically reload changes if detected
set cpoptions+=$                        " Set a dolar at the end of the word when changing that word
set ignorecase                          " Ignore case when searching
set smartcase                           " When searching try to be smart about cases
set incsearch                           " Makes search act like search in modern browsers
set showmatch                           " Show matching brackets when text indicator is over them
set backspace=eol,start,indent          " Configure backspace so it acts as it should
set lazyredraw                          " Don't redraw while executing macros (better performance config)

" timeout or commentary is not working properly
set ttimeout
set timeoutlen=350
set ttimeoutlen=0

if exists('+termguicolors')
  " let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

