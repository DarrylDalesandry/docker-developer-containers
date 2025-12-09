FROM fedora:latest

# User editable variabled
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""

ENV ADDITIONAL_CORE="SparkFun:avr"
ENV ADDITIONAL_FQBN="SparkFun:avr:RedBoard"
ENV ADDITIONAL_URL="https://raw.githubusercontent.com/sparkfun/Arduino_Boards/main/IDE_Board_Manager/package_sparkfun_index.json"

ENV NEOVIM_TAR_DOWNLOAD="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ENV NEOVIM_FILE="nvim-linux-x86_64"

# Constants, do not change
ENV USERNAME="dd-container"
ENV LANGUAGE="arduino"
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
RUN mkdir -p /home/$USERNAME/$LANGUAGE && \
    mkdir -m 0755 /home/$USERNAME/.ssh

RUN mkdir -p /home/$USERNAME/.config/
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git /home/$USERNAME/.config/


# Adding arduino-cli
RUN mkdir /home/$USERNAME/.local/
ADD $ARDUINO_DOWNLOAD /home/$USERNAME/.local
WORKDIR /home/$USERNAME/.local
RUN sh /home/$USERNAME/.local/install.sh

# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/

# Work Directory set, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME


# arduino-cli setup
RUN touch arduino.ino
RUN /home/$USERNAME/.local/bin/arduino-cli config init && \
    sed -i "2d" /home/$USERNAME/.arduino15/arduino-cli.yaml && \
    echo "  additional_urls: [$ADDITIONAL_URL]" >> /home/$USERNAME/.arduino15/arduino-cli.yaml && \
    echo "sketch:" >> /home/$USERNAME/.arduino15/arduino-cli.yaml && \
    echo "  always_export_binaries: true" >> /home/$USERNAME/.arduino15/arduino-cli.yaml
RUN /home/$USERNAME/.local/bin/arduino-cli core update-index
RUN /home/$USERNAME/.local/bin/arduino-cli core install arduino:avr
RUN /home/$USERNAME/.local/bin/arduino-cli core install $ADDITIONAL_CORE
RUN touch /home/$USERNAME/$LANGUAGE/sketch.yaml
RUN echo "default_fqbn: $ADDITIONAL_FQBN" >> /home/$USERNAME/$LANGUAGE/sketch.yaml
RUN echo "default_port: /dev/ttyUSB0" >> /home/$USERNAME/$LANGUAGE/sketch.yaml
