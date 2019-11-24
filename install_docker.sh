#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt-get remove docker docker-engine docker.io containerd runc
sh -c "$(curl -sSL https://get.docker.com/)"
usermod -aG docker $(whoami)
