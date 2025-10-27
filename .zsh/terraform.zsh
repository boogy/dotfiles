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

# alias tg='terragrunt --terragrunt-forward-tf-stdout'
# alias tg='terragrunt --tf-forward-stdout'
alias tg='terragrunt'
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

# Terraform
alias tf-plan="terraform plan -compact-warnings"
alias tf-apply="terraform apply -compact-warnings"
alias tf-destroy="terraform destroy -compact-warnings"

# Terragrunt
alias tg-plan="terragrunt run --tf-forward-stdout -- plan -compact-warnings"
alias tg-apply="terragrunt run --tf-forward-stdout -- apply -compact-warnings"
alias tg-apply="terragrunt run --tf-forward-stdout -- destroy -compact-warnings"
alias tga="terragrunt run --tf-forward-stdout -- apply -compact-warnings"

alias av="aws-vault"
alias ave="aws-vault exec"

alias tg-init-all="terragrunt run --all init --tf-forward-stdout --non-interactive"
alias tg-plan-all="terragrunt run --all plan --tf-forward-stdout --non-interactive"
alias tg-apply-all="terragrunt run --all apply --tf-forward-stdout --non-interactive"

function tg-plan-parallel (){
  terragrunt run plan \
    --compact-warnings \
    --non-interactive \
    --parallelism 10 \
    --tf-forward-stdout "$@"
}

function tg-apply-parallel (){
  terragrunt run apply \
    --compact-warnings \
    --non-interactive \
    --parallelism 10 \
    --tf-forward-stdout "$@"
}

# shortcut with completions
compdef tf='terraform'
compdef tg='terragrunt'
compdef av='aws-vault'

# use same completion as terraform
# complete -o nospace -C terraform tf
# complete -o nospace -C terragrunt tg
complete -o nospace -C /opt/homebrew/bin/terragrunt -C /opt/homebrew/bin/terraform tg

tg() {
    terragrunt --terragrunt-forward-tf-stdout "$@"
}
compdef tg=terragrunt

