FROM fedora:latest

# User editable variabled
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""
ENV NEOVIM_TAR_DOWNLOAD="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ENV NEOVIM_FILE="nvim-linux-x86_64"

# Constants, do not change
ENV USERNAME="dd-container"
ENV LANGUAGE="python"
LABEL identity="dd-python"


# Install base system dependencies
RUN dnf upgrade -y && dnf install -y \
  gcc \
  git \
  nano \
  openssh-clients \
  ripgrep \
  python3 \
  python3-pip \
  && dnf autoremove -y

RUN pip install --upgrade pip
RUN pip3 install source


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


# Work Directory set, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
