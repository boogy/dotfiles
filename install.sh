#!/usr/bin/env bash

## Copy all the dot files in the user's home directory
## and source them

THIS_DIR=$(
  cd $(dirname "$0")
  pwd
)
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
)

echo "[+] Checking if ${INSTALLDIR} exists"
test -d ${INSTALLDIR} || mkdir -p ${INSTALLDIR}

cd ${INSTALLDIR}
test -d dotfiles || git clone https://github.com/boogy/dotfiles.git &&
  cd ${INSTALLDIR}/dotfiles

# if test -z $1; then
#     read -p "Do you want to delete existing files/directorys ? [y/n]: " CLEAN_EXISTING_FILES
# else; CLEAN_EXISTING_FILES=$1; fi
CLEAN_EXISTING_FILES=${1:-Y}

if [[ $CLEAN_EXISTING_FILES =~ [Y|y] ]]; then
  for FILE in ${MANAGED_FILES[@]}; do
    echo "[+] Deleting $FILE" && rm -rf "$FILE"
  done
fi

## copy/symlink files to installdir
echo "[+] Copying files to ${INSTALLDIR}"
for FILE in ${MANAGED_FILES[@]}; do
  STRIPED_FILE_NAME=${FILE##*/}
  echo "Copying ${THIS_DIR}/${STRIPED_FILE_NAME} to ${INSTALLDIR}"
  ln -sf ${THIS_DIR}/${STRIPED_FILE_NAME} ${INSTALLDIR}
done

## link .config files
echo "[+] Linking .config files"
for DOT_FILE in $(ls .config); do
  if [[ $CLEAN_EXISTING_FILES =~ [Y|y] ]]; then
    rm -rf ~/.config/$DOT_FILE
  fi
  ln -sf $THIS_DIR/.config/$DOT_FILE ~/.config/
done

## link scripts
echo "[+] Linking scripts from ${THIS_DIR}/.config/scripts to /usr/local/bin/"
for FILE in $(ls $THIS_DIR/.config/scripts); do
  # if [[ $CLEAN_EXISTING_FILES =~ [Y|y] ]]; then
  #     for RM_FILE in $(ls $THIS_DIR/.config/scripts); do
  #         rm -f /usr/local/bin/$RM_FILE
  #     done
  # fi
  sudo ln -sf $THIS_DIR/.config/scripts/$FILE /usr/local/bin/
done

## map all the configuration for vim
echo "[+] Linking NeoVim configuration"
ln -sf ~/.config/nvim/init.vim ~/.vimrc
ln -sf ~/.config/nvim ~/.vim
ln -sf ~/.config/nvim ~/.vim/nvim

## Copy firefox user.js in all profiles
case "$(uname -s)" in
Darwin)
  firefox_base="$HOME/Library/Application Support/Firefox"
  ;;
Linux)
  firefox_base="$HOME/.mozilla/firefox"
  ;;
*)
  echo "Unsupported OS"
  exit 1
  ;;
esac

profiles_ini="$firefox_base/profiles.ini"
userjs_src="$THIS_DIR/deploy/conf/firefox/user.js"

[[ -f "$profiles_ini" ]] || {
  echo "[-] profiles.ini not found"
  exit 1
}
[[ -f "$userjs_src" ]] || {
  echo "[-] user.js not found"
  exit 1
}

echo "[+] Copying user.js to all Firefox profiles..."

# Extract profile paths
awk -F= '/^Path=/{print $2}' "$profiles_ini" | while read -r path; do
  profile_dir="$firefox_base/$path"

  if [[ -d "$profile_dir" ]]; then
    cp "$userjs_src" "$profile_dir/user.js"
    echo "  ✔ Copied to $profile_dir"
  fi
done

## Make sure .bash_aliases is loaded and more
case $(uname) in
[Ll]inux)
  grep -qEo ".bash_aliases" ~/.bashrc ||
    echo "source ~/.bash_aliases" >>~/.bashrc
  (test -f ~/.bashrc && chmod 0700 $_ && source $_) &>/dev/null
  ;;

[Dd]arwin)
  test -f ~/.profile ||
    touch ~/.profile &&
    chmod 0700 $_
  grep -qEo ".bash_aliases" ~/.bashrc ||
    echo "source ~/.bash_aliases" >>~/.profile
  (test -f ~/.profile && chmod 0700 $_ && source $_) &>/dev/null

  ## Setup VSCode
  echo "[+] Linking VSCode configuration"
  ln -sf ${THIS_DIR}/deploy/conf/VSCode/User "/Users/$USER/Library/Application Support/Code/"
  ;;
*)
  echo "These dotfiles do not support $(uname)"
  ;;
esac
