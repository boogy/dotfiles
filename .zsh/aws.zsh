# autoload bashcompinit && bashcompinit
# autoload -Uz compinit && compinit
complete -C "$(brew --prefix)/bin/aws_completer" aws

# shortcut completion for aws-vault
alias av="aws-vault"
compdef av='aws-vault'

# Create TABTAB completion for `aws-vault exec` with `ave` alias
unalias ave 2>/dev/null
ave(){ aws-vault exec "$@"; }

# completion for ave: first arg = AWS profile
_ave() {
  emulate -L zsh
  setopt localoptions noglob

  # only complete profiles for the first argument
  if (( CURRENT == 2 )); then
    local cfg="$HOME/.aws/config"
    local -a p

    if command -v rg >/dev/null 2>&1; then
      # [profile NAME] -> NAME
      p=(${(f)"$(
        rg -N --no-heading '^\[profile [^]]+\]$' "$cfg" 2>/dev/null \
          | sed 's/^\[profile //; s/\]$//'
      )"})
    elif command -v sed >/dev/null 2>&1; then
      p=(${(f)"$(sed -n 's/^\[profile \(.*\)\]$/\1/p' "$cfg" 2>/dev/null)"})
    else
      # last resort (should basically never happen on macOS/Linux)
      p=(${(f)"$(
        grep -E '^\[profile .+\]$' "$cfg" 2>/dev/null \
          | grep -Eo '\[profile [^]]+\]' \
          | sed 's/^\[profile //; s/\]$//'
      )"})
    fi

    _describe -t profiles "AWS profiles" p
    return
  fi

  # After the profile, avoid _normal (it can recurse back into _ave)
  if (( CURRENT == 3 )); then
    _command_names
  else
    _files
  fi
}
compdef _ave ave
