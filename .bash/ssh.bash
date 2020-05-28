#!/usr/bin/env bash

alias ssh='con' # Rename the tmux session with the hostname
alias del-ssh-key="ssh-keygen -R"
alias key-info="ssh-keygen -lf"


## ssh agent start smart
function start-ssh-agent
{
    if [ ! -S ~/.ssh/ssh_auth_sock ]; then
      eval `ssh-agent`
      ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    fi
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
    ssh-add -l > /dev/null || ssh-add
}


function ssh-socks-tunnel
{
    local USER=$1
    local HOST=$2
    local PORT=${3:-1080}
    # if test -z $USER -or test -z $HOST; then
    if [ $# -lt 2 ];then
        echo -e "Usage: ${FUNCNAME[0]} <USER> <HOST> <[PORT:1080]>"
        echo -e "\tSSH command to run:"
        echo -e "\tssh -D PORT -f -C -q -N USER@HOST"
    else
        ssh -D $PORT -f -C -q -N ${USER}@${HOST}
    fi
}


function add_ssh() {
    # add entry to ssh config
    # param 1: host
    # param 2: hostname
    # param 3: user
    if [ $# -lt 1 ];then
        echo "Usage:"
        echo " param1: host"
        echo " param2: hostname"
        echo " param3: user"
    else
        echo -en "\n\nHost $1\n  HostName $2\n  User $3\n  ServerAliveInterval 30\n  ServerAliveCountMax 120" >> ~/.ssh/config
    fi
}

function sshlist() {
    # list hosts defined in ssh config
    # awk '$1 ~ /Host$/ { print $2 }' ~/.ssh/config
    awk '/^Host [^\*]/{print $2}' ~/.ssh/config
}

export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}
_sshcomplete() {
    local CURRENT_PROMPT="${COMP_WORDS[COMP_CWORD]}"
    if [[ ${CURRENT_PROMPT} == *@*  ]] ; then
      local OPTIONS="-P ${CURRENT_PROMPT/@*/}@ -- ${CURRENT_PROMPT/*@/}"
    else
      local OPTIONS=" -- ${CURRENT_PROMPT}"
    fi

    # parse all defined hosts from .ssh/config
    if [ -r "$HOME/.ssh/config" ]; then
        COMPREPLY=($(compgen -W "$(grep ^Host "$HOME/.ssh/config" | awk '{print $2}' )" ${OPTIONS}) )
    fi

    # parse all hosts found in .ssh/known_hosts
    if [ -r "$HOME/.ssh/known_hosts" ]; then
        if grep -v -q -e '^ ssh-rsa' "$HOME/.ssh/known_hosts" ; then
            COMPREPLY=( ${COMPREPLY[@]} $(compgen -W "$( awk '{print $1}' "$HOME/.ssh/known_hosts" | grep -v ^\| | cut -d, -f 1 | sed -e 's/\[//g' | sed -e 's/\]//g' | cut -d: -f1 | grep -v ssh-rsa)" ${OPTIONS}) )
        fi
    fi

    # parse hosts defined in /etc/hosts
    if [ -r /etc/hosts ]; then
        COMPREPLY=( ${COMPREPLY[@]} $(compgen -W "$( grep -v '^[[:space:]]*$' /etc/hosts | grep -v '^#' | awk '{print $2}' )" ${OPTIONS}) )
    fi
    return 0
}

complete -o default -o nospace -F _sshcomplete ssh
