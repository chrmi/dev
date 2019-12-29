#!/bin/bash

VOLUMES="-v $(pwd)/src:/home/me/src \
        -v $(pwd)/logs:/home/me/logs \
        -v $HOME/.ssh:/home/me/.ssh \
        -v $HOME/.aws:/home/me/.aws \
        -v $HOME/.gitconfig:/home/me/.gitconfig"

OPTIONS="--network bridge --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --env-file=ports.env"

PORTS="-p:8998:8998"

CONTAINERIMAGE="dev"
CONTAINERTAG="a"

case "$1" in
    -b|--build)
        docker build --no-cache -t $CONTAINERIMAGE/$CONTAINERTAG .
        ;;

    -u|--update)
        docker build -t $CONTAINERIMAGE/$CONTAINERTAG .
        ;;

    -d|--delete)
        docker rmi -f $CONTAINERIMAGE/$CONTAINERTAG
        ;;

    -r|--run)
        docker run -d -it --rm=true $VOLUMES $PORTS $OPTIONS $CONTAINERIMAGE/$CONTAINERTAG
        ;;

    -x|--exit)
        docker stop $(docker ps -q --filter ancestor=$CONTAINERIMAGE/$CONTAINERTAG )
        ;;

    -s|--shell)
        docker run -it --rm=true $VOLUMES $PORTS $OPTIONS $CONTAINERIMAGE/$CONTAINERTAG /bin/bash
        ;;

    *)
        echo $"Usage: $0 { [b] build | [u] update | [d] delete | [r] run | [x] exit | [s] shell }"
        exit 1
esac
