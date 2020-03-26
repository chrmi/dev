FROM ubuntu

# For running services locally in SSH (for development debugging).
EXPOSE 8998

# General updates & tools
RUN apt-get update && apt-get install -y curl wget tmux vim tree watch git unzip \
    # Python development
    python-dev python-pip python3 python3-pip python3-venv \
    # C++ development
    software-properties-common build-essential gcc g++ cmake ninja-build \
    # Google Test: https://github.com/google/googletest
    libgtest-dev \
    # Microsoft C++ Rest SDK and dependencies: https://github.com/microsoft/cpprestsdk
    zlib1g-dev libffi-dev libcpprest-dev \
    # C++ Boost and dependencies (OpenSSL): https://www.boost.org/
    libboost-atomic-dev libboost-thread-dev libboost-system-dev libboost-date-time-dev \
    libboost-regex-dev libboost-filesystem-dev libboost-random-dev libboost-chrono-dev \
    libboost-serialization-dev libwebsocketpp-dev openssl libssl-dev 

# Install Google Test (libgtest-dev package installed above, compiled here).
RUN cd /usr/src/gtest && cmake CMakeLists.txt && make && cp *.a /usr/lib

# Install Google Cloud SDK.
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk kubectl -y

# Install Helm.
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install Terraform.
RUN curl -o tf.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip && \
    unzip tf.zip && \
    mv terraform /usr/bin && \
    rm tf.zip

# Create user, switch to it for remainder of install, and when SSH.
RUN useradd -m -s /bin/bash me
USER me
WORKDIR /home/me

ENV USER=me

# Set path for Cargo (Rust), local/bin for Pip (Python).
ENV PATH="/home/me/.cargo/bin:/home/me/.local/bin:${PATH}"

# Retain colors within SSH.
ENV TERM screen-256color

# Install Rust.
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Install PIP.
RUN pip install awscli --upgrade --user

# Add public Helm charts.
RUN helm repo add stable https://kubernetes-charts.storage.googleapis.com/
RUN helm repo add bitnami https://charts.bitnami.com/bitnami
RUN helm repo update

# Copy dot files for startup in SSH.
COPY bashrc.sh /home/me/.bashrc.sh
COPY init.sh /home/me/.init.sh
COPY tmux.conf /home/me/.tmux.conf
COPY vimrc /home/me/.vimrc

# Initiate above dot files in SSH.
RUN echo "source /home/me/.bashrc.sh" >> /home/me/.bashrc
RUN echo "/home/me/.init.sh" >> /home/me/.bashrc

# Install Vim colors and plugins.
RUN mkdir -p /home/me/.vim/colors && \
    curl -o /home/me/.vim/colors/gruvbox.vim https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim && \
    git clone https://github.com/VundleVim/Vundle.vim.git /home/me/.vim/bundle/Vundle.vim && \
    vim +'PluginInstall' +qa
