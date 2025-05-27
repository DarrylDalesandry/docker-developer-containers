# Docker Developer Containers

This project is intended to provide small containers that can be used to learn
 the basics of different programming languages.

Websites have been decreasing the number of virtual systems that you can use
to run a simple developer environment. This project can be used to run
many different languages in small containers with minimal packages.

This project contains Dockerfiles, and executable scripts, to get different
containerized developer environments securely setup and securely running.

All developer environments are built on top of the Fedora Docker container.

This is also an opinionated project. The expectation of the build files is that
you are using Neovim as your editor, that you have your Neovim configuration
saved as a dotfiles repository using GitHub. Also, the expectation is that you
will use ssh to clone and push updates to your projects via GitHub.

This project is built for me, which means it may not be suitable for your needs
without modification. Feel free to then use this project as a reference for your
own Dockerfiles.

## The languages available are:
- Arduino
- C
- Go
- Java
- Lua
- Python
- Rust
- TypeScript

## Setup, Variable Initialization

Within each folder for these languages is a Dockerfile. The first three
variables are the same across each file:
- GITHUB_EMAIL: The email address associated with your GitHub account.
- GITHUB_USERNAME: The username for your GitHub account.
- DOTFILE_REPO: The name of your dotfile repository (not the full URL).

These variables are used for commands such as:

```Dockerfile
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git \
  /home/$USERNAME/.config/

RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/

USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
```

The LABEL "identity" is used with the accompanying execution script to securely
instantiate a Docker container. The label is used to uniquely identify a single
container and attach to it. The container is volatile, once the container is
exited by the user, the container will delete itself. All content in the
container will be gone.

The containers will also bind to the user's folder, `~/.ssh`. This is to
securely allow the user's ssh keys to be accessed by the container, to be used
with GitHub. With the ssh keys not being transferred during the building of
Docker images, there are no records of the keys in the image's history, and the
container is deleted upon exit.

Unique variables for periodic updates will be noted in the language
sections below.

## Standard User Permissions, Not Root

One of the primary goals of these build files, is to make sure that when the
user attaches to a container, that they access a user account that does not have
the ability to run commands as root, or super user. This means that `sudo`
commands will not work in the container's tty.

All material needed to have a basic developer environment is provided in the
container itself. So that the user does not need to edit any other files.

## How to Start a Container

