#!/usr/bin/env bash

# APT
# sudo install -v -D ./etc/apt/apt.conf.d/99-slim-apt.conf /etc/apt/apt.conf.d/99-slim-apt.conf

# APPARMOUR
# sudo install -v -D ./etc/sysctl.d/99-kernel-apparmour /etc/sysctl.d/99-kernel-apparmour

# BASH
sudo install -v -D ./etc/bash.bashrc /etc/bash.bashrc

# BRAVE
sudo install -v -D ./etc/browser/policies/managed/brave.json /etc/brave/policies/managed/brave.json

# DOCKER
# sudo mkdir -pv /home/docker && sudo install -v -D ./etc/docker/daemon.json /etc/docker/daemon.json

# NETWORK
sudo install -v -D ./etc/NetworkManager/conf.d/99-custom.conf /etc/NetworkManager/conf.d/99-custom.conf

# SUDO
# sudo install -v -D ./etc/sudoers.d/99-custom /etc/sudoers.d/99-custom

# WSL
# sudo install -v -D ./etc/wsl.conf /etc/wsl.conf
