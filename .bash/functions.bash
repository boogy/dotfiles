#!/usr/bin/env bash
#
# Some useful functions

open_with_fzf() {
    fd -t f -H -I | fzf -m --preview="xdg-mime query default {}" | xargs -ro -d "\n" xdg-open 2>&-
}

cd_with_fzf() {
    cd $HOME && cd "$(fd -t d | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)"
}

pacs() {
    sudo pacman -Syy $(pacman -Ssq | fzf -m --preview="pacman -Si {}" --preview-window=:hidden --bind=space:toggle-preview)
}

# Set tmux session name with the hostname
function settitle
{
    printf "\033k${1}\033\\"
}


function window-title
{
    echo -e "\e]0;${1}\a"
}


# Uses settitle to automaticaly set tmux
# session with host when using ssh
function con
{
    # settitle "$*";
    command ssh -X "$@"
}


function s
{
    # do sudo, or sudo the last command if no argument given
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}


function cpbak
{
    cp "$1"{,.bak}
}


function cls
{
    cd "$1"; ls
}


# Show aliases in my environment
function show-alias-command
{
    # alias|grep --color=none "$1"|awk -F= '{gsub(/'"'"'/, "", $2); print $1" =",$2}'|sed 's|\\||g'| column -s "=" -t
    alias|grep --color=none "$1"|sed 's/=/\t/'
}

# Print whole function
# from our environment files
function show-function
{
    (declare -f $1 ~/.bash/*.bash | sed '1 s/\(.*\)/function \1/') | pygmentize -g
}

function show-alias
{
    fnc=$(show-function $@)
    als=$(show-alias-command $@)

    if [[ "$fnc" != "" ]]; then
        echo -e "$fnc"
    elif [[ "$als" != "" ]]; then
        echo -e "$als" | pygmentize -l shell
    else
        echo -e "\e[01;31mNo function or alias found with the name $1\e[0m" >&2
    fi
}

function mcd
{
    mkdir -p "$1"; cd "$1"
}

function mkcd
{
    mkdir -p "$1" ; cd "$1"
}

function what
{
    which $1 | xargs ls -la
}

function random-number
{
    echo $[RANDOM%${1}+1]
}

function gen-uuid
{
    # echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo $(python3 -c 'import uuid;print(uuid.uuid1())')
}

function lsg
{
    keyword=$(echo "$@" |  sed 's/ /.*/g')
    ls -GgthrA | grep -iE $keyword
}

function d-swiggle
{
    find . -type f -name '*~' -exec rm -v {} \;
}

function zombie-process
{
    ps auxw | awk '{ print $8 " " $2 }' | grep -w Z
}

function tophist
{
    history | awk '{ print $2 }' | sort |  uniq -c | sort -rn | sed '1,27!d'
}

function up
{ # usage: up 2 --> same as cd ../../
    local x=''
    for i in $(seq ${1:-1});do
        x="$x../"
    done
    cd $x
}

function sort-dir-by-size()
{
    du -sh "$@" | sort -r -h
}

function my_ps
{ # List processes owned by my user
    ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command
}

# Viewing Top Processes according to cpu, mem, swap size, etc.
function top_proc
{
    ps wwo pid,user,group,vsize:8,size:8,sz:6,rss:6,pmem:7,pcpu:7,time:7,wchan,sched=,stat,flags,comm,args k -vsz -A|\
    sed -u '/^ *PID/d;10q'
}


function copy-cwd-dir-and-compress
{
    tar -cf - . | pv -s $(du -sb . | awk '{print $2}') | gzip > out.tgz
}

function deadlinks
{
    # find dead symlinks in the current directory or $1
    local __path="${1:-./}"
    find -L "${__path}" -type l -print
}

function mx
{ # Return MX records for a given domain
    [[ ${1:-UNSET} == "UNSET" ]] && return 1
    dig +short mx "${1}" | sort | tr "[:upper:]" "[:lower:]"
}

function nameservers
{ # return nameservers for a given domain
    [[ ${1:-UNSET} == "UNSET" ]] && return 1
    dig +short ns "${1}" | sort | tr "[:upper:]" "[:lower:]"
}

function repeat
{
    # Repeat n times command.
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}

function gen-passwd
{
    pip2 show passlib &>/dev/null && \
        python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.using(rounds=5000).hash(getpass.getpass())"
}

function killps
{
    # Kill by process name
    local pid pname sig="-TERM"   # Default signal.
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ) ; do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}

function my-ip
{
    echo $(ip route get 1 | awk '{print $7;exit}')
}


function list-ips
{
    ip --color=always -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {print $2" "$4}'|column -t
}


function extract
{
    local opt
    local OPTIND=1
    while getopts "hv" opt; do
        case "$opt" in
            h)
                cat <<End-Of-Usage
Usage: ${FUNCNAME[0]} [option] <archives>
    options:
        -h  show this message and exit
        -v  verbosely list files processed
