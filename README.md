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

```

```

# try again

try using something that follows:

jr@T490:~/Desktop/Current$ mkdir -p ~/.config
docker run -it --name code-server -p 127.0.0.1:8080:8080 \
  -v "$HOME/.config:/home/coder/.config" \
  -v "$PWD:/home/coder/project" \
  -u "$(id -u):$(id -g)" \
  -e "DOCKER_USER=$USER" \
  codercom/code-server:latest
