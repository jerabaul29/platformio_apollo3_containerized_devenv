FROM ubuntu:20.04

LABEL maintainer_name="Jean Rabault"
LABEL maintainer_email="jean.rblt@gmail.com"

# fix locals
RUN apt-get update --fix-missing -y && \
    apt-get install -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# setup TZDATA in non interactive mode
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Oslo
RUN apt-get update && apt-get install -y tzdata

# update and add some basic tooling
RUN apt-get update --fix-missing -y && \
    apt-get upgrade -y && \
    apt-get install apt-utils -y && \
    apt-get install git -y && \
    apt-get install wget -y && \
    apt-get install gpg -y && \
    apt-get autoremove -y

# install vsc
# from https://code.visualstudio.com/docs/setup/linux#_installation
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    rm -f packages.microsoft.gpg && \
    apt install apt-transport-https -y && \
    apt update && \
    apt install code -y

# vsc needs quite a few static libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libxshmfence-dev && \
    apt-get install -y libasound2

# install stuff that needs only user rights now
# RUN useradd -ms /bin/bash developer
# USER developer

# add needed vsc extensions
# from my machine: code --list-extensions to show the extensions that I am using locally, copying the ones I need
RUN mkdir pio_dir
RUN code --user-data-dir pio_dir --install-extension CoenraadS.bracket-pair-colorizer-2 && \
    code --user-data-dir pio_dir --install-extension ionutvmi.path-autocomplete && \
    code --user-data-dir pio_dir --install-extension jeff-hykin.better-cpp-syntax && \
    code --user-data-dir pio_dir --install-extension kevinglasson.cornflakes-linter && \
    code --user-data-dir pio_dir --install-extension ms-vscode.cmake-tools && \
    code --user-data-dir pio_dir --install-extension ms-vscode.cpptools && \
    code --user-data-dir pio_dir --install-extension ms-vscode.cpptools-extension-pack && \
    code --user-data-dir pio_dir --install-extension ms-vscode.cpptools-themes && \
    code --user-data-dir pio_dir --install-extension platformio.platformio-ide && \
    code --user-data-dir pio_dir --install-extension vscodevim.vim && \
    code --user-data-dir pio_dir --install-extension yzhang.markdown-all-in-one && \
    code --user-data-dir pio_dir --install-extension streetsidesoftware.code-spell-checker

# install all the necessary apollo3 sparkfun core v1.xx code
# todo

ADD ./to_open /to_open

# script to allow launching vsc automatically at container startup
# COPY docker_entrypoint.sh /usr/local/bin/
# ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]