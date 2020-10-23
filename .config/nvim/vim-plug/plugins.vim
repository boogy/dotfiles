" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Most have plugins
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-git'
    Plug 'airblade/vim-gitgutter'

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    Plug 'terryma/vim-multiple-cursors'

    " code snippets
    " Plug 'SirVer/ultisnips'
    " Plug 'honza/vim-snippets'

    " Replace vim-airline with a lighter equivalent
    Plug 'itchyny/lightline.vim'

    " List files in directory in vim
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'deoplete-plugins/deoplete-jedi'

    " Tabularize
    Plug 'godlygeek/tabular'

    " Use release branch (Recommend)
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Programming plugins
    " Plug 'fatih/vim-go'            , { 'for': 'go', 'do': ':GoUpdateBinaries'               }
    " Plug 'rust-lang/rust.vim'      , { 'for': ['rust'      , 'rs']                          }
    " Plug 'racer-rust/vim-racer'    , { 'for': ['rust'      , 'rs']                          }

    " Markdown
    Plug 'plasticboy/vim-markdown' , { 'for': 'markdown' }
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

    " Syntax plugins and themes
    " Plug 'PProvost/vim-ps1'        , { 'for': ['ps1'       , 'powershell'         , 'psm1'] }
    Plug 'ekalinin/Dockerfile.vim' , { 'for': ['docker'    , 'Dockerfile']                  }
    Plug 'pearofducks/ansible-vim' , { 'for': ['yaml', 'yml']                               }
    Plug 'arcticicestudio/nord-vim'
    Plug 'morhetz/gruvbox'

    " FZF magic
    Plug 'junegunn/fzf.vim'

    " Distraction-free writing in Vim
    Plug 'junegunn/goyo.vim'

    " Ranger in vim
    Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
    Plug 'jpalardy/vim-slime'

    Plug 'voldikss/vim-floaterm'
    Plug 'liuchengxu/vim-which-key'

    " Vim show indent lines
    " Plug 'Yggdroot/indentLine'

    " NERDTree
    Plug 'preservim/nerdtree'
    " NERDcomment - Comment functions
    Plug 'preservim/nerdcommenter'
    Plug 'ryanoasis/vim-devicons'

    " Install Terraform LSP server
    " Plug 'hashivim/vim-terraform'

call plug#end()

" Load plugins on insert
" augroup load_us_ycm
"   autocmd!
"   autocmd InsertEnter * call plug#load(
"               \'vim-git', 'vim-gitgutter'
"               \)
"                      \| autocmd! load_us_ycm
" augroup END

" Automatically install missing plugins on startup
" autocmd VimEnter *
"   \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"   \|   PlugInstall --sync | q
"   \| endif

