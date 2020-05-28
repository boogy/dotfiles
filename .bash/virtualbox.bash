#!/usr/bin/env bash

alias vbox-list-vms="vboxmanage list vms"

function start-vagrant-ubuntu
{
    cd ~/VirtualBoxVMs/ubuntu
    vagrant up && vagrant ssh
}

function start-vagrant-arch
{
    cd ~/VirtualBoxVMs/archlinux
    vagrant up && vagrant ssh
}
