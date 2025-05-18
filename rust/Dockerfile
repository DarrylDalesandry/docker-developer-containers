FROM fedora:latest

# User editable variables
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""
ENV NEOVIM_TAR_DOWNLOAD="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ENV NEOVIM_FILE="nvim-linux-x86_64"

# Constants, do not change
ENV USERNAME="dd-container"
ENV LANGUAGE="rust"
LABEL identity="dd-rust"


# Install base system dependencies
RUN echo 'fastestmirror=True' >> /etc/dnf/dnf.conf

RUN dnf upgrade -y && dnf install -y \
    git \
    nano \
    openssh-clients \
    ripgrep \
    gcc \
    && dnf autoremove -y


# Non-admin account & Neovim setup
RUN useradd -m -d /home/$USERNAME $USERNAME

ADD $NEOVIM_TAR_DOWNLOAD /opt/
RUN tar -xf /opt/$NEOVIM_FILE.tar.gz -C /opt/ && \
    rm /opt/$NEOVIM_FILE.tar.gz


# Environment setup
ENV PATH="$PATH:/opt/$NEOVIM_FILE/bin"
RUN mkdir -p /home/$USERNAME/$LANGUAGE && \
    mkdir -m 0755 /home/$USERNAME/.ssh

RUN mkdir -p /home/$USERNAME/.config/
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git /home/$USERNAME/.config/


# Fetching rustup script
ADD https://sh.rustup.rs /home/$USERNAME/sh.rustup.rs


# Account setup, prep for getting rust installed as standard user
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/
USER $USERNAME
WORKDIR /home/$USERNAME/


# Installing rustup and adding rust
RUN cat /home/$USERNAME/sh.rustup.rs | sh -s -- -y && \
    . /home/$USERNAME/.cargo/env && \
    rm /home/$USERNAME/sh.rustup.rs


# Set work directory, Github configuration, initialize Rust
WORKDIR /home/$USERNAME/$LANGUAGE
RUN . /home/$USERNAME/.cargo/env && cargo init
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