End-Of-Usage
                return
                ;;
            v)
                local -r verbose='v'
                ;;
            ?)
                extract -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    [ $# -eq 0 ] && extract -h && return 1
    while [ $# -gt 0 ]; do
        if [ -f "$1" ]; then
            case "$1" in
                *.tar.bz2|*.tbz|*.tbz2) tar "x${verbose}jf" "$1" ;;
                *.tar.gz|*.tgz) tar "x${verbose}zf" "$1" ;;
                *.tar.xz) xz --decompress "$1"; set -- "$@" "${1:0:-3}" ;;
                *.tar.Z) uncompress "$1"; set -- "$@" "${1:0:-2}" ;;
                *.bz2) bunzip2 "$1" ;;
                *.deb) dpkg-deb -x${verbose} "$1" "${1:0:-4}" ;;
                *.pax.gz) gunzip "$1"; set -- "$@" "${1:0:-3}" ;;
                *.gz) gunzip "$1" ;;
                *.pax) pax -r -f "$1" ;;
                *.pkg) pkgutil --expand "$1" "${1:0:-4}" ;;
                *.rar) unrar x "$1" ;;
                *.rpm) rpm2cpio "$1" | cpio -idm${verbose} ;;
                *.tar) tar "x${verbose}f" "$1" ;;
                *.txz) mv "$1" "${1:0:-4}.tar.xz"; set -- "$@" "${1:0:-4}.tar.xz" ;;
                *.xz) xz --decompress "$1" ;;
                *.zip|*.war|*.jar) unzip "$1" ;;
                *.Z) uncompress "$1" ;;
                *.7z) 7za x "$1" ;;
                *) echo "'$1' cannot be extracted via extract" >&2;;
            esac
        else
            echo "extract: '$1' is not a valid file" >&2
        fi
        shift
    done
}

function smartcompress
{
    # Usage: smartcompress <file> (<type>)
    # Description: compresses files or a directory.  Defaults to tar.gz
    if [ "$2" ];then
        case "$2" in
            tgz | tar.gz)   tar -zcvf$1.$2 "$1" ;;
            tbz2 | tar.bz2) tar -jcvf$1.$2 "$1" ;;
            tar.Z)          tar -Zcvf$1.$2 "$1" ;;
            tar)            tar -cvf$1.$2  "$1" ;;
            gz | gzip)      gzip           "$1" ;;
            bz2 | bzip2)    bzip2          "$1" ;;
            *)
        echo "Error: $2 is not a valid compression type" ;;
        esac
    else
        smartcompress '$1' tar.gz
    fi
}

function is-reboot_required
{
    if echo "$(cat /etc/os-release|awk -F'=' '/^NAME=.*$/{print $2}'|tr -d '"')" \
        | grep -Eo "ubuntu|debian"
    then
        if [ -f /var/run/reboot-required ]; then
            echo -e '\e[0;31m[YES]\e[0m reboot required\n'
        else
            echo -e "\e[0;32m[NO]\e[0m reboot not required\n"
        fi
    fi
}

function clean-trash
{
    local TRASH_DIR=""
    if [[ -d "$HOME/.Trash" ]]; then
        TRASH_DIR=~/.Trash
    else
        TRASH_DIR="$HOME/.local/share/Trash"
    fi
    echo "$TRASH_DIR"

    if [[ $# -ge 1 ]] && [[ $(echo "$1"|grep -Eo "^(-f|force|--force|f|F)$") ]]
    then
        rm -rf $TRASH_DIR
    else
        tree $TRASH_DIR
        echo -e "${BYellow}Are you sure you want to remove all the files [Y/n]${Color_Off}"
        read ANSWER

        if [[ $(echo ${ANSWER:-y} |grep -Eo "^[y|Y]$") ]]
        then
            rm -rf $TRASH_DIR/* && echo -e "${BGreen}Files removed ...${Color_Off}"
        else
            echo -e "${BGreen}No action to do ...${Color_Off}"
        fi
    fi
}
alias empty-trash=clean-trash


function open-with-firefox
{
    FILE_NAME=$@
    for F in ${FILE_NAME[@]}
    do
        if test -f $F; then
            firefox $(cat $F)
        else
            firefox $F
        fi
    done
}

function file-to-hex()
{
    od -A n -t x1 $1|sed 's/ *//g'|tr -d '\n';echo
}

function expand-ip()
{
  nmap -sL -n "$1" | awk '/Nmap scan report/{print $NF}'
}

ssh-forward-local(){
    local BIND_PORT="$1"
    local DEST_HOST="$2"
    local DEST_PORT="$3"
    local SSH_USER="${4:-${USERNAME}}"

    if [ $# -le 2 ]; then
        echo "Usage: ${0} <local bind port> <dest host> <dest address>"
        echo "       transaltes to: ssh -L [bind address (localhost)]:[port]:[dsthost]:[dstport] [user]@[dest host]"
    else
        ssh -L 127.0.0.1:"${BIND_PORT}":"${DEST_HOST}":"${DEST_PORT}" "${USER}"@"${DEST_HOST}"
    fi
}

to-lower(){
    echo "$1" | awk '{print tolower($0)}'
}

to-upper(){
    echo "$1" | awk '{print toupper($0)}'
}

cpu-usage-percentage(){
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}
