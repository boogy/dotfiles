#!/usr/bin/env bash
#
# Script to bootstrap a linux box
#
if [[ "$(uname)" != "Linux"* ]]; then
  echo "$0 : Will only run on Linux debian/ubuntu"
  exit 1
fi

export mydirectory=tools
export DEBIAN_FRONTEND=noninteractive

echo "[*] removal of default useless apps"
sudo apt remove -y --purge rhythmbox ekiga totem ubuntu-one unity-lens-music \
    unity-lens-photos unity-lens-video transmission transmission-gtk transmission-common \
    thunderbird apport gnome-mahjongg libgnome-games-support-common aisleriot gnome-sudoku

##
## Ubunu PPAs
##
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo add-apt-repository -y ppa:webupd8team/java
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get upgrade -y

##
## Install packags
##
DIR=$(cd $(dirname "$0"); pwd)
if [[ -f $DIR/packages/apt ]]; then
    while read line
    do
        if [[ ! "$line" =~ (^#|^$) ]]; then
            packages="$packages $line"
        fi
    done < $DIR/packages/apt
    sudo apt install -y "$packages"
fi


## Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker ${USER}

## Install polybar
git clone https://github.com/jaagr/polybar.git $HOME/polybar
cd $HOME/polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install


## Install snaps
# sudo apt install -y snapd
sudo snap install alacritty --classic

## Install rustup
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

## Install yarn for neovim
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn

## Install egpu-switcher
# sudo add-apt-repository ppa:hertg/egpu-switcher
# sudo apt update
# sudo apt install egpu-switcher
# sudo egpu-switcher setup

## OR using git
# git clone git@github.com:hertg/egpu-switcher.git
# cd egpu-switcher
# make install
# sudo egpu-switcher setup

###
### Housekeeping
###
echo "[*] clean packages downloaded"
sudo apt autoclean -y
## this will install the requirements for chrome.
sudo apt -y install -f

