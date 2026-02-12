# autoload bashcompinit && bashcompinit
# autoload -Uz compinit && compinit
complete -C "$(brew --prefix)/bin/aws_completer" aws

# shortcut completion for aws-vault
alias av="aws-vault"
compdef av='aws-vault'

# Create TABTAB completion for `aws-vault exec` with `ave` alias
unalias ave 2>/dev/null
ave() { aws-vault exec "$@"; }

# completion for ave: reuse aws-vault's profile list
_ave() {
  if (( CURRENT == 2 )); then
    local -a profiles
    IFS=$'\n'
    profiles=($(aws-vault list --profiles 2>/dev/null))
    _describe 'PROFILE' profiles
  elif (( CURRENT == 3 )); then
    _command_names
  else
    _files
  fi
}
compdef _ave ave

