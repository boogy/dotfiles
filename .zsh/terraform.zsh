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

alias tg='terragrunt --terragrunt-forward-tf-stdout'
alias tf='terraform'
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
setopt tg

## ALL
alias tf-plan="terraform plan -compact-warnings"
alias tg-plan="terragrunt plan -compact-warnings"
alias tf-apply="terraform apply -compact-warnings"
alias tg-apply="terragrunt apply -compact-warnings"
alias tga="terragrunt apply -compact-warnings"
alias av="aws-vault"
alias ave="aws-vault exec"

alias tf-init-all="terragrunt run-all init -compact-warnings --terragrunt-forward-tf-stdout --terragrunt-non-interactive"
alias tf-plan-all="terragrunt run-all plan -compact-warnings --terragrunt-forward-tf-stdout --terragrunt-non-interactive"
alias tf-apply-all="terragrunt run-all apply -compact-warnings --terragrunt-forward-tf-stdout --terragrunt-non-interactive"

# shortcut with completions
compdef tf='terraform'
compdef tg='terragrunt'
compdef av='aws-vault'

# use same completion as terraform
# complete -o nospace -C terraform tf
# complete -o nospace -C terragrunt tg
complete -o nospace -C /opt/homebrew/bin/terragrunt -C /opt/homebrew/bin/terraform tg