For instructions on how to install Docker, see [Install Docker Engine](https://docs.docker.com/engine/install/).

After Docker Engine is installed:
```bash
git clone https://github.com/DarrylDalesandry/docker-developer-containers.git

cd docker-developer-containers
```
Using C as the example, open a text editor to the C environment's Dockerfile:
```bash
nvim ./c/Dockerfile
```
Then edit the three empty string variables with your information. Then, after
writing and saving:
```bash
docker build ./c
```

This will build the docker container for the C environment. After
the image is built, it can then be started with the command:
```bash
./c/start-c.sh
```

Each language folder has its own `start` shell script that will find and attach
to a single container.

*If a single developer environment has multiple images built, for example by
running a build command on the `rust` folder twice, then the script to start a
rust container will not work. One of the two rust images must be removed.*

<br>

## Language Environments
### Arduino

A container for writing sketches for Arduino microcontrollers and compatibles.
This Dockerfile was originally written for me, which the Arduino board I like to
use is the SparkFun RedBoard. The Dockerfile is created to run an Arduino
compatible, and can be modified to use official Arduino boards if wanted.

If you are using the Uno itself, you can comment out every line that contains
the variable: `$ADDITIONAL_CORE`, then set the `$ADDITIONAL_FQBN` variable to
the value: `arduino:avr:uno`.

The user account that is connected to will have access to the `dialout` group,
which allows the account to upload sketches to a board. The default port for
SparkFun RedBoards is `/dev/ttyUSB0`. If you use a different port, this will
need updated on the last line of the Dockerfile, and the `start-arduino.sh`
bash script.

The Dockerfile will need three additional variables set before running:
- ADDITIONAL_CORE: the core of a compatible board, ex: SparkFun:avr
- ADDITIONAL_FQBN: the full name of the board, ex: SparkFun:avr:RedBoard
- ADDITIONAL_URL: the web address needed for arduino-cli to import cores

The SparkFun additional url is listed on their [webpage here](https://learn.sparkfun.com/tutorials/installing-arduino-ide/board-add-ons-with-arduino-board-manager).

The tool `arduino-cli` is installed, which provides a command-line tool to
download Arduino cores, compile sketches, and upload them to your board. The
cores installed in this Dockerfile are AVR cores, used in Atmel
microcontrollers. The most popular Arduino board that uses AVR cores is the Uno.

The configuration of `arduino-cli` compiles sketches to your project directory,
rather than the container's `~/.cache` folder.

To make sure that you have the correct USB port selected to communicate to your
Arduino, please consult the official [documentation here](https://docs.arduino.cc/arduino-cli/).

The Arduino Language Server needs both `arduino-language-server` and `clangd`
installed to work. A project file is also initialized, so you don't have set one
up yourself in order to get the language server to work.

<br>

---
### C
The standard compiler, gcc, is here for your introduction to the C language. The
compiler is installed from the DNF package manager.

<br>

---
### Go
Go is installed through downloading a tar archive, extracting the contents, and
adding it's `bin` folder to the `$PATH` variable.

The variable `GO_VERSION` will need to be periodically updated when a new
version of Go is made available.

<br>

---
### Java
The specific version of Java installed is an OpenJDK, Adoptium Temurin. This
version of Java is installed by adding the Adoptium repository to DNF and
installing through the package manager.

For more information about Temurin, [click here](https://adoptium.net/docs/faq/).

The variable `OPENJDK_LTS` will need periodic updates as newer LTS versions
of OpenJDK are released.

The variable `FEDORA_VERSION` will need periodic updates as Fedora releases
new versions every six months. Adoptium usually has the latest version of
Fedora updated in their repos about two to three weeks after the latest
version of Fedora is released.

<br>

---
### Lua
The Lua installation is the most unique. A tar archive file is downloaded, and
extracted. However, the extracted files are source code, not binary executable
files. The Dockerfile then compiles Lua using `make`, followed by installing
the binaries after they are built.

The variable `LUA_VERSION` will need periodic updates as newer versions of
Lua are developed.

<br>

---
### Python
The simplest of the builds, the latest version of Python3 is downloaded directly
from the DNF package manager. No versioning needs to be kept track of.

The Python package `source` is installed via pip3, to allow a virtual
environment to be setup on Python projects.

A virtual environment is not setup by default, using a virtual environment for
Python is considered good practice. The commands to get a virtual environment
setup are:

```bash
python3 -m venv ./
source ./bin/activate
```

The first command, `python3 -m venv ./` downloads and adds files and folders
that make virtual environments possible.

The second command executes the virtual environment. This is done so that
Python code only applies to the virtual environment, and not to the Linux
operating system. If your terminal looks like:

```bash
(python) [dd-container@{docker_image_ID} python]$
```

Then you have a virtual environment setup correctly.

<br>

---
### Rust
Rust's configuration is also unique. A shell script called `rustup` is
downloaded and run. This is used to install the Rust compiler and the package
manager `cargo`. In order for a Language Server to work with Rust, cargo
needs to initialize in a project folder.

When attaching to the Rust container built from this project, the user will
need to change directory to `./src`. A file will exist named `main.rs`. This
file can then be opened to edit.

<br>

---
### TypeScript
The TypeScript container can be used for both JavaScript and TypeScript. This
configuration is also opinionated. The [Node Version Manager](https://github.com/nvm-sh/nvm) (NVM) script is
downloaded and run. This will install the latest LTS version of Node during
the build process, as well as Node Package Manger (NPM). This build file will
also download the [PNPM package manager](https://pnpm.io/) configuration and install it.

The TypeScript configuration has two initializations, one for PNPM initializing
a project, and a second for TypeScript. TypeScript itself is not installed
globally, so to use the TypeScript compiler, commands will need to be run with:
```bash
pnpm tsc ./file.ts
```

The other package installed is `tsx`. This allows a TypeScript file to be
executed without needing to be compiled to JavaScript first, then run with the
`node` command. The `tsx` package is run with the command:
```bash
pnpm tsx ./file.ts
```
<br>

---
### Almost Everything
As the name says, if you really want to, you can have almost all language
environments added to a single container.

This was made as a "final boss" kind of Dockerfile, to finish the project. It
was never intended for someone to actually use all these languages in a single
container, but if that is something you want to use, have fun!

When attaching to `everything`, each language will have its own separate folder
from where the working directory starts. Rust will initiate a project in its
own folder, as well as TypeScript.

#### Update
When I first made this project, it did not inlude Arduino. I don't see a reason
to include Arduino to the **Everything** section, because there are a lot of
different boards and core combinations that I think would make the **Everything**
section a bit too convoluted.

Programming languages can be setup with only a few variables, but to account for
different families of hardware, I didn't want to make something to address all
of the different combinations.
