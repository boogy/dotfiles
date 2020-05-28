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

##
## Start a local rocket chat instance
##
function rocket-chat-start
{
    # local PORT=$1
    # if test -z $PORT; then
    #     echo "Usage: rocket-chat-start <PORT>"
    #     return 0
    # fi
    docker run --name mongo -d mongo:4.0 mongod --smallfiles --oplogSize 128 --replSet rs0 --storageEngine=mmapv1
    docker run --name mongo_replica -d --link mongo mongo:4.0 "bash -c \"for i in $(seq 1 30); do mongo mongo/rocketchat --eval \" rs.initiate({ _id: 'rs0', members: [ { _id: 0, host: 'localhost:27017' } ]})\" && s=$$? && break || s=$$?; echo \"Tried $$i times. Waiting 5 secs...\"; sleep 5; done; (exit $$s)\""

    docker run --name rocketchat -p 3000:3000 --env ROOT_URL=https://localhost:3000 \
    -e "MONGO_URL=mongodb://mongo:27017/rocketchat MONGO_OPLOG_URL=mongodb://mongo:27017/local" \
    --link mongo:mongo -d rocketchat/rocket.chat "bash -c \"for i in $(seq 1 30); do node main.js && s=$$? && break || s=$$?; echo \"Tried $$i times. Waiting 5 secs...\"; sleep 5; done; (exit $$s)\""
}


##
## Mono compile project
##
function mono-compile
{
    FILE_TO_COMPILE=$1
    PLATFORM=${2:-"x64"}
    docker run -it --rm \
        -v $PWD:/share \
        mono mcs -platform:${PLATFORM} /share/${FILE_TO_COMPILE}
    # sudo chown ${USER}:${USER} "${FILE_TO_COMPILE%.*}"*
}


} # end check docker command
