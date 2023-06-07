
## If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Enable colors and change prompt:
autoload -Uz colors && colors

## History in cache directory:
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

## man zshoptions
# setopt HIST_BEEP                 # Beep when accessing nonexistent history.
# setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
# setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt SHARE_HISTORY               # Share history between all sessions.
setopt HIST_VERIFY                 # Don't execute immediately upon history expansion.
setopt HIST_IGNORE_DUPS            # Don't record an entry that was just recorded again.
setopt HIST_EXPIRE_DUPS_FIRST      # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_SPACE           # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS           # Don't write duplicate entries in the history file.
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS          # Remove superfluous blanks before recording entry.
setopt PUSHD_IGNORE_DUPS           # Don't push multiple copies of the same directory onto the directory stack
setopt COMPLETE_ALIASES

## Use colors in man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

## disable the XON/XOFF tty flow feature [ctrl-S|ctrl-Q]
stty -ixon

export LANG=en_US.UTF-8
export BROWSER=firefox
export TERMINAL=alacritty
export VIEW="$EDITOR"
export FZF_DEFAULT_OPTS='--history-size=100000 '
export FZF_CTRL_R_OPTS="--reverse --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
# export TERM=xterm-256color
export PYTHONSTARTUP=~/.pythonrc.py
export GOPATH=$HOME/go

## bspwm java applications problem
export _JAVA_AWT_WM_NONREPARENTING=1
export PYENV_ROOT="$HOME/.pyenv"

##
## set PATH
##
# export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${HOME}/.cargo/bin"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="${PATH}:${GOPATH}/bin"

## Add zsh completions folder
fpath=(~/.zsh/completion $fpath)

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

## enable bash completions in zsh
autoload -U +X bashcompinit && bashcompinit

## ../../ completion
# zstyle ':completion:*' special-dirs true

## avoid ./ and ../ being proposed
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

zmodload zsh/complist
compinit
_comp_options+=(globdots)       # Include hidden files.

## vi mode
bindkey -v
export KEYTIMEOUT=1

## Edit line in vim buffer ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
## Enter vim buffer from normal mode
autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "^v" edit-command-line

## Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
## Fix backspace bug when switching modes
bindkey "^?" backward-delete-char
## search in history
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

## word delimiters
# export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export WORDCHARS='*?_-/.[]~=&;!#$%^(){}<>'
bindkey '^W' backward-kill-word

# Change cursor shape for different vi modes.
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} = '' ]] ||
    [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

## ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done

## ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.
precmd() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

## Control bindings for programs
bindkey -s "^g" "vifm $PWD\n"
# bindkey -s "^o" "open_with_fzf\n"
bindkey -s "^g" "cd_with_fzf\n"
bindkey -s '^o' "bolt --fzf-search\n"
bindkey -s '^s' "bolt --rofi-search\n"

## zsh bindings for HOME and END keys
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

##
## source plugins from oh-my-zsh
## and custom will take precedence
##
zsh_plugins=(
    fzf
    ## custom
    aliases
    directories
    expandalias
    systemd
    # python
    docker
    ssh
    git
    aws-vault
    aws
    terraform
    kubectl
)
ZSH_FULL_PLUGIN_PATHS=(
    "${HOME}/.zsh/plugins/"
    "${HOME}/.zsh/"
)
for PLUGIN_PATH in $ZSH_FULL_PLUGIN_PATHS; do
    for PLUGIN in ${zsh_plugins}; do
        [ -f "${PLUGIN_PATH%/}/${PLUGIN}.zsh" ] && source "${PLUGIN_PATH%/}/${PLUGIN}.zsh" &>/dev/null
    done
done

##
## bash files
##
function source_bash {
    emulate -L bash
    builtin source "$@"
}

bash_config_files=(
    functions
    aliases
)
BASH_FULL_FILE_PATH="${HOME}/.bash/"
for config_file in $bash_config_files; do
    source_bash "${BASH_FULL_FILE_PATH}${config_file}.bash" &>/dev/null
done

if [ -f "$HOME/.zsh_local" ]; then
    source "$HOME/.zsh_local" &>/dev/null
fi

##
## Source other files
##
[[ $(uname -s) =~ Linux ]] && {
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &>/dev/null
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh &>/dev/null
} || true
## macos brew
[[ $(uname -s) =~ Darwin ]] && {
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" &>/dev/null
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" &>/dev/null
} || true

# rebuild compinit with
# rm -f ~/.zcompdump; compinit

## load prompt
# source ~/.zsh/prompt/prompt.zsh
# eval $(/opt/homebrew/bin/brew shellenv zsh)

# setup pyenv
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)" # && eval "$(pyenv init --path)"
fi

## load prompt
# eval "source <(/opt/homebrew/bin/starship init zsh --print-full-init)"
eval "$(starship init zsh)"
