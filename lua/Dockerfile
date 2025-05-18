FROM fedora:latest

# User editable variables
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""
ENV NEOVIM_TAR_DOWNLOAD="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ENV NEOVIM_FILE="nvim-linux-x86_64"

# Periodic updates for the latest version of Lua
ENV LUA_VERSION="5.4.7"

# Constants, do not change
ENV USERNAME="dd-container"
ENV LANGUAGE="lua"
LABEL identity="dd-lua"


# Install base system dependencies
RUN echo 'fastestmirror=True' >> /etc/dnf/dnf.conf

RUN dnf upgrade -y && dnf install -y \
  git \
  nano \
  openssh-clients \
  ripgrep \
  gcc \
  unzip \
  make \
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


# Installing Lua compiler and interpreter, from source
ADD "https://www.lua.org/ftp/lua-$LUA_VERSION.tar.gz" /opt/
RUN tar -xf /opt/lua-$LUA_VERSION.tar.gz -C /opt/
WORKDIR /opt/lua-$LUA_VERSION/
RUN make
RUN make install
WORKDIR /
RUN dnf remove make -y && dnf install gcc -y
RUN rm -r /opt/lua*


# Build apps cleanup
#RUN dnf remove make -y && dnf autoremove -y


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# User account assigned, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
