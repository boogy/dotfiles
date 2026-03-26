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

# Open browser to the current repository
repo() {
  local base
  base=$(git remote get-url origin) || return 1

  if [[ $base == git@* ]]; then
    base=${base#git@}          # remove leading git@
    base=${base/:/\/}          # github.com/user/repo.git
    base="https://$base"       # https://github.com/user/repo.git
  elif [[ $base == http://* || $base == https://* ]]; then
    :
  else
    echo "Don't know how to handle remote URL: $base" >&2
    return 1
  fi

  base=${base%.git}

  case "$1" in
    issues) open "$base/issues" ;;
    pr|prs|pulls) open "$base/pulls" ;;
    *) open "$base" ;;
  esac
}

# Show a list of all repos in the folder and fuzyfind the one to open in broweser
repobrowse() {
  local mode root selection repo remote url browser_cmd

  mode="${1:-repo}"
  root="${2:-$PWD}"

  selection=$(
    {
      fd --hidden --follow --type d '^\.git$' "$root" 2>/dev/null
      fd --hidden --follow --type f '^\.git$' "$root" 2>/dev/null
    } |
    while IFS= read -r git_path; do
      repo_path=$(git -C "$(dirname "$git_path")" rev-parse --show-toplevel 2>/dev/null) || continue
      printf '%s\t%s\n' "$(basename "$repo_path")" "$repo_path"
    done |
    sort -u |
    fzf --prompt="repo> " \
        --height=40% \
        --reverse \
        --with-nth=1
  ) || return 1

  repo=$(printf '%s\n' "$selection" | cut -f2-)

  remote=$(git -C "$repo" remote get-url origin 2>/dev/null) || {
    echo "No origin remote found for: $repo" >&2
    return 1
  }

  case "$remote" in
    git@github.com:*)
      url="https://github.com/${remote#git@github.com:}"
      ;;
    https://github.com/*)
      url="$remote"
      ;;
    http://github.com/*)
      url="https://${remote#http://}"
      ;;
    *)
      echo "Unsupported remote: $remote" >&2
      return 1
      ;;
  esac

  url=${url%.git}

  case "$mode" in
    repo) ;;
    issues) url="$url/issues" ;;
    pr|prs|pulls) url="$url/pulls" ;;
    *)
      echo "Usage: repobrowse [repo|issues|pulls] [root]" >&2
      return 1
      ;;
  esac

  if command -v open >/dev/null 2>&1; then
    browser_cmd=open
  else
    browser_cmd=xdg-open
  fi

  "$browser_cmd" "$url"
}

