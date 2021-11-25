# platformio_apollo3_containerized_devenv

A containerized development environment for Platformio + Apollo3.

Inspired from, among others:

- https://binal.pub/2019/04/running-vscode-in-docker/
- https://github.com/caesarnine/data-science-docker-vscode-template

# Build

```
docker build -t vsc_platformio_apollo3 .
```

# Use

# Development notes

Here we write about the philosophy behind this container, why we build it, which technical solutions would be possible, which we choose, and what we should remember to set up with the solution we choose.

## What we want to do

We want to provide a portable, reproducible, easy-to-use, battery included development environment for programming the Sparkfun Apollo Ambiq3BLU bare metal core boards. To make this work across OSes, be reproducible and upgradable, etc, we think the best is to use some form of container, built from a standard dockerfile. To provide good tooling, we want the development environment to be based on Visual Studio Code (vsc) + Platformio + Apollo3 Platformio core + a number of help extensions + all the libraries necessary for the waves in ice drifter included by default. It should be possible to use this solution on any OS, without additional setup needed to get full language, autocomplete, linter, compiling etc support.

So, we want to write a dockerfile that allows to run vsc from within the container, with all the necessary extensions and tooling and libraries, and control it from the host machine through a portable solution such as a web browser.

## How we can do it

After doing a bit of research, there are a few candidate solutions to get what we want:

- code-server: would be the simplest to use, but the issue is the extensions: they are taken only from the open-vsx market; this means i) not certified (not clear for me if this has some effects on how safe), ii) some extensions are not available, for example platformio and ms-cpp are actually not available (I think; extensions available there under the same name are likely some 'home made' builds with some modifications, or some non really related stuff, or else). However, this is really easy to set up; for example, this is enough to fire code-server in a docker container that we can connect to in browser:

```
jr@T490:~/Desktop/Current$ mkdir -p ~/.config
docker run -it --name code-server -p 127.0.0.1:8080:8080 \
  -v "$HOME/.config:/home/coder/.config" \
  -v "$PWD:/home/coder/project" \
  -u "$(id -u):$(id -g)" \
  -e "DOCKER_USER=$USER" \
  codercom/code-server:latest
```

Unfortunately, since the core extensions needed are not available in "genuine" version, we cannot use this solution.

- vsc with X-display export: it is easy to set up a docker that has access to the host's X socket. However, 1) this will work on linux, not windows / mac, and only on X-based linux distros, ii) this will likely be a security risk. Therefore, this direction is not investigated further, though it should be quick and easy to set up.

- vsc in browser with vnc server: set up a vnc server in addition to code, and use it to provide code over a socket to be opened by any web browser. This is both safer and more portable - should work on any OS and system. This is the direction we want to investigate and implement.

## Some practicalities and things to keep in mind when setting a vnc server

When using vnc, be a bit secure; in the present image, we want to enforce:

- only allow local connections - only let people connect if they already have access to the host computer.
- start VNC server in "once" mode - tell VNC server to allow one connection, then block anything after that.
- set a password - require user to send a password before they can connect. 
