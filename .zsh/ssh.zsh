alias ssh='con_x11_ssh' # Rename the tmux session with the hostname
alias key-info="ssh-keygen -lf"
alias del-ssh-key="ssh-keygen -R"

function _sshlist
{
    awk '/^Host [^\*]/{print $2}' ~/.ssh/config
}

function con_x11_ssh
{
    command ssh -X "$@"
}
compdef '_arguments "1: :($(_sshlist))"' con_x11_ssh
