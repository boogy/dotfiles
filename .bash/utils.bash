#!/usr/bin/env bash

has() {
    _OS=$(uname -s)
    case $_OS in
        Linux)
            command -v -p $1
            ;;
        Darwin)
            command -v $1
            ;;
        *)
            command -v -p $1
    esac
}


os_is(){
    case $(echo $1|tr '[A-Z]' '[a-z]') in
        macos|darwin)
            os_type=Darwin
            ;;
        linux)
            os_type=Linux
            ;;
        *)
            os_type=Unknown
            ;;
    esac
    if [[ $(uname -s) =~ $os_type ]]; then
        return 0
    else
        return 1
    fi
}
