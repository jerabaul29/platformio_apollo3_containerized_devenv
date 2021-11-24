FROM ubuntu:20.04
LABEL maintainer_name="Jean Rabault"
LABEL maintainer_email="jean.rblt@gmail.com"

# make sure to fix locals
RUN apt-get update && apt-get upgrade -y && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# update and add some basic tooling
RUN apt-get update --fix-missing -y && \
    apt-get upgrade -y && \
    apt-get install apt-utils -y && \
    apt-get install git -y && \
    apt-get autoremove -y

# use snap for vsc, this is the simplest
RUN sudo snap install --classic code

# add needed vsc extensions
RUN code --install-extension CoenraadS.bracket-pair-colorizer-2 && \
    code --install-extension ionutvmi.path-autocomplete && \
    code --install-extension jeff-hykin.better-cpp-syntax && \
    code --install-extension kevinglasson.cornflakes-linter && \
    code --install-extension ms-vscode.cmake-tools && \
    code --install-extension ms-vscode.cpptools && \
    code --install-extension ms-vscode.cpptools-extension-pack && \
    code --install-extension ms-vscode.cpptools-themes && \
    code --install-extension platformio.platformio-ide && \
    code --install-extension vscodevim.vim && \
    code --install-extension yzhang.markdown-all-in-one && \
    code --install-extension streetsidesoftware.code-spell-checker

# install all the necessary apollo3 sparkfun core v1.xx code

# script to allow launching vsc automatically at container startup
COPY docker_entrypoint.sh /usr/local/bin/

ADD ./code /code

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]