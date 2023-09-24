#!/use/bin/env zsh

## helper fucntion
source $HOME/.bash/utils.bash

alias ipa='ip -c=always a s'
alias ipaj="ip -j a s|jq -c '.[]|select(.ifname|match(\"(eth[0-9]{1})\")).addr_info[0].local'|tr -d '\"'"
alias ipaa="ip -j a s|jq '.[].addr_info[]|select(.family|match(\"inet$\"))|select(.label|match(\"[^(lo)]\"))|.label,.local'|sed -e ':a;N;\$!ba;s/\"//g;s/\([0-9]\{,3\}\.[0-9]\{,3\}.[0-9]\{,3\}\.[0-9]\{,3\}\)/\1\n/g'"

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g R='| rg -i -e'
alias -g grep_ipv4='| egrep -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}"'
alias -g grep_ipv6='| egrep -o "(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"'
alias -g L="| less"
alias -g M="| most"
alias -g C="| wc -l"
alias -g PIPE='|'
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g DN="&> /dev/null"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"

alias zshrc='${=EDITOR} ~/.zshrc'
alias zshrc_alias='${=EDITOR} ~/.zsh/aliases.zsh'
alias src='source ~/.zshrc'

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias ff='find . -type f -name'
alias ffd='find . -type d -name'
os_is Linux && {
    alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
}
alias go-root="sudo -u root -s"
alias xopen="xdg-open"
alias exiftool="/usr/bin/vendor_perl/exiftool"

os_is macOS && {
    alias b-update='brew update && brew upgrade && brew cleanup'
    alias b-clean='brew cleanup'
    alias b-inst='brew install'
    alias b-list='brew list'
    alias b-list-formula='brew list --formula'
    alias b-list-cask='brew list --cask'
}

## directory shortcuts
hash -d dotfiles=~/dotfiles
hash -d dunst=~/.config/dunst
hash -d rofi=~/.config/rofi
hash -d ranger=~/.config/ranger
hash -d termite=~/.config/termite
hash -d tmux=~/.config/tmux
hash -d alacritty=~/.config/alacritty
hash -d nvim=~/.config/nvim/
hash -d polybar=~/.config/polybar
hash -d bspwm=~/.config/bspwm
hash -d sxhkd=~/.config/sxhkd
hash -d sxiv=~/.config/sxiv/
hash -d sxiv=~/.config/sxiv/
hash -d picom=~/.config/picom
hash -d awesome=~/.config/awesome
hash -d xmonad=~/.config/xmonad
hash -d conf-scripts=~/.config/scripts

## use delete key to delete
bindkey "^[[3~"  delete-char
bindkey "^[3;5~" delete-char
## shift+tab backward menu key
bindkey '^[[Z' reverse-menu-complete

## home and end keys
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "\033[1~" beginning-of-line
bindkey "\033[4~" end-of-line

## set zsh word boundary chars
## for backward delete word or backward-kill-word
# local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>/'
# my-backward-delete-word() {
#     # local WORDCHARS=${WORDCHARS/\/./}
#     local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
#     zle backward-delete-word
# }
# zle -N my-backward-delete-word
# bindkey '^W' my-backward-delete-word


if [[ -n "$BROWSER" ]]; then
    _browser_fts=(htm html de org net com at cx nl se dk)
    for ft in $_browser_fts; do alias -s $ft=$BROWSER; done
fi

_editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
for ft in $_editor_fts; do alias -s $ft=$EDITOR; done

if [[ -n "$XIVIEWER" ]]; then
    _image_fts=(jpg jpeg png gif mng tiff tif xpm)
    for ft in $_image_fts; do alias -s $ft=$XIVIEWER; done
fi

_media_fts=(ape avi flv m4a mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
for ft in $_media_fts; do alias -s $ft=mplayer; done

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/config,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'


alias find-outlook-temp-files='find /var/folders -iname com.microsoft.outlook 2>&1 |grep -v "ermi"'


[[ $(uname -s) =~ Darwin ]] \
    && code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}


pyclean () {
    find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}
