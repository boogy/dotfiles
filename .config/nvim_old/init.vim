let g:is_nvim = has('nvim')
let g:is_vim8 = v:version >= 800 ? 1 : 0

" Reuse nvim's runtimepath and packpath in vim
if !g:is_nvim && g:is_vim8
  set runtimepath-=~/.vim
    \ runtimepath^=~/.local/share/nvim/site runtimepath^=~/.vim
    \ runtimepath-=~/.vim/after
    \ runtimepath+=~/.local/share/nvim/site/after runtimepath+=~/.vim/after
  let &packpath = &runtimepath
endif

" Load plugins
source $HOME/.config/nvim/vim-plug/plugins.vim

" Source our configurations
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/autocmds.vim
source $HOME/.config/nvim/general/functions.vim

" Mappings
source $HOME/.config/nvim/keys/mappings.vim

" Plugin options
source $HOME/.config/nvim/plug-config/ale.vim
source $HOME/.config/nvim/plug-config/coc.vim
source $HOME/.config/nvim/plug-config/coc-snippets.vim
source $HOME/.config/nvim/plug-config/coc-highlight.vim
source $HOME/.config/nvim/plug-config/coc-explorer.vim
source $HOME/.config/nvim/plug-config/vim-slime.vim
source $HOME/.config/nvim/plug-config/vim-visual-multi.vim
source $HOME/.config/nvim/plug-config/vim-gitgutter.vim
source $HOME/.config/nvim/plug-config/fzf.vim
source $HOME/.config/nvim/plug-config/markdown.vim
source $HOME/.config/nvim/plug-config/markdown-preview.vim
source $HOME/.config/nvim/plug-config/ansible.vim
source $HOME/.config/nvim/plug-config/rust.vim
source $HOME/.config/nvim/plug-config/goyo.vim
source $HOME/.config/nvim/plug-config/rnvimr.vim
source $HOME/.config/nvim/plug-config/floaterm.vim
source $HOME/.config/nvim/plug-config/which-key.vim
source $HOME/.config/nvim/plug-config/indentLine.vim
source $HOME/.config/nvim/plug-config/NerdTree.vim
source $HOME/.config/nvim/plug-config/nerdcommenter.vim
source $HOME/.config/nvim/plug-config/fern.vim
source $HOME/.config/nvim/plug-config/vim-racer.vim
source $HOME/.config/nvim/plug-config/vim-lsp.vim
source $HOME/.config/nvim/plug-config/asyncomplete.vim

" Themes
source $HOME/.config/nvim/themes/gruvbox.vim
source $HOME/.config/nvim/themes/lightline.vim
" source $HOME/.config/nvim/themes/material-monokai.vim
" source $HOME/.config/nvim/themes/onedark.vim

