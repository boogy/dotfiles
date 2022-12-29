# autoload bashcompinit && bashcompinit
# autoload -Uz compinit && compinit

complete -C "$(brew --prefix)/bin/aws_completer" aws
