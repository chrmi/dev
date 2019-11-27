#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt-get update
apt-get upgrade -y
apt-get update && sudo apt-get install -y vim tmux wget curl tree watch git \
    software-properties-common build-essential cmake zlib1g-dev libffi-dev \
    python-dev python-pip python3 python3-pip python3-venv

add-apt-repository ppa:gophers/archive
apt-get -y update
apt-get -y install golang-go
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

apt-get -y autoclean
