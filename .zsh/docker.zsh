#!/usr/bin/env bash
#
# Docker helper functions/aliases to make it more easyer
# to work with our containers.
#
command -v docker >/dev/null 2>&1 && {

# Get latest container ID
alias dl="docker ps -l -q"
# Get process included stop container
alias dpa="docker ps -a"
# Get images
alias di="docker images"
# Get container IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"
# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"
# Execute interactive container, e.g., $dex base /bin/bash
alias dex="docker exec -i -t"
# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

function _list_images_names
{
    echo $(docker images|sed -e '/REPOSITORY/d'|awk '{print $1}')
}

# Stop all containers
function dstopa
{
    docker stop $(docker ps -a -q)
}

# Stop a docker service
function dstop
{
    docker stop $1
}

function drmi
{
    docker rmi $1
}
compdef '_arguments "1: :($(_list_images_names))"' drmi
# compdef _docker_img_list drmi

# Remove all containers
function drma
{
    docker rm $(docker ps -a -q)
}

# Remove a docker service
function drm
{
    local DSERVICE=$1
    docker stop $DSERVICE
    docker rm $DSERVICE
}

# Remove all images
function driall
{
    read -p "Are you sure you want to delete all docker images ? "
    docker rmi $(docker images -q)
}

# Dockerfile build, e.g., $dbu tcnksm/test
function dbu
{
    docker build -t=$1 .
}

function delnone
{
    docker rmi $(docker images | grep none | awk '{print $3}')
}

function docker-clean
{
  docker rmi -f $(docker images -q -a -f dangling=true)
}


# Update all docker images
# and delete none
function diu
{
    docker images | awk '{print $1}' | while read line; do docker pull $line; done
    if docker images | grep -q "<none>" ; then
        delnone
    fi
}


function drun
{
    docker run -it --rm $@
}
compdef '_arguments "1: :($(_list_images_names))"' drun
# compdef _docker_img_list drun

} # end check docker command
