#!/bin/bash

VOLUMES="-v $(pwd)/pub:/home/d/pub -v $HOME/.ssh:/home/d/.ssh -v $HOME/.aws:/home/d/.aws -v $HOME/.gitconfig:/home/d/.gitconfig"
OPTIONS="--network bridge --cap-add=SYS_PTRACE --security-opt seccomp=unconfined"
PORTS="-p:8097:8097 -p:8098:8098 -p:8099:8099"
NODE="-e 'NODE_ENV=development'"
CONTAINERIMAGE="dev"
CONTAINERTAG="a"

case "$1" in
  -p|--prep)
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get install -y git wget curl vim tree software-properties-common build-essential

    git clone https://github.com/chrmi/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
    curl -o $HOME/.vimrc https://raw.githubusercontent.com/chrmi/dev/master/vimrc
    mkdir $HOME/.vim/colors && curl -o $HOME/.vim/colors/gruvbox.vim https://raw.githubusercontent.com/chrmi/gruvbox/master/colors/gruvbox.vim
    vim +PluginInstall +qall

    sudo apt-get -y remove docker docker-engine docker.io
    sudo apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
    sudo apt-get -y install docker-ce
    sudo usermod -aG docker $(whoami)
    ;;

  -i|--install)
    mkdir pub ; docker build --no-cache -t $CONTAINERIMAGE/$CONTAINERTAG .
    ;;

  -r|--reinstall)
    docker build -t $CONTAINERIMAGE/$CONTAINERTAG .
    ;;

  -d|--delete)
    docker rmi -f $CONTAINERIMAGE/$CONTAINERTAG
    ;;

  -s|--shell)
    docker run --rm=false -it $VOLUMES $PORTS $OPTIONS $NODE --rm=true $CONTAINERIMAGE/$CONTAINERTAG /bin/bash
    ;;

  *)
    echo $"Usage: $0 { install | reinstall | delete | shell| }"
    exit 1
esac
