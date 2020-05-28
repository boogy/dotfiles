export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="mm/dd/yyyy"
# ZSH_CUSTOM=$HOME/.zsh/

plugins=(
    vi-mode
    sudo
    ssh-agent
    autojump
    fzf
    virtualenvwrapper
)
source $ZSH/oh-my-zsh.sh

##
## User config
##

# fpath=($HOME/.zsh/completions $fpath)
# enable autocomplete function
# autoload -U compinit && compinit

HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

# man zshoptions
# setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
# setopt HIST_BEEP                 # Beep when accessing nonexistent history.
# setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
# setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
# setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
# setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
# setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
# setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
# setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS           # Don't write duplicate entries in the history file.
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS          # Remove superfluous blanks before recording entry.
setopt PUSHD_IGNORE_DUPS           # Don't push multiple copies of the same directory onto the directory stack

## disable the XON/XOFF tty flow feature [ctrl-S|ctrl-Q]
stty -ixon
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PATH=${PATH}:${HOME}/bin
export PATH=${PATH}:/home/boogy/.cargo/bin
export PATH=${PATH}:${HOME}/.local/bin
#export PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"

export LANG=en_US.UTF-8
# export EDITOR='vim'
export VIEW="$EDITOR"
export FZF_DEFAULT_OPTS='--history-size=100000 '
export FZF_CTRL_R_OPTS="--reverse --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export TERM=xterm-256color

export PYTHONSTARTUP=~/.pythonrc.py
# export PYTHONSTARTUP="$(python -m jedi repl)"

zsh_custom_files=(
    directories
    expandalias
    virtualbox
    systemd
    aliases
    prompt
    python
    docker
    ssh
)
ZSH_FULL_FILE_PATH="${HOME}/.zsh/"
for zsh_config_file in $zsh_custom_files; do
    source "${ZSH_FULL_FILE_PATH}/${zsh_config_file}.zsh" &>/dev/null
done

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh &>/dev/null

## bash files
##
function source_bash {
    emulate -L bash
    builtin source "$@"
}

bash_config_files=(
    functions
    python
    aliases
    git
)
BASH_FULL_FILE_PATH="${HOME}/.bash/"
for config_file in $bash_config_files; do
    source_bash "${BASH_FULL_FILE_PATH}/${config_file}.bash" &>/dev/null
done

if [ -f "$HOME/.zsh_local" ]; then
    source $HOME/.zsh_local
fi

if [ -f "$HOME/.bash_local" ]; then
    source_bash $HOME/.bash_local
fi
