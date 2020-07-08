#!/usr/bin/env bash
#
# file: aliases.sh
#

## colors
red=$(tput setaf 1)      # Issues/Errors
green=$(tput setaf 2)    # Success
yellow=$(tput setaf 3)   # Warnings/Information
blue=$(tput setaf 4)     # Heading
bold=$(tput bold  setaf 7)     # Highlight
reset=$(tput setaf 7)       # Norma

##
## The 'ls' family (this assumes you use a recent GNU ls)
## or rust equivalent 'exa'
##
command -v -p exa &>/dev/null && {
    alias ls="exa -g --color=auto --time-style=long-iso"
    alias ll="ls -l --color=auto"
    alias la="ls -la --color=always"
    alias llm="ls -l -s modified"
    alias llmr="ls -lr -s modified"
    alias llt="ll -T"
    alias llg="ll -G"
} || {
    alias ls="ls --color=always"
    alias ll="ls -l"
    alias sl="ls"
    alias la="ls -Al"          # show hidden files
    alias lx="ls -lXB"         # sort by extension
    alias lk="ls -lSr"         # sort by size, biggest last
    alias lc="ls -ltcr"        # sort by and show change time, most recent last
    alias lu="ls -ltur"        # sort by and show access time, most recent last
    alias lt="ls -ltr"         # sort by date, most recent last
    alias lm="ls -al|more"     # pipe through "more"
    alias lr="ls -lR"          # recursive ls
    alias lsdirs="ls -l | grep --color=always "^d""
}

##
## vim stuff
##
command -v -p nvim &>/dev/null && {
    # function vim(){ nvim $@; }
    export EDITOR=nvim
} || {
    export EDITOR=vim
}
alias v="$EDITOR"
alias vi="$EDITOR -p"
alias vim="$EDITOR -p"
alias svi="sudo -E $EDITOR"
alias svim="sudo -E $EDITOR"
alias v-conf="$EDITOR ~/.vimrc"
alias va-conf="$EDITOR ~/.vim/autocmds.vim"
alias vc-conf="$EDITOR ~/.vim/config.vim"
alias vf-conf="$EDITOR ~/.vim/functions.vim"
alias vm-conf="$EDITOR ~/.vim/mappings.vim"
alias i3-conf="$EDITOR ~/.config/i3/config"
alias polybar-conf="$EDITOR ~/.config/i3/polybar_config"

command -v -p rg &>/dev/null && {
    alias rg='rg --hidden'
}

##
## safety features
##
alias cp="cp -i"
alias cp2="rsync -aPWh"
alias mv="mv -i"
alias rm="rm -I"    # "rm -i" prompts for every file
alias ln="ln -i"    # prompt whether to remove destinations
alias chown="chown --preserve-root"
alias chmod="chmod --preserve-root"
alias chgrp="chgrp --preserve-root"
alias batpp="bat -p --paging=never"
alias batp="bat --paging=never"

##
## bash config shortcuts
##
alias br-conf="$EDITOR ~/.bashrc"
alias ba-conf="$EDITOR ~/.bash_aliases"
alias b-vmi="$EDITOR ~/.bash/init"
alias brc="source ~/.bashrc"

##
## tmux config shortcuts
##
alias tmux="tmux -2"
alias ta="tmux attach"
alias tls="tmux ls"
alias tat="tmux attach -t"
alias tns="tmux new-session -s"
alias t-conf="$EDITOR ~/.tmux.conf"

##
## directory changing shortcuts
##
alias ~="cd ~"
alias cd-="cd -"
# alias cd..="cd .."
# alias cd...="cd ../../"
# alias cd....="cd ../../../"
# alias ..="cd .."
# alias .2="cd ../../"
# alias .3="cd ../../../"
# alias .4="cd ../../../../"
# alias .5="cd ../../../../../"

##
## debian/ubuntu aliases
##
[[ "$(uname)" = "Linux" && $(command -v -p apt-get) ]] && {
    alias a-search="apt search"
    alias a-install="sudo apt install"
    alias a-remove="sudo apt remove"
    alias a-purge="sudo apt remove --purge"
    alias a-update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove && sudo apt-get autoclean"
    alias a-upgrade="sudo apt update && sudo apt dist-upgrade && sudo apt autoremove"
    alias a-show="sudo apt show"
    alias a-info="sudo apt-cache showpkg"
    alias a-deplist="apt-cache showpkg" # apt-cache rdepends works to
    alias a-upgradeble="apt list --upgradeable"
    alias dpkg-l="dpkg -l|grep --color=always"
    alias dpkg-f="dpkg-query -L"
    alias dpkg-stat="dpkg --status"
    alias dpkg-extract="dpkg-deb --extract" # dpkg-deb --extract package.deb dir-to-extract-to
}

