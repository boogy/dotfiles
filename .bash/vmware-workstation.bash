#!/usr/bin/env bash
#
# Description: Create a linked clone from a vmware template
#  get ip from interface:
#       ip -4 addr show eth1| grep -oP '(?<=inet\s)\d+(\.\d+){3}'
#
#  get all running vms ips:
#       for GUEST in $(vmrun list|sed '/Total/d'); do vmrun -T ws getGuestIPAddress $GUEST; done
#

## Server default private ip: 192.168.48.129

## WORK IN PROGRESS
## SCRIPT IS NOT STABLE

_vmrun_vm_complete()
{
    COMPREPLY=()
    local cur_arg=${COMP_WORDS[COMP_CWORD],,}
    local prev_arg=${COMP_WORDS[COMP_CWORD-1],,}
    local vms=$(find ~/Documents/VMs -type f -iname *.vmx 2>/dev/null | while read line; do basename "$line"; done | tr [:upper:] [:lower:])

    if [[ $cur_arg == -* ]]; then
        COMPREPLY=($( compgen -W "--name --template-name --start-gui" -- $cur_arg ) )
    else
        case $prev_arg in
            --name)
                complete_words="clone_windows clone_linux"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --start-gui)
                complete_words="gui nogui"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --template-name)
                complete_words=$vms
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --ssh)
                complete_words="true false"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            *) ;;
        esac
    fi
}


_vmrun_list_running_vms_complete()
{
    COMPREPLY=()
    local cur_arg=${COMP_WORDS[COMP_CWORD],,}
    local prev_arg=${COMP_WORDS[COMP_CWORD-1],,}
    COMPREPLY=($( compgen -W "$(vmrun list|sed '/Total/d')" -- $cur_arg ) )
}


_print_help()
{
    echo -e "\nUsage: $1 [--name (Default: CloneUbuntuServer)] [--start-gui (Default: true)] [--ssh (Default: true)]\n"
}


run-program-in-guest()
{
    local USERNAME PASSWORD
    read -p "Username: " USERNAME
    echo -n "Password: "
    read -s PASSWORD
    vmrun -T ws -gu $GUEST_USER -gp $GUEST_PASS runProgramInGuest $GUEST_VMX_IMG $GUEST_COMMAND
}


get_vm_ip_address()
{
    vmrun -T ws getGuestIPAddress $1
}


stop-vm()
{
    vmrun -T ws stop $1

}
complete -F _vmrun_list_running_vms_complete stop-vm


clone-linked-vm()
{
    local VMS_PATH=$HOME/Documents/VMs
    local TEMPLATE_NAME=Ubuntu_16_04
    local NEW_LINKED_VM_NAME=Clone_${TEMPLATE_NAME}
    local LAUNCH_WITH_NO_GUI=gui
    local SSH_TO_VM="true"

    if [[ $1 =~ ^(-h|-H|--help|help)$ ]]; then
        _print_help ${FUNCNAME[0]}
    else
        while [[ $# -gt 1 ]]
        do
            case "${1}" in
                --path)
                    [ -n $2 ] && VMS_PATH=$2
                    shift
                    ;;
                --name)
                    [ -n $2 ] && NEW_LINKED_VM_NAME=$2
                    shift
                    ;;
                --template-name)
                    [ -n $2 ] && TEMPLATE_NAME=${2%%.*}
                    shift
                    ;;
                --start-gui)
                    [ -n $2 ] && LAUNCH_WITH_NO_GUI=$2
                    shift
                    ;;
                *)
                    echo "$(tput setaf 1)[!] Wrong option ${2}$(tput sgr0)"
                    _print_help
                    return 1
                    ;;
            esac
            shift
        done
    fi

    ## This will convert the first letter to uppercase ## ${VAR_NAME^} ##
    local FULL_TEMPLATE_NAME=$VMS_PATH/${TEMPLATE_NAME^}/${TEMPLATE_NAME^}.vmx
    local FULL_NEW_VM_NAME=$VMS_PATH/$NEW_LINKED_VM_NAME/$NEW_LINKED_VM_NAME.vmx

    ## create the linked clone
    echo "[*] Using template ${FULL_TEMPLATE_NAME}"
    vmrun -T ws clone "${FULL_TEMPLATE_NAME}" "${FULL_NEW_VM_NAME}" linked -cloneName=$NEW_LINKED_VM_NAME

    ## check if the vm is running and return it's ip address
    if [[ $? -eq 0 ]]; then
        echo "[*] Starting vm: $NEW_LINKED_VM_NAME"
        echo "[*] Path of vm : $FULL_NEW_VM_NAME"
        echo -en "\n[*] Run command: \n\tvmrun -T ws start $FULL_NEW_VM_NAME $LAUNCH_WITH_NO_GUI"

        vmrun -T ws start $FULL_NEW_VM_NAME $LAUNCH_WITH_NO_GUI && echo

        if [[ $? -eq 0 ]]; then
            echo "[*] VM started successfuly"
        fi
    fi
    # if [[ $SSH_TO_VM =~ ^true$ ]]; then
    #     ssh $(get_vm_ip_address $FULL_NEW_VM_NAME)
    # fi
}
complete -F _vmrun_vm_complete clone-linked-vm


list-vms-ips()
{
    for GUEST in $(vmrun list|sed '/Total/d'); do
        echo "$(vmrun -T ws getGuestIPAddress $GUEST) | $GUEST"
    done
}


##
## Manage VMs with VMWare Workstation
##

function vm-manage-workstation
{
    local -r VM_NAME=$2
    case "$3" in
        start)
            vmrun -T ws start $VM_NAME nogui
            ;;
        startx)
            vmrun -T ws start $VM_NAME gui
            ;;
        stop)
            vmrun -T ws stop $VM_NAME
            ;;
        snapshot|snap)
            # vmrun -T ws snapshot $VM_NAME CleanSnapshot
            vmrun -T ws snapshot $VM_NAME "${3}"
            ;;
        revert)
            # vmrun -T ws revertToSnapshot $VM_NAME CleanSnapshot
            vmrun -T ws revertToSnapshot $VM_NAME "${3}"
            ;;
        deleteSnapshot)
            # vmrun -T ws deleteSapshot $VM_NAME CleanSnapshot
            vmrun -T ws deleteSapshot $VM_NAME "${3}"
            ;;
        *)
            echo "Usage $1 [ start | startx | stop | (snapshot|snap)<snapshot name> | revert <snapshot name>| deleteSnapshot <snapshot name>]"
            echo
            ;;
    esac
}


function vm-kali
{
    local -r VM_NAME="$HOME/Documents/VMs/Kali-Linux-2016.2-vm-amd64/Kali-Linux-2016.2-vm-amd64.vmx"
    vm-manage-workstation ${FUNCNAME[0]} $VM_NAME $@
}


function vm-windows-legit
{
    local -r VM_NAME="$HOME/Documents/VMs/Legit_Windows_10/Legit_Windows_10.vmx"
    vm-manage-workstation ${FUNCNAME[0]} $VM_NAME $@
}


function vm-windows
{
    local -r VM_NAME="$HOME/Documents/VMs/Windows_10_x64/Windows_10_x64.vmx"
    vm-manage-workstation ${FUNCNAME[0]} $VM_NAME $@
}


function vm-ubuntu
{
    local -r VM_NAME="$HOME/Documents/VMs/Ubuntu_16_04/Ubuntu_16_04.vmx"
    vm-manage-workstation ${FUNCNAME[0]} $VM_NAME $@
}


