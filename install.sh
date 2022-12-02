#!/usr/bin/env bash

## Copy all the dot files in the user's home directory
## and source them

THIS_DIR=$(cd $(dirname "$0"); pwd)
INSTALLDIR=$HOME

MANAGED_FILES=(
    ~/bin
    ~/.zshrc
    ~/.zsh
    ~/.bash
    ~/.bash_aliases
    ~/.vim
    ~/.vimrc
    ~/.tmux.conf
    ~/.pythonrc.py
    ~/.screenrc
)

test -d ${INSTALLDIR} || mkdir -p ${INSTALLDIR}

cd ${INSTALLDIR}
test -d dotfiles || git clone https://github.com/boogy/dotfiles.git && \
cd ${INSTALLDIR}/dotfiles

# if test -z $1; then
#     read -p "Do you want to delete existing files/directorys ? [y/n]: " CLEAN_EXISTING_FILES
# else; CLEAN_EXISTING_FILES=$1; fi
CLEAN_EXISTING_FILES=${1:-Y}

if [[ $CLEAN_EXISTING_FILES =~ [Y|y] ]]; then
    for FILE in ${MANAGED_FILES[@]}; do
        echo "Deleting $FILE" && rm -rf "$FILE"
    done
fi


## copy/symlink files to installdir
for FILE in ${MANAGED_FILES[@]}; do
    STRIPED_FILE_NAME=${FILE##*/}
    echo "Copying ${THIS_DIR}/${STRIPED_FILE_NAME} to ${INSTALLDIR}"
    ln -sf ${THIS_DIR}/${STRIPED_FILE_NAME} ${INSTALLDIR}
done


## link .config files
for DOT_FILE in $(ls .config); do
    if [[ $CLEAN_EXISTING_FILES =~ [Y|y] ]]; then
        rm -rf ~/.config/$DOT_FILE
    fi
    ln -sf $THIS_DIR/.config/$DOT_FILE ~/.config/
done


## Alacritty OS specific config
cd ~/.config/alacritty \
    && ln -sf alacritty-$(uname -s).yml alacritty.yml \
    && cd $THIS_DIR


## link scripts
for FILE in $(ls $THIS_DIR/.config/scripts); do
    # if [[ $CLEAN_EXISTING_FILES =~ [Y|y] ]]; then
    #     for RM_FILE in $(ls $THIS_DIR/.config/scripts); do
    #         rm -f /usr/local/bin/$RM_FILE
    #     done
    # fi
    sudo ln -sf $THIS_DIR/.config/scripts/$FILE /usr/local/bin/
done


## Install Plug for neovim
mkdir -p $HOME/.config/nvim
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall
nvim -c 'CocInstall -sync coc-python coc-json coc-powershell coc-snippets coc-explorer coc-rls coc-go coc-tsserver coc-vimlsp coc-lists coc-sh coc-xml coc-yaml coc-pairs|q'

## map all the configuration for vim
ln -sf ~/.config/nvim/init.vim ~/.vimrc
ln -sf ~/.config/nvim ~/.vim
ln -sf ~/.config/nvim ~/.vim/nvim


## Install powerline fonts
cd /tmp && git clone https://github.com/powerline/fonts.git --depth=1
cd fonts \
    && ./install.sh \
    && cd .. \
    && rm -rf fonts


## Copy firefox user.js in all profiles
case $(uname -s) in
    Darwin)
        firefox_profile="/Users/$USER/Library/Application Support/Firefox/Profiles"
        firefox_ini_pth="/Users/$USER/Library/Application Support/Firefox/profiles.ini"
        ;;
    Linux)
        firefox_profile=~/.mozilla/firefox
        firefox_ini_pth=$firefox_profile
        ;;
esac

# FF_PROFILES_PATHS=($(awk -F"=" '/Path=/{print $2}' ~/.mozilla/firefox/profiles.ini))
FF_PROFILES_PATHS=($(awk -F"=" '/Path=/{print $2}' ${firefox_ini_pth}))
for P in ${FF_PROFILES_PATHS[@]}; do
    cp ${THIS_DIR}/deploy/conf/firefox/user.js ${firefox_profile}/${P}
done

## Make sure .bash_aliases is loaded and more
case $(uname) in
    [Ll]inux)
        grep -qEo ".bash_aliases" ~/.bashrc \
            || echo "source ~/.bash_aliases" >> ~/.bashrc
        (test -f ~/.bashrc && chmod 0700 $_ && source $_) &>/dev/null

        ## setup xmonad
        # command -v ghc && {
        #     (mkdir -p $HOME/.local/share/xmonad \
        #         && ln -s ${THIS_DIR}/.config/xmonad $HOME/.xmonad \
        #         && cd $HOME/.config/xmonad/ && ghc -dynamic xmonadctl.hs) &>/dev/null
        # }
        ;;

    [Dd]arwin)
        test -f ~/.profile \
            || touch ~/.profile \
            && chmod 0700 $_
        grep -qEo ".bash_aliases" ~/.bashrc \
            || echo "source ~/.bash_aliases" >> ~/.profile
        (test -f ~/.profile && chmod 0700 $_ && source $_) &>/dev/null

        ## setup VSCode
        ln -sf ${THIS_DIR}/deploy/conf/VSCode/User "/Users/$USER/Library/Application Support/Code/"
        ;;
    *)
        echo "These dotfiles do not support $(uname)"
esac

