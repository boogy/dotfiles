if has("win32")
    let s:editor_root=expand("~/vimfiles")
else
    let s:editor_root=expand("~/.vim")
endif

if empty(glob(s:editor_root . '/autoload/plug.vim'))
    autocmd VimEnter * echom "Downloading and installing vim-plug..."
    silent execute "!curl -fLo " . s:editor_root . "/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall
endif

call plug#begin(s:editor_root . '/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/syntastic'           , { 'on': [] }
Plug 'tpope/vim-git'                  , { 'on': [] }
Plug 'airblade/vim-gitgutter'         , { 'on': [] }
Plug 'scrooloose/nerdtree'            , { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'
Plug 'terryma/vim-multiple-cursors'
" Plug 'edkolev/tmuxline.vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" List files in directory in vim
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'deoplete-plugins/deoplete-jedi'
"----------------------------------------------------------------
" Python modules
Plug 'klen/python-mode'             , { 'for': 'python' }
Plug 'fisadev/vim-isort'            , { 'for': 'python' }
Plug 'jmcantrell/vim-virtualenv'    , { 'for': 'python' }
Plug 'vim-scripts/python_match.vim' , { 'for': 'python' }
" Plug 'davidhalter/jedi-vim'         , { 'for': 'python' }
"----------------------------------------------------------------
"----------------------------------------------------------------
" Nodejs plugins
Plug 'moll/vim-node'                , { 'for': 'javascript'}
Plug 'jelera/vim-javascript-syntax' , { 'for': 'javascript'}
Plug 'myhere/vim-nodejs-complete'   , { 'for': 'javascript'}
Plug 'jamescarr/snipmate-nodejs'    , { 'for': 'javascript'}
"----------------------------------------------------------------
"----------------------------------------------------------------
" Syntax plugins and themes
Plug 'PProvost/vim-ps1'        , { 'for': ['ps1', 'powershell', 'psm1'] }
Plug 'ekalinin/Dockerfile.vim' , { 'for': ['docker', 'Dockerfile'] }
Plug 'pearofducks/ansible-vim'
"----------------------------------------------------------------
"----------------------------------------------------------------
" Programming plugins
Plug 'fatih/vim-go'         , { 'for': 'go'}
Plug 'rust-lang/rust.vim'   , { 'for': ['rust' , 'rs']}
Plug 'racer-rust/vim-racer' , { 'for': ['rust' , 'rs']}
"----------------------------------------------------------------
"----------------------------------------------------------------
"Markdown config
" Plug 'tpope/vim-markdown'       , { 'for': 'markdown' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
"----------------------------------------------------------------
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
"----------------------------------------------------------------
call plug#end()

" Load plugins on insert
augroup load_us_ycm
  autocmd!
  autocmd InsertEnter * call plug#load(
              \'syntastic',
              \'vim-git', 'vim-gitgutter'
              \)
                     \| autocmd! load_us_ycm
augroup END

exec "source " . s:editor_root . "/functions.vim"
exec "source " . s:editor_root . "/config.vim"
exec "source " . s:editor_root . "/mappings.vim"
exec "source " . s:editor_root . "/autocmds.vim"
