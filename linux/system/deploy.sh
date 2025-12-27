#!/usr/bin/env bash

# APT
install -v -D ./etc/apt/apt.conf.d/99-slim-apt.conf /etc/apt/apt.conf.d/99-slim-apt.conf
cat /etc/apt/apt.conf.d/99-slim-apt.conf

# DOCKER
mkdir -pv /home/docker
install -v -D ./etc/docker/daemon.json /etc/docker/daemon.json

# NETWORK
install -v -D ./etc/NetworkManager/conf.d/99-custom.conf /etc/NetworkManager/conf.d/99-custom.conf
cat /etc/NetworkManager/conf.d/99-custom.conf

# SHELL
install -v -D ./etc/bash.bashrc /etc/bash.bashrc
cat /etc/bash.bashrc

# SUDO
install -v -D ./etc/sudoers.d/99-custom /etc/sudoers.d/99-custom
cat /etc/sudoers.d/99-custom

# WSL
install -v -D ./etc/wsl.conf /etc/wsl.conf
