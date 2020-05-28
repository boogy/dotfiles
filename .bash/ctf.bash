#!/usr/bin/env bash
#
# Some useful functions to make life easyer
# for reversing / pwning stuff
#

alias gdb='gdb -q'
alias disable_aslr_on_bin='setarch `uname -m` -R'
alias print_got="objdump --dynamic-reloc"
alias update_radare2="sudo ~/tools/radare2/sys/install.sh"
alias valgrind_memcheck="valgrind --tool=memcheck --leak-check=yes"

# CTF python templates
function init-pwn-template
{
    cp ~/bin/pwn-template.py $1
}

function get-func-offset
{
    if test -z $1; then
        echo "Usage: $0 <binary file> <function name>"
        return 0
    fi
    readelf -s $1|grep $2
}

function get-str-offset
{
    if test -z $1; then
        echo "Usage: $0 <binary file> <string>"
        return 0
    fi
    strings -a -tx $1|grep $2
}

function socat-strace
{
    if test -z $1 && test ! -f $1; then
        echo "Usage:"
        echo "  socat_strace [/path/to/binary] [port number to listen (default:2323)]"
    else
        local PORT=${2:-"2323"}
        socat TCP-LISTEN:${PORT},reuseaddr,fork EXEC:"strace -f ${1}"
    fi
}

function socat-run
{
    if test -z $1 && test ! -f $1; then
        echo "Usage: socat_run /path/to/binary [port number to listen (default:2323)]"
    else
        local PORT=${2:-"2323"}
        socat TCP-LISTEN:${PORT},reuseaddr,fork EXEC:"${1}"
    fi
}

function get-shellcode
{
    local sc=$(objdump -d $1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')
    echo -en "Lenght of shellcode: " && echo "$((${#sc}/2/2))" && echo $sc
}

function dis-shellcode
{
    if echo $1 | grep -qo "h\|help"; then
        echo "Usage:"
        echo "  dis-shellcode binfile [arch (x86)] [bits (64)]"
        echo "Example:"
        echo "  dis-shellcode binfile x86 32"
    else
        get_shellcode ${1} | grep -Eo "[a-f0-9]*" | xargs echo -en | tr -d "[ ]" | rasm2 -D -a ${2:-"x86"} -b ${3:-"64"} -
    fi
}

function comile-shared-lib
{
    local FILE_NAME="${1%.*}"
    local FILE_EXTE="${1##*.}"
    gcc -Wall -fPIC -shared -o $FILE_NAME.so $FILE_NAME.c
}

function gdbserver-local
{
    if echo $1|grep -qo "h\|help"; then
        echo "Usage:"
        echo "  $0 [host] [port]"
        echo
    fi
    local HOST=${2:-localhost}
    local PORT=${3:-23946}
    echo "Running gdbserver:"
    echo "Host  : $HOST"
    echo "Port  : $PORT"
    echo "Binary: $1"
    gdbserver $HOST:$PORT $1
}

function run-gdbserver-with-lib
{
    if echo $1|grep -qo "h\|help"; then
        echo "Usage:"
        echo "  $0 [library] [program]"
        echo
    fi
    gdbserver --wrapper env LD_PRELOAD=$1 -- :23946 ./$2
}

function ctfbox
{
    local usage="Usage: $FUNCNAME [-n <ctf_name>] [-s <shared_folders>]"
    local OPTIND OPT SHAREDF CTFNAME HELP
    while getopts ":n:s:" OPT; do
        case "${OPT}" in
            s) SHAREDF="${OPTARG}";;
            n) CTFNAME="${OPTARG}";;
            *) echo $usage;;
        esac
    done
    shift $((OPTIND-1))

    # if test -z "${SHAREDF}" && test -z "${CTFNAME}"; then
    #     echo $usage
    # else

    if test -z $SHAREDF; then SHAREDF=$HOME; fi
    if test -z $CTFNAME; then CTFNAME="no-ctf-name"; fi

    echo "Docker container name: $CTFNAME"
    echo "Mapping $SHAREDF to container:/home/ctf/share"
    echo

    docker run \
        --tty \
        --interactive \
        --privileged \
        --name "${CTFNAME}" \
        --hostname ctfbox \
        --user ctf \
        --publish 2222:22 \
        --publish 3002:3002 \
        --publish 3003:3003 \
        --publish 4000:4000 \
        --dns 8.8.8.8 \
        --dns 8.8.4.4 \
        --volume "${SHAREDF}":/home/ctf/share \
        boogy/ctfbox /bin/bash
    # fi
}

