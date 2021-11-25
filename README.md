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

# Notes:

- code-server: would be the simplest, but the question is the extensions: all from market, or vsopen only? If so risk that no platformio... Seems like the extensions come from vsopen only... In this case, it is not really an option.
- vsc in browser with vnc server: may be an option?

When using vnc:

Only allow local connections - only let people connect if they already have access to your computer.

Start your VNC server in "once" mode - tell your VNC server to allow one connection, then block anything after that.

Set a password - require people to send a password before they can connect. 
