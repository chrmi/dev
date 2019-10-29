#!/bin/bash

sudo apt-get update && sudo apt-get install -y curl git vim tmux tree watch 
git clone https://github.com/chrmi/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
curl -o $HOME/.vimrc https://raw.githubusercontent.com/chrmi/dev/master/vimrc
vim +PluginInstall +qall

curl https://raw.githubusercontent.com/chrmi/dev/master/bashrc >> $HOME/.bashrc
