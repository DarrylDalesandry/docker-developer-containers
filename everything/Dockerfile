FROM fedora:latest

# User editable variabled
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""
ENV NEOVIM_TAR_DOWNLOAD="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ENV NEOVIM_FILE="nvim-linux-x86_64"

# Versions of all languages not in DNF
ENV GO_VERSION="1.24.3"
ENV GO_TAR_FILE="go$GO_VERSION.linux-amd64.tar.gz"

ENV OPENJDK_LTS="21"
ENV FEDORA_VERSION="42"

ENV LUA_VERSION="5.4.7"

ENV NVM_VERSION="v0.40.3"
ENV NVM_DOWNLOAD="https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh"
ENV PNPM_DOWNLOAD="https://get.pnpm.io/install.sh"


# Constants, do not change
ENV USERNAME="dd-container"
ENV LANGUAGE="everything"
LABEL identity="dd-all"


# Install base system dependencies
#  also installs minimum requirements for C and Python
RUN echo 'fastestmirror=True' >> /etc/dnf/dnf.conf

RUN dnf upgrade -y && dnf install -y \
  git \
  nano \
  openssh-clients \
  ripgrep \
  gcc \
  unzip \
  make \
  python3 \
  python3-pip \
  awk \
  && dnf autoremove -y

# Installing "source" to allow venv setup
RUN pip install --upgrade pip
RUN pip3 install source

# Non-admin account & Neovim setup
RUN useradd -m -d /home/$USERNAME $USERNAME

ADD $NEOVIM_TAR_DOWNLOAD /opt/
RUN tar -xf /opt/$NEOVIM_FILE.tar.gz -C /opt/ && \
    rm /opt/$NEOVIM_FILE.tar.gz


# Environment setup
ENV PATH="$PATH:/opt/$NEOVIM_FILE/bin"
RUN mkdir -m 0755 /home/$USERNAME/.ssh

RUN mkdir -p /home/$USERNAME/.config/
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git /home/$USERNAME/.config/

# Creating all runtime folders
RUN mkdir /home/$USERNAME/$LANGUAGE && \
    mkdir /home/$USERNAME/$LANGUAGE/c && \
    mkdir /home/$USERNAME/$LANGUAGE/go && \
    mkdir /home/$USERNAME/$LANGUAGE/java && \
    mkdir /home/$USERNAME/$LANGUAGE/lua && \
    mkdir /home/$USERNAME/$LANGUAGE/python && \
    mkdir /home/$USERNAME/$LANGUAGE/rust && \
    mkdir /home/$USERNAME/$LANGUAGE/typescript


# Rust installation script
ADD https://sh.rustup.rs /home/$USERNAME/sh.rustup.rs

# Installing Go from tar
ADD "https://go.dev/dl/$GO_TAR_FILE" /opt/
RUN tar -xf "/opt/$GO_TAR_FILE" -C /opt/
RUN rm "/opt/$GO_TAR_FILE"
ENV PATH="$PATH:/opt/go/bin"

# Adding Temurin JDK repo and installing
RUN touch /etc/yum.repos.d/adoptium.repo
RUN echo "[ADOPTIUM]" >> /etc/yum.repos.d/adoptium.repo && \
    echo "name=Adoptium" >> /etc/yum.repos.d/adoptium.repo && \
    echo "baseurl=https://packages.adoptium.net/artifactory/rpm/fedora/$FEDORA_VERSION/\$basearch" >> /etc/yum.repos.d/adoptium.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/adoptium.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/adoptium.repo && \
    echo "gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public" >> /etc/yum.repos.d/adoptium.repo 

RUN dnf update && dnf install temurin-$OPENJDK_LTS-jdk -y

# Installing Lua compiler and interpreter, from source
ADD "https://www.lua.org/ftp/lua-$LUA_VERSION.tar.gz" /opt/
RUN tar -xf /opt/lua-$LUA_VERSION.tar.gz -C /opt/
WORKDIR /opt/lua-$LUA_VERSION/
RUN make
RUN make install
WORKDIR /
RUN dnf remove make -y && dnf install gcc -y
RUN rm -r /opt/lua*


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# Changing user, installing remaining environments
USER $USERNAME

# Rust initializing
RUN cat /home/$USERNAME/sh.rustup.rs | sh -s -- -y && \
    . /home/$USERNAME/.cargo/env && \
    rm /home/$USERNAME/sh.rustup.rs

WORKDIR /home/$USERNAME/$LANGUAGE/rust
RUN . /home/$USERNAME/.cargo/env && cargo init

# TypeScript setup
WORKDIR /home/$USERNAME/$LANGUAGE/typescript
RUN curl -o- $NVM_DOWNLOAD | bash \
  && curl -fsSL $PNPM_DOWNLOAD | sh - \
  && . ~/.bashrc \
  && nvm install --lts \
  && pnpm init \
  && pnpm add typescript tsx -D \
  && pnpm tsc --init


# Github Setup
WORKDIR /home/$USERNAME/$LANGUAGE/
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
