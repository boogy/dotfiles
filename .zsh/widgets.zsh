# Replace multiple tokens from the current command line using fzf (loop)
fzf-replace-tokens() {
  emulate -L zsh
  setopt localoptions no_aliases pipefail

  command -v fzf >/dev/null 2>&1 || { zle -M "fzf not found"; return 1; }

  local -a words choices
  local picked idx replacement
  local i

  # Keep looping until user aborts
  while true; do
    words=(${(z)BUFFER})
    (( ${#words} == 0 )) && break

    # Build indexed list (index + TAB + token)
    choices=()
    for i in {1..${#words}}; do
      choices+=("${i}"$'\t'"${words[$i]}")
    done

    zle -I
    picked=$(
      printf '%s\n' "${choices[@]}" |
        fzf --height=40% --reverse \
            --prompt="replace token> " \
            --header=$'Enter: select  Esc/Ctrl-C: done' \
            --delimiter=$'\t' --with-nth=2..
    ) || break

    [[ -n "$picked" ]] || break

    idx="${picked%%$'\t'*}"
    [[ "$idx" == <-> ]] || continue

    # Prompt for replacement
    print -rn -- "Replace '${words[$idx]}' with (empty = skip, Ctrl-C = done): " > /dev/tty
    IFS= read -r replacement < /dev/tty || break

    # Empty => skip this token, continue loop
    [[ -z "$replacement" ]] && continue

    # Quote only if needed
    if [[ "$replacement" == *[[:space:]\;\&\|\<\>\(\)\[\]\{\}\'\"\`\\]* ]]; then
      words[$idx]="${(q)replacement}"
    else
      words[$idx]="$replacement"
    fi

    BUFFER="${(j: :)words}"
    CURSOR=${#BUFFER}
    zle reset-prompt
  done

  zle reset-prompt
}
zle -N fzf-replace-tokens
bindkey -M emacs '^XR' fzf-replace-tokens # CTRL-X Shift-R
bindkey -M viins '^XR' fzf-replace-tokens # CTRL-X Shift-R

# Replace a token from the current command line using fzf
fzf-replace-token() {
  emulate -L zsh
  setopt localoptions no_aliases pipefail

  command -v fzf >/dev/null 2>&1 || { zle -M "fzf not found"; return 1; }

  local -a words choices
  local picked idx replacement
  local i

  # Split BUFFER into shell tokens (respects existing quotes)
  words=(${(z)BUFFER})
  (( ${#words} == 0 )) && return 0

  # Build indexed list (index + TAB + token)
  choices=()
  for i in {1..${#words}}; do
    choices+=("${i}"$'\t'"${words[$i]}")
  done

  # Run fzf cleanly
  zle -I
  picked=$(
    printf '%s\n' "${choices[@]}" |
      fzf --height=40% --reverse --prompt="replace token> " \
          --delimiter=$'\t' --with-nth=2..
  ) || { zle reset-prompt; return 0; }

  [[ -n "$picked" ]] || { zle reset-prompt; return 0; }

  idx="${picked%%$'\t'*}"
  [[ "$idx" == <-> ]] || { zle -M "Bad selection"; zle reset-prompt; return 1; }

  # Ask for replacement via /dev/tty (reliable with ZLE + Ghostty)
  print -rn -- "Replace '${words[$idx]}' with: " > /dev/tty
  IFS= read -r replacement < /dev/tty || { zle reset-prompt; return 0; }
  [[ -z "$replacement" ]] && { zle reset-prompt; return 0; }

  # Quote only if needed (spaces/shell metacharacters)
  if [[ "$replacement" == *[[:space:]\;\&\|\<\>\(\)\[\]\{\}\'\"\`\\]* ]]; then
    words[$idx]="${(q)replacement}"
  else
    words[$idx]="$replacement"
  fi

  # Rebuild without over-quoting everything
  BUFFER="${(j: :)words}"
  CURSOR=${#BUFFER}
  zle reset-prompt
}
zle -N fzf-replace-token
bindkey -M emacs '^Xr' fzf-replace-token # CTRL-X r
bindkey -M viins '^Xr' fzf-replace-token # CTRL-X r

# Jump to word in command line (CTRL-X CTRL-X)
jump-to-word(){
    # BUFFER = entire command line contents
    # CURSOR = current position (0-based offset)
    # ${(z)BUFFER} splits buffer by shell words
    local words=(${(z)BUFFER})

    # Pipe words to fzf for selection
    local target=$(printf '%s\n' "${words[@]}" | fzf --height=10 --reverse)

    # ${BUFFER[(i)$target]} finds index (1-based)
    # CURSOR is 0-based, so substract 1
    [[ -n "$target" ]] && CURSOR=$((${BUFFER[(i)$target]} - 1))

    # Refresh display after modifying CURSOR
    zle redisplay
}
zle -N jump-to-word # Register widget
bindkey '^X^X' jump-to-word # (CTRL-X CTRL-X)

# Fuzzy open (ALT-c): cd into dirs, open files in vim
fzf-open-widget() {
  emulate -L zsh
  setopt localoptions no_aliases

  local root="${1:-$PWD}"
  local target

  root="${root/#\~/$PWD}"

  target="$(
    command find "$root" \
      \( -path '*/.*' -o -path '*/.git' -o -path '*/node_modules' -o -path '*/.terraform' \) -prune -o \
      \( -type d -o -type f \) -print 2>/dev/null \
    | fzf --height=40% --reverse --prompt="open> " \
          --bind 'esc:abort,ctrl-c:abort' \
          --preview-window 'right:60%:wrap' \
          --preview '
            p="{}"
            if [[ -d "$p" ]]; then
              if command -v eza >/dev/null 2>&1; then
                eza -la --color=always --group-directories-first "$p" 2>/dev/null | head -200
              else
                ls -la "$p" 2>/dev/null | head -200
              fi
            else
              if command -v bat >/dev/null 2>&1; then
                bat --style=numbers --color=always "$p" 2>/dev/null | head -200
              else
                sed -n "1,200p" "$p" 2>/dev/null
              fi
            fi
          '
  )" || { zle reset-prompt; return 0; }

  [[ -n "$target" ]] || { zle reset-prompt; return 0; }

  if [[ -d "$target" ]]; then
    builtin cd -- "$target" || { zle -M "cd failed: $target"; zle reset-prompt; return 1; }
  elif [[ -f "$target" ]]; then
    # Use vim explicitly; change to ${EDITOR:-vim} if you prefer
    nvim "$target"
  else
    zle -M "Not found: $target"
  fi

  zle reset-prompt
}
zle -N fzf-open-widget
bindkey '^F' fzf-open-widget # (CTRL-F)

# Edit file with fzf (CTRL-X CTRL-E)
# Edits a file selected from fzf. Uses fd or find to list files, excluding .git.
# The preview window shows the contents of the selected file using bat or head.
# fzf-edit-file() {
#   local file
#   file=$(
#     (command fd --type f --hidden --follow --exclude .git . 2>/dev/null || command find . -type f 2>/dev/null) \
#     | fzf --height=40% --reverse --prompt="edit> " \
#           --preview 'f={}; (command bat --style=numbers --color=always "$f" || sed -n "1,200p" "$f") 2>/dev/null'
#   ) || return

#   [[ -n "$file" ]] && ${EDITOR:-vi} "$file"
#   zle redisplay
# }
# zle -N fzf-edit-file
# bindkey '^X^E' fzf-edit-file

# fzf-history-insert() {
#   local selected
#   selected=$(
#     fc -rl 1 \
#     | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//' \
#     | awk '!seen[$0]++' \
#     | fzf --height=40% --reverse --prompt="history> " \
#           --preview 'echo {}' \
#           --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy || true)+abort'
#   ) || return

#   BUFFER="$selected"
#   CURSOR=${#BUFFER}
#   zle redisplay
# }
# zle -N fzf-history-insert
# bindkey '^R' fzf-history-insert

# Kill process fuzzy search (CTRL-X k)
fzf-kill-process() {
  local pids
  pids=$(
    ps -u "$USER" -o pid=,etime=,command= \
    | fzf --height=50% --reverse --multi --prompt="kill> " \
          --preview 'echo {}' \
    | awk '{print $1}'
  ) || return

  [[ -n "$pids" ]] && echo "$pids" | xargs kill -TERM
  zle redisplay
}
zle -N fzf-kill-process
bindkey '^Xk' fzf-kill-process # (CTRL-X k)

# Git checkout branch fuzzy search (CTRL-X g)
fzf-git-checkout-branch() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local branch
  branch=$(
    (git for-each-ref --format='%(refname:short)' refs/heads refs/remotes 2>/dev/null \
      | sed 's#^origin/##' \
      | awk '!seen[$0]++') \
    | fzf --height=40% --reverse --prompt="git checkout> " \
          --preview 'git log --oneline --decorate -20 {} 2>/dev/null'
  ) || return

  [[ -n "$branch" ]] && BUFFER="git checkout ${(q)branch}" && CURSOR=${#BUFFER}
  zle redisplay
}
zle -N fzf-git-checkout-branch
bindkey '^Xg' fzf-git-checkout-branch # (CTRL-X g)

# Fuzzy search in files with rg (CTRL-X f)
fzf-rg-open() {
  local q="${1:-}"
  local result
  result=$(
    rg --line-number --no-heading --color=always "${q:-.}" 2>/dev/null \
    | fzf --ansi --height=60% --reverse --prompt="rg> " \
          --preview 'line=$(echo {} | cut -d: -f2); file=$(echo {} | cut -d: -f1); (bat --color=always --style=numbers --highlight-line "$line" "$file" || sed -n "1,200p" "$file") 2>/dev/null'
  ) || return

  local file line
  file="$(echo "$result" | cut -d: -f1)"
  line="$(echo "$result" | cut -d: -f2)"
  [[ -n "$file" && -n "$line" ]] && ${EDITOR:-vi} +"${line}" "$file"
  zle redisplay
}
zle -N fzf-rg-open
bindkey '^Xf' fzf-rg-open # (CTRL-X f)

# Switch kube context (CTRL-X c)
fzf-kube-context() {
  command -v kubectl >/dev/null 2>&1 || return
  local ctx
  ctx=$(kubectl config get-contexts -o name 2>/dev/null | fzf --height=40% --reverse --prompt="kube ctx> ") || return
  [[ -n "$ctx" ]] && kubectl config use-context "$ctx" >/dev/null
  zle reset-prompt
}
zle -N fzf-kube-context
bindkey '^Xc' fzf-kube-context # (CTRL-X c)

# fzf-kube-namespace() {
#   command -v kubectl >/dev/null 2>&1 || return
#   local ns
#   ns=$(kubectl get ns -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null \
#       | fzf --height=40% --reverse --prompt="kube ns> ") || return
#   [[ -n "$ns" ]] && kubectl config set-context --current --namespace="$ns" >/dev/null
#   zle reset-prompt
# }
# zle -N fzf-kube-namespace
# bindkey '^Xn' fzf-kube-namespace

# fzf-aws-profile() {
#   command -v awk >/dev/null 2>&1 || return
#   local profiles profile

#   profiles=$(
#     (grep -hE '^\[profile ' ~/.aws/config 2>/dev/null | sed -E 's/^\[profile ([^]]+)\]/\1/' ; \
#      grep -hE '^\[[^]]+\]' ~/.aws/credentials 2>/dev/null | sed -E 's/^\[([^]]+)\]/\1/') \
#     | awk 'NF' | awk '!seen[$0]++'
#   ) || return

#   profile=$(printf '%s\n' "$profiles" | fzf --height=40% --reverse --prompt="AWS_PROFILE> ") || return
#   [[ -n "$profile" ]] && export AWS_PROFILE="$profile"
#   zle reset-prompt
# }
# zle -N fzf-aws-profile
# bindkey '^Xa' fzf-aws-profile

# Fuzzy aws-vault profile exec (CTRL-X a) — uses rg
fzf-aws-vault-exec() {
  emulate -L zsh
  setopt localoptions no_aliases

  command -v aws-vault >/dev/null 2>&1 || {
    zle -M "aws-vault not found"
    return 1
  }

  command -v rg >/dev/null 2>&1 || {
    zle -M "ripgrep (rg) not found"
    return 1
  }

  local profiles profile

  profiles=$(
    {
      # ~/.aws/config → [profile foo]
      rg --no-heading --only-matching \
         '^\[profile ([^]]+)\]' ~/.aws/config 2>/dev/null \
        | sed 's/^\[profile //; s/\]//'

      # ~/.aws/credentials → [foo]
      rg --no-heading --only-matching \
         '^\[([^]]+)\]' ~/.aws/credentials 2>/dev/null \
        | sed 's/^\[//; s/\]//'
    } | awk 'NF' | awk '!seen[$0]++'
  ) || return

  profile="$(
    printf '%s\n' "$profiles" \
      | fzf --height=40% --reverse --prompt="aws-vault exec> "
  )" || { zle reset-prompt; return 0; }

  [[ -n "$profile" ]] || { zle reset-prompt; return 0; }

  zle reset-prompt
  echo "🔐 aws-vault exec $profile"

  # Spawn authenticated subshell (this is required)
  aws-vault exec "$profile" -- zsh -i
}
zle -N fzf-aws-vault-exec
bindkey '^Xp' fzf-aws-vault-exec # (CTRL-X p)

# Insert a snippet (CTRL-X s)
insert-snippet() {
  local snippet
  snippet=$(
    cat <<'EOF' | fzf --height=40% --reverse --prompt="snippet> "
aws --no-cli-pager --output json
kubectl get -o yaml
| jq -r '.'
terraform show -json | jq .
rg --hidden --glob '!.git/*'
fd --type f --hidden --follow --exclude .git .
EOF
  ) || return

  LBUFFER+="$snippet"
  zle redisplay
}
zle -N insert-snippet
bindkey '^Xs' insert-snippet # (CTRL-X s)

# ------------------------------------------------------------
# Refactor mode: replace tokens repeatedly using fzf
# In fzf:
#   Tab        -> select token to replace
#   Enter      -> replace one occurrence
#   Esc/Ctrl-C -> quit
# Fast refactor mode (Ctrl-X h): multi-select tokens and replace them
fzf-refactor-fast() {
  emulate -L zsh
  setopt localoptions no_aliases pipefail

  command -v fzf >/dev/null 2>&1 || { zle -M "fzf not found"; return 1; }

  local -a words choices selected_lines
  local tmp out line idx token replacement
  local i

  _rf_quote_if_needed() {
    local s="$1"
    if [[ "$s" == *[[:space:]\;\&\|\<\>\(\)\[\]\{\}\'\"\`\\]* ]]; then
      print -r -- "${(q)s}"
    else
      print -r -- "$s"
    fi
  }

  words=(${(z)BUFFER})
  if (( ${#words} == 0 )); then
    zle -M "No command to refactor (type a command first)"
    return 0
  fi

  choices=()
  for (( i=1; i<=${#words}; i++ )); do
    choices+=("${i}"$'\t'"${words[$i]}")
  done

  # Write candidates to a temp file (makes fzf fast+stable in ZLE/ghostty)
  tmp="$(mktemp -t zsh-fzf-refactor.XXXXXX)" || return 1
  {
    printf '%s\n' "${choices[@]}"
  } >| "$tmp"

  zle -I
  # Override heavy global FZF_DEFAULT_OPTS (previews/etc.) for speed
  out="$(
    FZF_DEFAULT_OPTS='' \
    fzf --height=50% --reverse --multi \
        --prompt="refactor> " \
        --header=$'TAB=mark | ENTER=apply | ESC=quit' \
        --delimiter=$'\t' --with-nth=2.. \
        < "$tmp"
  )"

  rm -f -- "$tmp"

  [[ -n "$out" ]] || { zle reset-prompt; return 0; }

  selected_lines=("${(@f)out}")
  (( ${#selected_lines} == 0 )) && { zle reset-prompt; return 0; }

  # Replace each selected token
  for line in "${selected_lines[@]}"; do
    idx="${line%%$'\t'*}"
    [[ "$idx" == <-> ]] || continue

    token="${words[$idx]}"
    print -rn -- "Replace '$token' with (empty=skip): " > /dev/tty
    IFS= read -r replacement < /dev/tty || break
    [[ -z "$replacement" ]] && continue

    words[$idx]="$(_rf_quote_if_needed "$replacement")"
  done

  BUFFER="${(j: :)words}"
  CURSOR=${#BUFFER}
  zle reset-prompt
}
zle -N fzf-refactor-fast
bindkey -M emacs '^Xh' fzf-refactor-fast # CTRL-X h
bindkey -M viins '^Xh' fzf-refactor-fast # CTRL-X h
