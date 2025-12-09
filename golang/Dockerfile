FROM fedora:latest

# User editable variabled
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""

ENV NEOVIM_TAR_DOWNLOAD="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ENV NEOVIM_FILE="nvim-linux-x86_64"

# Periodic updates for the latest version of Go
ENV GO_VERSION="1.25.5"
ENV GO_TAR_FILE="go$GO_VERSION.linux-amd64.tar.gz"

# Constants, do not change
ENV USERNAME="dd-container"
ENV LANGUAGE="go"
LABEL identity="dd-go"


# Install base system dependencies
RUN dnf upgrade -y && dnf install -y \
  git \
  nano \
  openssh-clients \
  ripgrep \
  gcc \
  unzip \
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


# Installing Go from tar
ADD "https://go.dev/dl/$GO_TAR_FILE" /opt/
RUN tar -xf "/opt/$GO_TAR_FILE" -C /opt/
RUN rm "/opt/$GO_TAR_FILE"
ENV PATH="$PATH:/opt/go/bin"


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# Work Directory set, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
