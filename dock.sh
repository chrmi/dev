#!/bin/bash

VOLUMES="-v $(pwd)/pub:/home/d/pub -v $HOME/.ssh:/home/d/.ssh -v $HOME/.aws:/home/d/.aws -v $HOME/.gitconfig:/home/d/.gitconfig"
OPTIONS="--network bridge --cap-add=SYS_PTRACE --security-opt seccomp=unconfined"
PORTS="-p:8097:8097 -p:8098:8098 -p:8099:8099"
CONTAINERIMAGE="dev"
CONTAINERTAG="a"

case "$1" in
    -b|--build)
        mkdir pub ; docker build --no-cache -t $CONTAINERIMAGE/$CONTAINERTAG .
        ;;

    -r|--rebuild)
        docker build -t $CONTAINERIMAGE/$CONTAINERTAG .
        ;;

    -d|--delete)
        docker rmi -f $CONTAINERIMAGE/$CONTAINERTAG
        ;;

    -s|--shell)
        docker run --rm=false -it $VOLUMES $PORTS $OPTIONS $NODE --rm=true $CONTAINERIMAGE/$CONTAINERTAG /bin/bash
        ;;

    *)
        echo $"Usage: $0 { build | rebuild | delete | shell| }"
        exit 1
esac
