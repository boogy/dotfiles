##
## Terraform
##
function tf_prompt_info() {
  # dont show 'default' workspace in home dir
  [[ "$PWD" != ~ ]] || return
  # check if in terraform dir and file exists
  [[ -d .terraform && -r .terraform/environment ]] || return

  local workspace="$(< .terraform/environment)"
  echo "${ZSH_THEME_TF_PROMPT_PREFIX-[}${workspace:gs/%/%%}${ZSH_THEME_TF_PROMPT_SUFFIX-]}"
}

alias tf='terraform -compact-warnings'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tff='terraform fmt'
alias tfi='terraform init'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfv='terraform validate'

if (( $+commands[terraform] )); then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C terraform terraform
    complete -o nospace -C terragrunt terragrunt
fi

compdef tf='terraform'
setopt tf

##
## Terragrunt
##
function tg_prompt_info() {
    # dont show 'default' workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [ -d .terraform ]; then
      workspace=$(terragrunt workspace show 2> /dev/null) || return
      echo "[${workspace}]"
    fi
}
compdef _terragrunt tg


## ALL
alias tg="terragrunt"
alias tf-plan="terraform plan"
alias tg-plan="terragrunt plan"
alias tf-apply="terraform apply"
alias tg-apply="terragrunt apply"

# shortcut with completions
compdef tf='terraform'
compdef tg='terragrunt'
