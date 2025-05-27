FROM fedora:latest

# User editable variabled
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""
ENV NEOVIM_TAR_DOWNLOAD="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ENV NEOVIM_FILE="nvim-linux-x86_64"

# Periodic updates for the latest NVM version
ENV NVM_VERSION="v0.40.3"
ENV NVM_DOWNLOAD="https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh"
ENV PNPM_DOWNLOAD="https://get.pnpm.io/install.sh"

# Constants, do not change
ENV USERNAME="dd-container"
ENV LANGUAGE="typescript"
LABEL identity="dd-typescript"


# Install base system dependencies
RUN dnf upgrade -y && dnf install -y \
  git \
  nano \
  openssh-clients \
  ripgrep \
  gcc \
  unzip \
  awk \
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


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# nvm and pnpm setup
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE

RUN curl -o- $NVM_DOWNLOAD | bash \
  && curl -fsSL $PNPM_DOWNLOAD | sh - \
  && . ~/.bashrc \
  && nvm install --lts \
  && pnpm init \
  && pnpm add typescript tsx -D \
  && pnpm tsc --init


# Work Directory set, Github configuration
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
