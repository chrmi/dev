#!/bin/bash

# What to mount to the container (keep it secure, don't copy).
VOLUMES="-v $(pwd)/src:/home/me/src \
        -v $(pwd)/logs:/home/me/logs \
        -v $HOME/.ssh:/home/me/.ssh \
        -v $HOME/.aws:/home/me/.aws \
        -v $HOME/.gitconfig:/home/me/.gitconfig
        -v $(pwd)/auth:/home/me/auth"

# Mapping for development debugging.
# NOTE: Cannot map ports over multiple SSH sessions.
PORTS="-p 8097:8097 -p 8098:8098 =p 8099:8099 -p:8998:8998"

# Set up for local development, not production.  Control system state with environment variables.
OPTIONS="--network bridge --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --env-file=misc.env"

# For local system organization.
CONTAINER_IMAGE="chrmi-dev"

# Have many copies based on different development circumstances.
CONTAINER_TAG="a"

# Define port mapping from application outside of container
PORTS="-p:8097:8097 -p:8098:8098 -p:8099:8099"

case "$1" in
    # Build from scratch (assumes at least multistage base is built).  Clean install if things get wonky.
    -b|--build)
        docker build -t chrmi-dev-base/$CONTAINER_TAG ./base && \
        docker build --no-cache -t $CONTAINER_IMAGE/$CONTAINER_TAG .
        ;;

    # Build but persist when possible.  I.e. don't download Ubuntu + apt-gets again to update a port mapping.
    -u|--update)
        docker build -t $CONTAINER_IMAGE/$CONTAINER_TAG .
        ;;

    # Delete the container instance.
    -d|--delete)
        docker rmi -f $CONTAINER_IMAGE/$CONTAINER_TAG
        ;;

    # Run the container (option is a formality, not useful for this context).
    -r|--run)
        docker run -d -it --rm=true $VOLUMES $PORTS $OPTIONS $CONTAINER_IMAGE/$CONTAINER_TAG
        ;;

    # Stop a running container.  Not typically needed with -rm=true
    -x|--exit)
        docker stop $(docker ps -q --filter ancestor=$CONTAINER_IMAGE/$CONTAINER_TAG )
        ;;

    # SSH into the container for development.  Intended to use for compiling and using system specifics;
    # although you could use tmux and vim for a full IDE-like experience in a pinch.
    -s|--shell)
        docker run -it --rm=true $VOLUMES $PORTS $OPTIONS --env-file=gcp.env $CONTAINER_IMAGE/$CONTAINER_TAG /bin/bash
        ;;

    *)
        echo $"Usage: $0 { [b] build | [u] update | [d] delete | [r] run | [x] exit | [s] shell }"
        exit 1
esac
