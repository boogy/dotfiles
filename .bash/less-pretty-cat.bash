#!/usr/bin/env bash

if $(command -v pygmentize &>/dev/null); then
    CAT_BIN=$(which cat)
    LESS_BIN=$(which less)

    # pigmentize cat and less outputs
    # function cat
    # {
    #     for var in "$@";
    #     do
    #         pygmentize -g "$var" 2>/dev/null || "$CAT_BIN" "$var";
    #     done
    # }

    function less
    {
        pygmentize -g $* | "$LESS_BIN" -R
    }
fi
