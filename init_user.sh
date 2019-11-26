#!/bin/bash

pip install awscli --upgrade --user

curl https://raw.githubusercontent.com/chrmi/dev/master/bashrc >> $HOME/.bashrc

curl -o $HOME/.tmux.conf https://raw.githubusercontent.com/chrmi/dev/master/tmux.conf

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim && \
curl -o $HOME/.vimrc https://raw.githubusercontent.com/chrmi/dev/master/vimrc && \
vim +'PlugInstall --sync' +qa
