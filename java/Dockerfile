FROM fedora:latest

# User editable variables
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""
ENV NEOVIM_TAR_DOWNLOAD="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ENV NEOVIM_FILE="nvim-linux-x86_64"

# Periodic updates for the latest OpenJDK version and Fedora version
ENV OPENJDK_LTS="21"
ENV FEDORA_VERSION="42"

# Constants, do not change
ENV USERNAME="dd-container"
ENV LANGUAGE="java"
LABEL identity="dd-java"


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


# Adding Temurin JDK repo and installing
RUN touch /etc/yum.repos.d/adoptium.repo
RUN echo "[ADOPTIUM]" >> /etc/yum.repos.d/adoptium.repo && \
    echo "name=Adoptium" >> /etc/yum.repos.d/adoptium.repo && \
    echo "baseurl=https://packages.adoptium.net/artifactory/rpm/fedora/$FEDORA_VERSION/\$basearch" >> /etc/yum.repos.d/adoptium.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/adoptium.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/adoptium.repo && \
    echo "gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public" >> /etc/yum.repos.d/adoptium.repo 

RUN dnf update && dnf install temurin-$OPENJDK_LTS-jdk -y


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# User account assigned, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