##
## Arch Linux
##
[[ "$(uname)" = "Linux" && $(command -v -p pacman) ]] && {
    alias p-install="sudo pacman -S"
    alias pacinst=p-install
    alias p-remove="sudo pacman -R"
    alias pacremove=p-remove
    alias p-purge="sudo pacman -Rns"
    alias p-update="sudo pacman -Syu"
    alias pacupdate=p-update
    alias p-search="pacman -Ss"
    alias pacsearch=p-search
    alias p-query-installed="pacman -Qs"
    alias p-query-foreign="pacman -Qm"
    alias p-list-aur-packages="pacman -Qm"
    alias p-show="pacman -Si"
    alias p-clean-cache="sudo pacman -Sc"
    alias p-clean-orphans="sudo pacman -Rns $(pacman -Qtdq)"
    alias p-list-orphans="pacman -Qtdq"
    alias p-mirror-ranking="(curl -s \"https://www.archlinux.org/mirrorlist/?country=FR&country=GB&protocol=https&use_mirror_status=on\"|sed -e \"s/^#Server/Server/\" -e \"/^#/d\" | rankmirrors -n 5 -) | sudo tee /etc/pacman.d/mirrorlist"
    alias pacbrowse="pacman -Qq | fzf --preview \"pacman -Qil {}\" --layout=reverse --bind \"enter:execute(pacman -Qil {} | less)\""

    ## AUR
    alias pa-search="yay "
    alias yaysearch=pa-search
    alias pa-install="yay -S"
    alias yayinstall=pa-install
    alias pa-install-silent="yay -S --noconfirm"
    alias pa-update="yay -Syyuu --topdown --cleanafter"
    alias yayupdate=pa-update
    alias pa-remove="yay -R"
    alias yayremove=pa-remove
}

##
## Network related aliases
##
alias openports="netstat -nape --inet"
alias ports="netstat -lapute"
alias monittcp="sudo watch -n 1 \"ss -lapute| grep ESTAB\""
alias listening="sudo lsof -P -i -n"
alias ss-connected="ss -4p|column -t"


##
## Services
##
alias show-enabled-services="sudo systemctl list-unit-files --state enabled"
alias show-running-services="sudo systemctl list-units --type service --state running"
alias show-active-services="systemctl -t service --state active"
alias show-running-services="systemctl -t service --state running"


##
## NVIDIA aliases
##
alias nvidia-on="sudo tee /proc/acpi/bbswitch <<<ON"
alias nvidia-off="sudo tee /proc/acpi/bbswitch <<<OFF"
alias nvidia-is-on="cat /proc/acpi/bbswitch"
alias nvidia-check64="optirun glxspheres64"
alias nvidia-check32="optirun glxspheres32"

##
## MISC
##
alias ip="ip --color=always"
alias ipa="ip a s"
alias ipr="ip route"
alias dfh='df -h'
alias grep='grep --color=always'
alias lesss="$(which less) -R"
alias more="$(which less) -R"
alias mkdir='mkdir -p'
alias meminfo='free -m -l -t'
alias cmount="mount | column -t"
alias 'ps?'='ps -ef | grep -Ei --color=always '
alias 'ps!'='ps -ef | grep -vEi --color=always '
alias xclip="xclip -selection c"
alias busy='my_file=$(find /usr/include -type f | sort -R | head -n 1); my_len=$(wc -l $my_file | awk "{print $1}"); let "r = $RANDOM % $my_len" 2>/dev/null; $EDITOR +$r $my_file'
alias fix_stty='stty sane'
alias timestamp="date +%Y%m%d%H%M%S"

alias change-mouse-theme="sudo update-alternatives --config x-cursor-theme"
alias reload-xresources="xrdb ~/.Xresources"
alias show-xresources="xrdb -query -all"
alias show-wifi="wicd-curses" # wicd service should be started
alias disable-bluetooth="rfkill block bluetooth"
alias enable-bluetooth="rfkill unblock bluetooth"
alias xfreerdp="xfreerdp +clipboard /cert-ignore /size:1600x1024 /drive:home,/home/boogy/Commun "
alias polybar-restart="~/.config/i3/scripts/polybar-msg cmd restart"
alias kill-autolock="kill -9 $(pgrep xautolock)"
alias disable-hugepages="echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled"
alias cups-start="sudo systemctl start org.cups.cupsd.service"
alias cups-stop="sudo systemctl stop org.cups.cupsd.service"
alias socks-create="ssh -f -N -D 1080"
alias clusterssh="/usr/bin/vendor_perl/cssh"

##
## keyboard aliases
##
alias print-windows-license="sudo cat /sys/firmware/acpi/tables/MSDM;echo"
alias vt-console-keys-fix="sudo sh -c 'dumpkeys |grep -v cr_Console |loadkeys'"
alias keyboard-speed="xset r rate 200 50"
alias fr-keyboard="setxkbmap -model pc105 -layout ch -variant fr -option lv3:ralt_switch"
#alias sound-latency="pactl set-port-latency-offset $(pacmd list-sinks | egrep -o 'bluez_card[^>]*') headset-output 125000"

##
## FZF magic
##
alias list-notes="fzf --preview=\"cat {}\" --preview-window=right:70%:wrap --bind=\"space:toggle-preview\""
