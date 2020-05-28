## virtualbox shortcuts
vagrant_box_path=$HOME/tools/vagrant/

# _cdf_example(){
#     # _files -/ -W $HOME/tools/vagrant $HOME/dotfiles/deploy/vagrant
#     _arguments -C \
#         "1: :(arg1 arg2)" \
#         "2: :(arg3 arg4)" \
#         "*::arg:->args"
# }

# _complete_vagrant_path(){
#     PTH1=$(ls -d $HOME/dotfiles/deploy/vagrant/*)
#     PTH2=$(ls -d $HOME/tools/vagrant/*)
#     # _arguments '1: :(${$(ls -d $HOME/dotfiles/deploy/vagrant/*)##*/} ${$(ls -d $HOME/tools/vagrant/*)##*/})'
#     _arguments '1: :($(ls -d $HOME/dotfiles/deploy/vagrant/*) $(ls -d $HOME/tools/vagrant/*))'
# }

alias vbox-list-vms="vboxmanage list vms"
alias vbox-list-running="vboxmanage list runningvms"

function _list_vbox_vms_name
{
    vboxmanage list vms|awk -F'"' '{print $2}'
}

function _list_vbox_vms_uuid
{
    vboxmanage list vms|awk '{print $2}'
}

function start-vagrant
{
    USERINPUT=$1
    VBOXES=($(ls -d ${vagrant_box_path}/*))
    for vbox in "${VBOXES[@]##*/}"
    do
        if echo ${USERINPUT}|grep -qEo "^${vbox}$"
        then
            echo "$(tput setaf 2)[+] INFO: starting vm [ ${USERINPUT} ]$(tput sgr0)"
            cd "${vagrant_box_path}/${vbox}"
            vagrant up
            vagrant ssh
            return 0
        fi
    done
    echo "$(tput setaf 1)[!] ERROR: [$USERINPUT] No VM with that name found$(tput sgr0)"
    return 1
}
compdef '_arguments "1: :($(ls ${vagrant_box_path}))"' start-vagrant


function cd-vagrant
{
    USERINPUT=$1
    VBOXES=($(ls -d ${vagrant_box_path}/*))
    for vbox in "${VBOXES[@]##*/}"
    do
        if echo ${USERINPUT}|grep -qEo "^${vbox}$"
        then
            cd "${vagrant_box_path}/${vbox}"
            return 0
        fi
    done
    return 1
}
compdef '_arguments "1: :($(ls ${vagrant_box_path}))"' cd-vagrant

function ssh-vagrant
{
    USERINPUT=$1
    VBOXES=($(ls -d ${vagrant_box_path}/*))
    for vbox in "${VBOXES[@]##*/}"
    do
        if echo ${USERINPUT}|grep -qEo "^${vbox}$"
        then
            echo "$(tput setaf 2)[+] INFO: ssh into [ ${USERINPUT} ]$(tput sgr0)"
            cd "${vagrant_box_path}/${vbox}"
            vagrant ssh
            return 0
        fi
    done
    return 1
}
compdef '_arguments "1: :($(ls ${vagrant_box_path}))"' ssh-vagrant

function vbox-snapshot-vm
{
    local UUID=$1
    local SNAME=$2

    if [ -z $1 ] || [ -z $2 ]; then
        echo "Usage: $0 <uuid|vmname> <snapname>"
        echo "\nAvailable VMs:\n$(vbox-list-vms)"
        return 0
    fi
    vboxmanage snapshot $UUID take $SNAME
}
compdef '_arguments "1: :($(_list_vbox_vms_name))"' vbox-snapshot-vm

function vbox-list-snapshots
{
    local UUID=$1

    if [ -z $1 ]; then
        echo "Usage: $0 <uuid|vmname>"
        echo "\nAvailable VMs:\n$(vbox-list-vms)"
        return 0
    fi
    vboxmanage snapshot $UUID list --details
}
compdef '_arguments "1: :($(_list_vbox_vms_name))"' vbox-list-snapshots

function vbox-restore-snapshot
{
    local UUID=$1
    local SNAPNAME=$2

    if [ -z $1 ]; then
        echo "Usage: $0 <uuid|vmname> <uuid|snapname>"
        echo "\nAvailable VMs:\n$(vbox-list-vms)"
        return 0
    fi
    vboxmanage snapshot $UUID restore $SNAPNAME
}

function vbox-show-vm-info
{
    local UUID=$1
    if [ -z $1 ]; then
        echo "Usage: $0 <uuid|vmname>"
        echo "\nAvailable VMs:\n$(vbox-list-vms)"
        return 0
    fi
    vboxmanage showvminfo $UUID
}
compdef '_arguments "1: :($(_list_vbox_vms_name))"' vbox-show-vm-info

