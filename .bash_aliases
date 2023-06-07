#!/bin/bash
#
# Main configufation file which also loads
# all the scripts from init
#
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

###
### ACTIVATE SOME BASH MAGIC
###

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Smart handling of multi-line commands
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable extended pattern matching features
shopt -s extglob

# Enable recursive globbing with **.
shopt -s globstar

# When a glob expands to nothing, make it an empty string instead of the literal characters.
# (breaks bash vi mode tab completion)
# shopt -s nullglob

# Enable autocd into directorys
shopt -s autocd

# Enable spelling correction on directory names during word completion
shopt -s dirspell

# vi/emacs mode (man readline)
set -o vi
# set -o emacs
# map Control-l for clear screen in insert mode
bind -m vi-insert "\C-l":clear-screen
bind -m vi-insert "\C-p":history-search-backward
bind -m vi-insert "\C-n":history-search-forward
bind -m vi-insert "\C-a":beginning-of-line
bind -m vi-insert "\C-e":end-of-line
bind -m vi-insert "\C-f":forward-word
bind -m vi-insert "\C-b":backward-word
bind -m vi-insert "\C-d":delete-char

# Activate case insensitive tab completion
bind "set completion-ignore-case on"

# Autocomplete commands for sudo and man
complete -cf sudo man

# stop the pc speaker ever annoying me :)
# setterm -bfreq 0

###
### MISC CONFIGS
###

# Don't do anything for non-interactive shells
# [[ -z "${PS1}"  ]] && return

# set umask
umask 022

## disable the XON/XOFF tty flow feature [ctrl-S|ctrl-Q]
stty -ixon

##### Load all the goods
for config_file in $(ls "${ROOT_DIR}"/.bash/*.bash); do
    # echo -n $config_file
    # time source $config_file
    source $config_file
done

###
### Bash general configurations
###

## Avoid succesive duplicates in the bash command history.
export HISTSIZE=10000
export HISTFILESIZE=200000
export HISTCONTROL=ignoredups:erasedups
export HISTIGNORE="&:l[sal]:kill:mutt:[bf]g:exit:clear"
## preserve history when using multiple terminals
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PYTHONSTARTUP=~/.pythonrc.py

## Use colors in man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Make sure that CC points to a GCC if possible.
# command -v gcc &>/dev/null && export CC=gcc
# command -v vim &>/dev/null && export EDITOR='vim'
# command -v vim &>/dev/null && export VISUAL='vim'

PS1="\[\033[1;32m\][\w]\[\033[0m\]"     # current directory
PS1+="\n\[\033[1;33m\]\h\[\033[0m\]"    # hostname
PS1+="\[\033[1;33m\]\$(git-branch-prompt)\[\033[0m\]" # git branch prompt
PS1+="\[\033[1;33m\] >> \[\033[0m\]"

###
### Linux specific
###
[ $(uname) = "Linux" ] && {
    # Load autojump environment
    test -f /usr/share/autojump/autojump.bash   && source $_ &>/dev/null
    test -f /usr/bin/virtualenvwrapper.sh       && source $_ &>/dev/null
    test -f /usr/share/fzf/key-bindings.bash    && source $_ &>/dev/null
    test -f /usr/share/fzf/completion.bash      && source $_ &>/dev/null

    ## show history from top to bottom
    export FZF_CTRL_R_OPTS='--reverse'

    export PATH="${HOME}/.rvm/bin:${PATH}"
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    export PATH=${PATH}:${HOME}/bin
    export PATH=${PATH}:/home/boogy/.cargo/bin
    export PATH=${PATH}:${HOME}/.local/bin
    export PATH=${PATH}:/opt/homebrew/bin

    # export TERM=screen-256color
    export EDITOR=$(which nvim)
    export VIEW=$(which nvim)

    ## if using rvm load it
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

    ## overwriting option with the local file
    test -f ~/.bash_local && source $_
}
