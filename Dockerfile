FROM ubuntu

EXPOSE 8097
EXPOSE 8098
EXPOSE 8099

RUN apt-get -y update
RUN apt-get install -y vim tmux wget curl tree watch cmake software-properties-common build-essential git \
    gdb g++ libglib2.0-dev nodejs npm openjdk-8-jre openjdk-8-jre openjdk-8-jre-headless \
    python3-dev python-pip python3-pip 

RUN add-apt-repository ppa:gophers/archive
RUN apt-get -y update
RUN apt-get -y install golang-1.10-go

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
RUN apt-get -y autoclean

RUN npm install -g n
RUN npm install -g npm
RUN n stable

RUN useradd -m -s /bin/bash d
USER d
WORKDIR /home/d

ENV TERM screen-256color

ENV USER=d
ENV NODE_ENV="development"
ENV GOPATH="/home/d/pub/go"
ENV PATH="/usr/lib/go-1.10/bin:/home/d/.npm-global/bin:/home/d/.cargo/bin:/home/d/pub/go/bin:/home/d/.local/bin:${PATH}"

RUN npm config set prefix=$HOME/.npm-global
RUN npm install -g typescript ts-node serverless

RUN pip install awscli --upgrade --user

RUN git clone https://github.com/chrmi/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
RUN curl -o $HOME/.vimrc https://raw.githubusercontent.com/chrmi/dev/master/vimrc
RUN mkdir $HOME/.vim/colors && curl -o $HOME/.vim/colors/gruvbox.vim https://raw.githubusercontent.com/chrmi/gruvbox/master/colors/gruvbox.vim
RUN vim +PluginInstall +qall

RUN curl https://raw.githubusercontent.com/chrmi/dev/master/bashrc >> $HOME/.bashrc
