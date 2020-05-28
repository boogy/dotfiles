#!/usr/bin/env bash

for DIR in $(ls $HOME/tools); do
    if test -d $DIR; then
        cd $DIR
        if test -d .git; then
            echo -en "\n\n[+] Running git pull in $DIR\n"
            git pull
        fi
    fi
    cd $HOME/tools
done
