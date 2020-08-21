#!/usr/bin/env bash

declare options=("\
alacritty
bash
bash-aliases
bash-functions
bspwm
neovim
neovim-plugin
neovim-keys
neovim-coc-settings
picom
polybar
polybar-launch
sxhkd
termite
xresources
zsh
tmux
zsh-aliases
quit"
)


choice=$(echo -e "${options[@]}" | rofi -dmenu -i -markup-rows -no-show-icons -width 1000 -lines 15 -yoffset 40)

case $choice in
    alacritty)
        choice=$HOME/.config/alacritty/alacritty.yml ;;
    bash)
        choice=$HOME/.bashrc ;;
    bash-aliases)
        choice=$HOME/.bash_aliases ;;
    bash-functions)
        choice=$HOME/.bash/functions.bash ;;
    bspwm)
        choice=$HOME/.config/bspwm/bspwmrc ;;
    neovim)
        choice=$HOME/.config/nvim/init.vim ;;
    neovim-plugin)
        choice=$HOME/.config/nvim/vim-plug/plugins.vim ;;
    neovim-keys)
        choice=$HOME/.config/nvim/keys/mappings.vim ;;
    neovim-coc-settings)
        choice=$HOME/.config/nvim/coc-settings.json ;;
    picom)
        choice=$HOME/.config/picom/picom.conf ;;
    polybar)
        choice=$HOME/.config/polybar/config ;;
    polybar-launch)
        choice=$HOME/.config/polybar/launch-polybar.sh ;;
    sxhkd)
        choice=$HOME/.config/sxhkd/sxhkdrc ;;
    termite)
        choice=$HOME/.config/termite/config ;;
    xresources)
        choice=$HOME/dotfiles/.Xresources ;;
    zsh)
        choice=$HOME/.zshrc ;;
    zsh-aliases)
        choice=$HOME/.zsh/aliases.zsh ;;
    tmux)
        choice=$HOME/.tmux.conf ;;
    *)
        exit 1
        ;;
esac

## open the selected file with neovim in a new tmux window
## close the new window once nvim exits
alacritty -e tmux new-window -t WORK \; send-keys -t WORK "nvim $choice; exit" C-m

## open the selected file with neovim in a tmux vertical split
# alacritty -e tmux split-window -h -t WORK \; send-keys -t WORK "nvim $choice; exit" C-m
