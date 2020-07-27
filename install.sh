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
    ~/.gdbinit
    ~/.radarerc
    ~/.Xresources
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

## Link bspwm && i3 config scripts
if [[ $CLEAN_EXISTING_FILES =~ [Y|y] ]]; then
    for RM_FILE in $(ls $THIS_DIR/.config/bspwm/scripts); do
        rm -f /usr/local/bin/$RM_FILE
    done
fi
for FILE in $(ls $THIS_DIR/.config/bspwm/scripts); do
    sudo ln -sf $THIS_DIR/.config/bspwm/scripts/$FILE /usr/local/bin/
done


##
## Install Plug for plugin management
##
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
ln -sf $HOME/.vim/custom-snippets $HOME/.vim/UltiSnips
rm ~/.vim/custom-snippets/custom-snippets

##
## Install for neovim
##
mkdir -p $HOME/.config/nvim
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall
nvim -c 'CocInstall -sync coc-python coc-json coc-snippets coc-explorer coc-rls coc-html coc-go coc-tsserver coc-vimlsp coc-css coc-lists coc-sh coc-xml coc-yaml|q'
pip3 install --user jedi-language-server jedi

##
## Install powerline fonts
##
git clone https://github.com/powerline/fonts.git --depth=1 ${INSTALLDIR}/powerline_fonts
cd ${INSTALLDIR}/powerline_fonts
./install.sh
rm -rf ${INSTALLDIR}/powerline_fonts &>/dev/null


## Make sure that .bash_aliases is loaded
[ $(uname) = 'Linux' ] && {
  grep -qEo ".bash_aliases" ~/.bashrc || echo "source ~/.bash_aliases" >> ~/.bashrc
  (test -f ~/.bashrc && chmod 0700 $_ && source $_) &>/dev/null
}

[ $(uname) = 'Darwin' ] && {
  test -f ~/.profile || touch ~/.profile && chmod 0700 $_
  grep -qEo ".bash_aliases" ~/.bashrc || echo "source ~/.bash_aliases" >> ~/.profile
  (test -f ~/.profile && chmod 0700 $_ && source $_) &>/dev/null
}

