FROM fedora:latest

# User editable variabled
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""

ENV BOARD_FQBN="arduino:avr:uno"
ENV BOARD_CORE="arduino:avr"

ENV NEOVIM_TAR_DOWNLOAD="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ENV NEOVIM_FILE="nvim-linux-x86_64"

# Constants, do not change
ENV USERNAME="dd-container"
ENV ARDUINO_DOWNLOAD="https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh"
LABEL identity="dd-arduino"

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
RUN usermod -a -G dialout $USERNAME

ADD $NEOVIM_TAR_DOWNLOAD /opt/
RUN tar -xf /opt/$NEOVIM_FILE.tar.gz -C /opt/ && \
    rm /opt/$NEOVIM_FILE.tar.gz


# Environment setup
ENV PATH="$PATH:/opt/$NEOVIM_FILE/bin"
RUN mkdir -p /home/$USERNAME/ && \
    mkdir -m 700 /home/$USERNAME/.ssh

RUN mkdir -p /home/$USERNAME/.config/


# Adding arduino-cli
RUN mkdir /home/$USERNAME/.local/
ADD $ARDUINO_DOWNLOAD /home/$USERNAME/.local
WORKDIR /home/$USERNAME/.local
RUN sh /home/$USERNAME/.local/install.sh
RUN rm /home/$USERNAME/.local/install.sh

# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/

# Work Directory set, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME


# arduino-cli setup
RUN /home/$USERNAME/.local/bin/arduino-cli config init && \
    echo "sketch:" >> /home/$USERNAME/.arduino15/arduino-cli.yaml && \
    echo "  always_export_binaries: true" >> /home/$USERNAME/.arduino15/arduino-cli.yaml
RUN /home/$USERNAME/.local/bin/arduino-cli core update-index
RUN /home/$USERNAME/.local/bin/arduino-cli core install $BOARD_CORE

RUN touch /home/$USERNAME/sketch.yaml
RUN echo "default_fqbn: $BOARD_FQBN" >> /home/$USERNAME/sketch.yaml
RUN echo "default_port: /dev/ttyACM0" >> /home/$USERNAME/sketch.yaml
