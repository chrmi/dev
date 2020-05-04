FROM chrmi-dev-base/a as base

# For running services locally in SSH (for development debugging).
EXPOSE 8097
EXPOSE 8098
EXPOSE 8099
EXPOSE 8998

# Install Google Cloud SDK.
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk kubectl -y

# Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && apt-get install azure-cli

# Install Google Test (libgtest-dev package installed above, compiled here).
RUN cd /usr/src/gtest && cmake CMakeLists.txt && make && cp *.a /usr/lib

# Install Helm.
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install Terraform.
RUN curl -o tf.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip && \
    unzip tf.zip && \
    mv terraform /usr/bin && \
    rm tf.zip

# Install Go
RUN curl https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz | tar -C /usr/local -xz

# Create user
RUN useradd -m -s /bin/bash me

# Switch to user for remainder of install, and when SSH.
USER me

# Set User directory and start path from SSH.
WORKDIR /home/me

ENV USER=me

# Set path for Cargo (Rust), local/bin for Pip (Python), /usr/local/go/bin (Go).
ENV PATH="/usr/local/go/bin:/home/me/.cargo/bin:/home/me/.local/bin:${PATH}"

# Retain colors within SSH.
ENV TERM screen-256color

# Install Rust.
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Add public Helm charts.
RUN helm repo add stable https://kubernetes-charts.storage.googleapis.com/
RUN helm repo add bitnami https://charts.bitnami.com/bitnami
RUN helm repo update

# Install AWS CLI.
RUN pip install awscli --upgrade --user

# Download gRPC Root Cert for GPC C++ SDK
RUN curl -o /home/me/.certs/roots.pem --create-dirs https://raw.githubusercontent.com/grpc/grpc/master/etc/roots.pem
ENV GRPC_DEFAULT_SSL_ROOTS_FILE_PATH /home/me/.certs/roots.pem

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

