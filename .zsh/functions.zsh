# Clean python cache and temporary files
pyclean() {
  if command -v fd &>/dev/null; then
    fd -t f -e '*.py[co]' -X rm {} \;
    fd -t d __pycache__ -X rm -r {} \;
    return
  fi
  find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}

# List sub-folders in a given folder
list-sub-folders() {
  FOLDER_NAME="$1"
  DEPTH="${2:-2}"
  fd -d $DEPTH -t d ".*" $FOLDER_NAME
}

# Neovim with ANSI colors removed
ansi-nvim() {
  local FILE="$1"
  sed 's|\x1b\[[;0-9]*m||g' $FILE | nvim -
}

# Clean completions cache
clean-completions() {
  rm ~/.zcompdump*
  autoload -U compinit
  compinit
}

# Open a file or directory using fzf
fzf-open() {
  local selected

  # find command version
  # Build a list of files and directories (skip .git). Adjust -maxdepth or other find args as you like.
  # We print paths relative to current directory.
  # selected=$(
  #   find . -path './.git' -prune -o -print 2> /dev/null \
  #     | sed 's#^\./##' \
  #     | fzf --height=40% --layout=reverse --border \
  #           --preview '[[ -d {} ]] && ls -la --color=always {} || (bat --style=numbers --color=always {} 2>/dev/null || sed -n "1,200p" {})' \
  #           --preview-window='right:50%' \
  #           --pointer='➜' \
  #           --prompt='Open> ' \
  #           --ansi
  # ) || return 0

  # fd command version (faster)
  selected=$(
    fd --hidden --exclude '.git' . 2>/dev/null |
      sed 's#^\./##' |
      fzf --height=40% --layout=reverse --border \
        --preview '[[ -d {} ]] && ls -la --color=always {} || (bat --style=numbers --color=always {} 2>/dev/null || sed -n "1,200p" {})' \
        --preview-window='right:50%' \
        --pointer='➜' \
        --prompt='Open> ' \
        --ansi
  ) || return 0

  # If nothing selected, do nothing
  [[ -z $selected ]] && return 0

  # If it's a directory, cd into it (preserves in current shell)
  if [[ -d $selected ]]; then
    cd -- "$selected" || return $?
  else
    # Otherwise open the file in vim
    nvim -- "$selected"
  fi

  zle reset-prompt # Reset the prompt after opening the file or directory
}
alias fo='fzf-open'
zle -N fzf-open && bindkey '^o' fzf-open
