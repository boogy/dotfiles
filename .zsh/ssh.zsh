function _sshlist
{
    awk '/^Host [^\*]/{print $2}' ~/.ssh/config
}

function con_x11_ssh
{
    command ssh -X "$@"
}
# compdef '_arguments "0: :($(_sshlist))"' con_x11_ssh

alias ssh='con_x11_ssh' # Rename the tmux session with the hostname
alias key-info="ssh-keygen -lf"
alias del-ssh-key="ssh-keygen -R"

##
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
## auto complete also known_hosts
# if [[ -r ~/.ssh/known_hosts ]]; then
#   h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
# fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:(ssh|scp|rsync):*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

