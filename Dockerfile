# to use this container, we suggest:
# todo: show typical docker command to run, with right port forwarding etc

############################################################

# the usual derive and metadata

FROM ubuntu:20.04

LABEL maintainer_name="Jean Rabault"
LABEL maintainer_email="jean.rblt@gmail.com"

############################################################

# locals, tzdata etc

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

############################################################

# basic packages we need

RUN apt-get update --fix-missing -y && \
    apt-get upgrade -y && \
    apt-get install apt-utils -y && \
    apt-get install git -y && \
    apt-get install wget -y && \
    apt-get install gpg -y && \
    apt-get autoremove -y

############################################################

# install vnc server
# todo: the example I saw used x11vnc; but maybe / is another solution better fitted? What about https://wiki.archlinux.org/title/TigerVNC or similar?

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y x11vnc xvfb

# what program vnc should start and make available; by default, code will open the content of the to_open folder
RUN echo "exec code to_open" > ~/.xinitrc && chmod +x ~/.xinitrc

############################################################

# install vsc, the static libraries it needs, and the extensions

# from https://code.visualstudio.com/docs/setup/linux#_installation
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    rm -f packages.microsoft.gpg && \
    apt install apt-transport-https -y && \
    apt update && \
    apt install code -y

# vsc needs quite a few static libraries not included in 20.04 docker image
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libxshmfence-dev && \
    apt-get install -y libasound2

# install stuff that needs only user rights now
# this was creating some issues, so comment for now, but try to re-set as user mode later on, so that the VSC extensions are not run as root...
# todo: find a way to work as user regarding vsc extensions
# RUN useradd -ms /bin/bash developer
# USER developer

# add needed vsc extensions
# from my machine: code --list-extensions to show the extensions that I am using locally, copying the ones I need
# todo: for now setting all of this as root; this is BAD; fix to install in userspace
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

############################################################

# install all the necessary apollo3 sparkfun core v1.xx code

# todo

# install all the libraries needed to build to waves in ice instrument

# todo

############################################################

# how and where to start stuff

ADD ./to_open /to_open

# todo: use ENTRYPOINT or CMD or both together? ... not clear, see:
# https://phoenixnap.com/kb/docker-cmd-vs-entrypoint
# https://phoenixnap.com/kb/how-to-containerize-applications
# https://www.bmc.com/blogs/docker-cmd-vs-entrypoint/
# todo: for now use CMD, investigate in more details some day...

# script to allow launching vsc automatically at container startup
# COPY docker_entrypoint.sh /usr/local/bin/
# ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]

# what to launch at startup
CMD ["v11vnc", "-create", "-forever"]
