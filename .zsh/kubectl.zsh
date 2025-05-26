# if (( $+commands[kubectl] )); then
#     autoload -U +X bashcompinit && bashcompinit
#     autoload -U +X compinit && compinit
#     complete -o nospace -C $(which kubectl) kubectl
# fi
# compdef k="kubectl"
# setopt k

# source <(kubectl completion zsh | sed 's/kubectl/k/g')

alias k=kubectl
compdef k='kubectl'

source <(kubectl completion zsh | sed 's/kubectl/k/g')
# complete -o default -F __start_kubectl k

