FROM ubuntu

EXPOSE 8998

RUN apt-get update && apt-get install -y curl wget tmux vim tree watch git \
    software-properties-common build-essential gcc g++ cmake ninja-build \
    zlib1g-dev libffi-dev libcpprest-dev \
    python-dev python-pip python3 python3-pip python3-venv \ 
    libboost-atomic-dev libboost-thread-dev libboost-system-dev libboost-date-time-dev \
    libboost-regex-dev libboost-filesystem-dev libboost-random-dev libboost-chrono-dev \
    libboost-serialization-dev libwebsocketpp-dev openssl libssl-dev 

RUN useradd -m -s /bin/bash me
USER me
WORKDIR /home/me

ENV USER=me
ENV PATH="/home/me/.cargo/bin:/home/me/.local/bin:${PATH}"
ENV TERM screen-256color

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

RUN pip install awscli --upgrade --user

COPY bashrc.sh /home/me/.bashrc.sh
COPY init.sh /home/me/.init.sh
COPY tmux.conf /home/me/.tmux.conf
COPY vimrc /home/me/.vimrc

RUN echo "source /home/me/.bashrc.sh" >> /home/me/.bashrc
RUN echo "/home/me/.init.sh" >> /home/me/.bashrc

RUN mkdir -p /home/me/.vim/colors && \
    curl -o /home/me/.vim/colors/gruvbox.vim https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim && \
    git clone https://github.com/VundleVim/Vundle.vim.git /home/me/.vim/bundle/Vundle.vim && \
    vim +'PluginInstall' +qa
