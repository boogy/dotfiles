#!/usr/bin/env bash
#
# Copy all the dot files in the user's home directory
# and source them
#

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
    # ~/.Xresources
)

test -d ${INSTALLDIR} || mkdir -p ${INSTALLDIR}

cd ${INSTALLDIR}
test -d dotfiles || git clone https://github.com/boogy/dotfiles.git && \
cd ${INSTALLDIR}/dotfiles

# if test -z $1; then
#     read -p "Do you want to delete existing files/directorys ? [y/n]: " CLEAN_EXISTING_FILES
# else
#     CLEAN_EXISTING_FILES=$1
# fi
CLEAN_EXISTING_FILES=${1:-Y}

if [[ $CLEAN_EXISTING_FILES =~ [Y|y] ]]; then
    for FILE in ${MANAGED_FILES[@]}; do
        echo "Deleting $FILE" && rm -rf "$FILE"
    done
fi

##
## copy/symlink files to installdir
##
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

## Link confiuration scripts to /usr/local/bin/
# if [[ $CLEAN_EXISTING_FILES =~ [Y|y] ]]; then
#     for RM_FILE in $(ls $THIS_DIR/.config/scripts); do
#         rm -f /usr/local/bin/$RM_FILE
#     done
# fi
for FILE in $(ls $THIS_DIR/.config/scripts); do
    sudo ln -sf $THIS_DIR/.config/scripts/$FILE /usr/local/bin/
done

##
## Install Plug for neovim
##
mkdir -p $HOME/.config/nvim
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall
nvim -c 'CocInstall -sync coc-python coc-json coc-snippets coc-explorer coc-rls coc-html coc-go coc-tsserver coc-vimlsp coc-css coc-lists coc-sh coc-xml coc-yaml|q'
# pip3 install --user jedi-language-server jedi

## map all the configuration for vim
ln -sf ~/.config/nvim/init.vim ~/.vimrc
ln -sf ~/.config/nvim ~/.vim

# curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# vim +PlugInstall +qall
# ln -sf $HOME/.vim/custom-snippets $HOME/.vim/UltiSnips
# rm ~/.vim/custom-snippets/custom-snippets

##
## Install powerline fonts
##
git clone https://github.com/powerline/fonts.git --depth=1 ${INSTALLDIR}/powerline_fonts
cd ${INSTALLDIR}/powerline_fonts
./install.sh
rm -rf ${INSTALLDIR}/powerline_fonts &>/dev/null


## Copy firefox user.js in all profiles
FF_PROFILES_PATHS=($(awk -F"=" '/Path=/{print $2}' ~/.mozilla/firefox/profiles.ini))
for P in ${FF_PROFILES_PATHS[@]}; do
    cp ${THIS_DIR}/deploy/conf/firefox/user.js ~/.mozilla/firefox/${P}/
done

## Make sure .bash_aliases is loaded
case $(uname) in
    [Ll]inux)
        grep -qEo ".bash_aliases" ~/.bashrc \
            || echo "source ~/.bash_aliases" >> ~/.bashrc
        (test -f ~/.bashrc && chmod 0700 $_ && source $_) &>/dev/null
        ;;

    [Dd]arwin)
        test -f ~/.profile \
            || touch ~/.profile \
            && chmod 0700 $_
        grep -qEo ".bash_aliases" ~/.bashrc \
            || echo "source ~/.bash_aliases" >> ~/.profile
        (test -f ~/.profile && chmod 0700 $_ && source $_) &>/dev/null
        ;;
    *)
        echo "These dotfiles do not support $(uname)"
esac

